package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * API Schema for FileUploadServlet
 * 
 * Endpoint: POST /api/upload
 * Content-Type: multipart/form-data
 * 
 * Request Parameters:
 * - type (Text): The type of file being uploaded. Allowed values: "profile_pic" or "material".
 * - file (File): The actual file part to be uploaded.
 * 
 * Authorization Requirements:
 * - "profile_pic": Any logged-in user (session contains userId).
 * - "material": Logged-in user with roleId = 1 (Admin) or 2 (Mentor).
 * 
 * Validation Constraints:
 * - File Size Limit: 50MB max per file.
 * - Allowed Extensions & Magic Bytes for "profile_pic": jpg, jpeg, png, webp, avif, gif.
 * - Allowed Extensions & Magic Bytes for "material" (document): pdf, docx, xlsx, pptx.
 * - Allowed Extensions & Magic Bytes for "material" (video): mp4, mov, webm.
 * - Allowed Extensions & Magic Bytes for "material" (audio): mp3, aac, wav, ogg, oga, flac.
 * 
 * Success Response (200 OK):
 * {
 *   "url": "/img/profile_pics/uuid-name.png",
 *   "fileName": "original-name.png",
 *   "fileId": "123"
 * }
 * 
 * Error Responses:
 * - 401 Unauthorized: {"error": "Unauthorized"}
 * - 400 Bad Request: {"error": "Missing upload type" | "Invalid upload type" | "No file uploaded" | "Invalid profile picture format" | "Invalid material format" | "Invalid file signature (Magic Byte Validation Failed)"}
 * - 403 Forbidden: {"error": "Forbidden: You cannot upload materials."}
 * - 500 Internal Server Error: {"error": "Server error during upload"}
 */
@WebServlet(name = "FileUploadServlet", urlPatterns = {"/api/upload"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50,      // 400MB
        maxRequestSize = 1024 * 1024 * 100   // 500MB
)
public class FileUploadServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    private static final Set<String> ALLOWED_PROFILE_PICS = Set.of("jpg", "jpeg", "png", "webp", "avif", "gif");
    private static final Set<String> ALLOWED_DOCUMENTS = Set.of("pdf", "docx", "xlsx", "pptx");
    private static final Set<String> ALLOWED_VIDEOS = Set.of("mp4", "mov", "webm");
    private static final Set<String> ALLOWED_AUDIOS = Set.of("mp3", "aac", "wav", "ogg", "oga", "flac");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // 1. Authentication Check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Unauthorized")));
            return;
        }

        Integer roleIdObj = (Integer) session.getAttribute("roleId");
        int roleId = (roleIdObj != null) ? roleIdObj : 0;
        String type = req.getParameter("type");

        if (type == null || type.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Missing upload type")));
            return;
        }

        // 2. Authorization Check
        if ("material".equals(type)) {
            if (roleId != 1 && roleId != 2) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Forbidden: You cannot upload materials.")));
                return;
            }
        } else if (!"profile_pic".equals(type)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid upload type")));
            return;
        }

        try {
            Part filePart = req.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "No file uploaded")));
                return;
            }

            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName == null || submittedFileName.contains("\u0000")) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid file name")));
                return;
            }

            int lastDotIndex = submittedFileName.lastIndexOf(".");
            if (lastDotIndex <= 0 || lastDotIndex == submittedFileName.length() - 1) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid file extension")));
                return;
            }

            String extension = submittedFileName.substring(lastDotIndex + 1).toLowerCase();

            // Sanitize filename and truncate to max 200 chars to prevent SQL DataTruncation
            String sanitizedFileName = submittedFileName.replaceAll("[^a-zA-Z0-9.\\-_]", "_");
            if (sanitizedFileName.length() > 200) {
                sanitizedFileName = sanitizedFileName.substring(0, 200);
            }

            // 3. Extension Validation
            boolean isDocument = ALLOWED_DOCUMENTS.contains(extension);
            boolean isVideo = ALLOWED_VIDEOS.contains(extension);
            boolean isAudio = ALLOWED_AUDIOS.contains(extension);

            if ("profile_pic".equals(type) && !ALLOWED_PROFILE_PICS.contains(extension)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid profile picture format")));
                return;
            } else if ("material".equals(type) && !isDocument && !isVideo && !isAudio) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid material format")));
                return;
            }

            // 4. Magic Byte Validation
            try (InputStream bufferedFileStream = new BufferedInputStream(filePart.getInputStream())) {
                if (!isMagicByteValid(extension, bufferedFileStream)) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Invalid file signature (Magic Byte Validation Failed)")));
                    return;
                }

                // 5. Save File
                String randomFileName = UUID.randomUUID().toString() + "." + extension;
                String relativeSaveDir = "/img/profile_pics";
                if ("material".equals(type)) {
                    if (isDocument) relativeSaveDir = "/material/document";
                    else if (isVideo) relativeSaveDir = "/material/video";
                    else if (isAudio) relativeSaveDir = "/material/audio";
                }
                String absoluteSavePath = req.getServletContext().getRealPath(relativeSaveDir);

                if (absoluteSavePath == null) {
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Server storage is not accessible.")));
                    return;
                }

                File saveDir = new File(absoluteSavePath);
                if (!saveDir.exists()) {
                    saveDir.mkdirs();
                }

                File targetFile = new File(saveDir, randomFileName);
                
                // Using copy because filePart.write() might complain about paths depending on Tomcat config
                Files.copy(bufferedFileStream, targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // 6. Database tracking
                String fileUrl = relativeSaveDir + "/" + randomFileName;
                int userId = (int) session.getAttribute("userId");
                dao.UploadedFileDAO fileDao = new dao.UploadedFileDAO();
                model.UploadedFile uploadedFile = new model.UploadedFile(sanitizedFileName, fileUrl, type, userId);
                uploadedFile = fileDao.save(uploadedFile);

                if (uploadedFile == null || uploadedFile.getFileId() <= 0) {
                    if (targetFile.exists()) {
                        targetFile.delete();
                    }
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Database error: Failed to save file metadata")));
                    return;
                }

                // 7. Response
                Map<String, String> result = new HashMap<>();
                result.put("url", fileUrl);
                result.put("fileName", sanitizedFileName);
                result.put("fileId", String.valueOf(uploadedFile.getFileId()));
                
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write(mapper.writeValueAsString(result));
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(mapper.writeValueAsString(Map.of("error", "Server error during upload")));
        }
    }

    private boolean isMagicByteValid(String extension, InputStream is) throws IOException {
        if (!is.markSupported()) {
            throw new IllegalArgumentException("Stream must support mark/reset");
        }
        is.mark(16);
        byte[] header = new byte[16];
        int bytesRead = is.readNBytes(header, 0, 16);
        is.reset();

        if (bytesRead < 4) return false;

        switch (extension) {
            case "jpg":
            case "jpeg":
                return header[0] == (byte) 0xFF && header[1] == (byte) 0xD8;
            case "png":
                return header[0] == (byte) 0x89 && header[1] == (byte) 0x50 &&
                       header[2] == (byte) 0x4E && header[3] == (byte) 0x47;
            case "gif":
                return header[0] == 'G' && header[1] == 'I' && header[2] == 'F';
            case "webp":
                if (bytesRead < 12) return false;
                return header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F' &&
                       header[8] == 'W' && header[9] == 'E' && header[10] == 'B' && header[11] == 'P';
            case "avif":
                if (bytesRead < 12) return false;
                // typically header[4-7] is 'ftyp', and AVIF uses 'avif' or 'avis' at offset 8
                return header[4] == 'f' && header[5] == 't' && header[6] == 'y' && header[7] == 'p' &&
                       ( (header[8] == 'a' && header[9] == 'v' && header[10] == 'i' && header[11] == 'f') ||
                         (header[8] == 'a' && header[9] == 'v' && header[10] == 'i' && header[11] == 's') );
            case "pdf":
                return header[0] == '%' && header[1] == 'P' && header[2] == 'D' && header[3] == 'F';
            case "docx":
            case "xlsx":
            case "pptx":
                return header[0] == 0x50 && header[1] == 0x4B && header[2] == 0x03 && header[3] == 0x04;
            case "mp4":
            case "mov":
                if (bytesRead < 8) return false;
                return header[4] == 'f' && header[5] == 't' && header[6] == 'y' && header[7] == 'p';
            case "webm":
                return header[0] == (byte) 0x1A && header[1] == (byte) 0x45 &&
                       header[2] == (byte) 0xDF && header[3] == (byte) 0xA3;
            case "mp3":
                return (header[0] == 'I' && header[1] == 'D' && header[2] == '3') ||
                       (header[0] == (byte) 0xFF && (header[1] & 0xE0) == 0xE0);
            case "aac":
                return header[0] == (byte) 0xFF && (header[1] & 0xF0) == 0xF0;
            case "wav":
                if (bytesRead < 12) return false;
                return header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F' &&
                       header[8] == 'W' && header[9] == 'A' && header[10] == 'V' && header[11] == 'E';
            case "ogg":
            case "oga":
                return header[0] == 'O' && header[1] == 'g' && header[2] == 'g' && header[3] == 'S';
            case "flac":
                return header[0] == 'f' && header[1] == 'L' && header[2] == 'a' && header[3] == 'C';
            default:
                return false;
        }
    }
}

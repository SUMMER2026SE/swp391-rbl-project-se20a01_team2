package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.TicketDAO;
import model.Ticket;
import services.AzureSpeechService;
import services.GeminiApiService;
import services.TicketService;
import util.AudioConverterUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.concurrent.CompletableFuture;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TicketAIApiServlet", urlPatterns = {"/api/ticket/ai", "/api/ticket/status"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB
    maxRequestSize = 1024 * 1024 * 30     // 30MB
)
public class TicketAIApiServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TicketAIApiServlet.class.getName());
    private TicketService ticketService;
    private TicketDAO ticketDAO;
    private AzureSpeechService azureSpeechService;
    private GeminiApiService geminiApiService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        ticketService = new TicketService();
        ticketDAO = new TicketDAO();
        gson = new Gson();
        geminiApiService = new GeminiApiService();
        String speechKey = System.getProperty("SPEECH_KEY");
        String speechRegion = System.getProperty("SPEECH_REGION");
        if (speechKey != null && !speechKey.isBlank()) {
            try {
                azureSpeechService = new AzureSpeechService(speechKey, speechRegion);
            } catch (Exception e) {
                LOGGER.severe("Cannot init AzureSpeechService: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy status
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(401);
            resp.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }
        
        String ticketIdStr = req.getParameter("id");
        if (ticketIdStr == null) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\": \"Missing id\"}");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = ticketDAO.findById(ticketId).orElse(null);
            if (ticket == null) {
                resp.setStatus(404);
                resp.getWriter().write("{\"error\": \"Ticket not found\"}");
                return;
            }

            JsonObject json = new JsonObject();
            json.addProperty("status", ticket.getStatus());
            json.addProperty("ticketType", ticket.getTicketType());
            json.addProperty("transcript", ticket.getTranscript());
            json.addProperty("aiReport", ticket.getAiReport());
            
            resp.getWriter().write(gson.toJson(json));
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"Server error\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(401);
            resp.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String subject = req.getParameter("subject");
        String content = req.getParameter("content");
        String ticketType = req.getParameter("ticketType");

        if (ticketType == null) ticketType = "General";

        try {
            Ticket ticket = ticketService.createTicket(userId, subject, content);
            ticket.setTicketType(ticketType);
            ticketDAO.updateAIReport(ticket.getTicketId(), null, null, null, "Processing"); // Tạm để Processing

            if ("Speaking".equals(ticketType)) {
                Part audioPart = req.getPart("audioFile");
                if (audioPart != null && audioPart.getSize() > 0) {
                    // Lưu file .webm
                    String uploadsDir = getServletContext().getRealPath("/uploads/tickets");
                    File dir = new File(uploadsDir);
                    if (!dir.exists()) dir.mkdirs();
                    
                    String filename = "ticket_" + ticket.getTicketId() + "_" + System.currentTimeMillis() + ".webm";
                    File webmFile = new File(dir, filename);
                    Files.copy(audioPart.getInputStream(), webmFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    
                    String mediaUrl = req.getContextPath() + "/uploads/tickets/" + filename;
                    ticketDAO.updateAIReport(ticket.getTicketId(), mediaUrl, null, null, "Processing");

                    // Chạy background process AI
                    processSpeakingTicketAsync(ticket.getTicketId(), webmFile, mediaUrl);
                    
                    JsonObject res = new JsonObject();
                    res.addProperty("ticketId", ticket.getTicketId());
                    res.addProperty("status", "Processing");
                    resp.getWriter().write(gson.toJson(res));
                    return;
                }
            } else if ("Writing".equals(ticketType)) {
                // Background process Writing AI
                processWritingTicketAsync(ticket.getTicketId(), content);
                
                JsonObject res = new JsonObject();
                res.addProperty("ticketId", ticket.getTicketId());
                res.addProperty("status", "Processing");
                resp.getWriter().write(gson.toJson(res));
                return;
            }

            // Mặc định General hoặc không có file
            ticketDAO.updateAIReport(ticket.getTicketId(), null, null, null, "Open");
            JsonObject res = new JsonObject();
            res.addProperty("ticketId", ticket.getTicketId());
            res.addProperty("status", "Open");
            resp.getWriter().write(gson.toJson(res));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating ticket", e);
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void processSpeakingTicketAsync(int ticketId, File webmFile, String originalMediaUrl) {
        CompletableFuture.runAsync(() -> {
            try {
                LOGGER.info("Bắt đầu xử lý AI Speaking cho Ticket #" + ticketId);
                // 1. Chuyển đổi đuôi file sang WAV
                File wavFile = null;
                try {
                    wavFile = AudioConverterUtil.convertWebmToWav(webmFile);
                } catch (Exception e) {
                    LOGGER.warning("FFmpeg conversion failed: " + e.getMessage() + " - Tiêp tục gửi file gốc lên AI (nếu hỗ trợ)");
                    wavFile = webmFile; // Fallback
                }
                
                // 2. Azure Speech-to-Text
                String transcript = "Không thể nhận diện âm thanh.";
                double score = 0;
                if (azureSpeechService != null) {
                    var azureResult = azureSpeechService.assessPronunciation(wavFile, "");
                    if (azureResult.isSuccess()) {
                        transcript = azureResult.getRecognizedText();
                        score = azureResult.getPronunciationScore();
                    }
                }

                // 3. Gemini AI chấm điểm và bôi đỏ lỗi sai
                String schema = "{" +
                    "  \"type\": \"OBJECT\"," +
                    "  \"properties\": {" +
                    "    \"grammar_errors\": {" +
                    "      \"type\": \"ARRAY\"," +
                    "      \"items\": {" +
                    "        \"type\": \"OBJECT\"," +
                    "        \"properties\": {" +
                    "          \"mistake\": {\"type\": \"STRING\"}," +
                    "          \"correction\": {\"type\": \"STRING\"}" +
                    "        }" +
                    "      }" +
                    "    }," +
                    "    \"score\": {\"type\": \"NUMBER\"}," +
                    "    \"feedback\": {\"type\": \"STRING\"}" +
                    "  }," +
                    "  \"required\": [\"grammar_errors\", \"score\", \"feedback\"]" +
                    "}";
                
                String systemInstruction = "Hãy đóng vai giám khảo IELTS. Chấm đoạn transcript Speaking sau và trả về ĐÚNG định dạng JSON này, không giải thích gì thêm. Điểm phát âm sơ bộ từ hệ thống là " + score + "/100.";
                String aiReport = geminiApiService.generateStructuredContent(systemInstruction, "Transcript: " + transcript, schema);

                // 4. Update DB (Open ticket cho Mentor)
                ticketDAO.updateAIReport(ticketId, originalMediaUrl, transcript, aiReport, "Open");
                LOGGER.info("Hoàn tất xử lý AI Speaking cho Ticket #" + ticketId);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi xử lý background Ticket", e);
                ticketDAO.updateAIReport(ticketId, originalMediaUrl, "Lỗi hệ thống khi xử lý audio.", null, "Open");
            }
        });
    }

    private void processWritingTicketAsync(int ticketId, String content) {
        CompletableFuture.runAsync(() -> {
            try {
                LOGGER.info("Bắt đầu xử lý AI Writing cho Ticket #" + ticketId);
                String schema = "{" +
                    "  \"type\": \"OBJECT\"," +
                    "  \"properties\": {" +
                    "    \"grammar_errors\": {" +
                    "      \"type\": \"ARRAY\"," +
                    "      \"items\": {" +
                    "        \"type\": \"OBJECT\"," +
                    "        \"properties\": {" +
                    "          \"mistake\": {\"type\": \"STRING\"}," +
                    "          \"correction\": {\"type\": \"STRING\"}" +
                    "        }" +
                    "      }" +
                    "    }," +
                    "    \"score\": {\"type\": \"NUMBER\"}," +
                    "    \"feedback\": {\"type\": \"STRING\"}" +
                    "  }," +
                    "  \"required\": [\"grammar_errors\", \"score\", \"feedback\"]" +
                    "}";
                
                String systemInstruction = "Hãy đóng vai giám khảo IELTS. Chấm đoạn text sau và trả về ĐÚNG định dạng JSON này, không giải thích gì thêm.";
                String aiReport = geminiApiService.generateStructuredContent(systemInstruction, "Bài viết: " + content, schema);

                ticketDAO.updateAIReport(ticketId, null, null, aiReport, "Open");
                LOGGER.info("Hoàn tất xử lý AI Writing cho Ticket #" + ticketId);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi xử lý background Writing", e);
                ticketDAO.updateAIReport(ticketId, null, null, null, "Open");
            }
        });
    }
}

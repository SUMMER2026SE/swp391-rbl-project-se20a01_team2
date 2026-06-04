package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.PronunciationResult;
import services.AzureSpeechService;
import services.SubmissionService;
import services.SubmissionServiceImpl;
import services.AIEvaluationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/speech/assess")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 20,  // 20MB
        maxRequestSize = 1024 * 1024 * 25 // 25MB
)
public class SpeechAssessmentServlet extends HttpServlet {

    private AzureSpeechService speechService;
    private ObjectMapper objectMapper;
    private SubmissionService submissionService;
    private AIEvaluationService aiEvaluationService;

    @Override
    public void init() throws ServletException {
        super.init();
        objectMapper = new ObjectMapper();
        submissionService = new SubmissionServiceImpl();
        aiEvaluationService = new AIEvaluationService();
        
        try {
            // Lấy key từ System Properties (đã được nạp từ .env bởi AppContextListener)
            String speechKey = System.getProperty("SPEECH_KEY");
            String speechRegion = System.getProperty("SPEECH_REGION");
            
            if (speechKey == null || speechKey.isEmpty() || speechRegion == null || speechRegion.isEmpty()) {
                System.err.println("CẢNH BÁO: Không tìm thấy SPEECH_KEY hoặc SPEECH_REGION. Vui lòng kiểm tra file .env");
            }
            
            speechService = new AzureSpeechService(speechKey, speechRegion);
        } catch (Exception e) {
            System.err.println("Lỗi khởi tạo AzureSpeechService: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> responseData = new HashMap<>();

        try {
            // Lấy đoạn văn bản gốc mà user được yêu cầu đọc
            String referenceText = req.getParameter("referenceText");
            
            // Nhận detailId từ request để map với Database
            String detailIdStr = req.getParameter("detailId");
            int detailId = -1;
            if (detailIdStr != null && !detailIdStr.trim().isEmpty()) {
                try {
                    detailId = Integer.parseInt(detailIdStr);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid detailId format: " + detailIdStr);
                }
            }
            
            // Nhận cờ báo hiệu đây là bài nói tự do (Frontend gửi STT lên làm kịch bản)
            String isUnscriptedStr = req.getParameter("isUnscripted");
            boolean isUnscripted = Boolean.parseBoolean(isUnscriptedStr);

            Part filePart = req.getPart("audioFile");

            // Validation cơ bản
            if (filePart == null || filePart.getSize() == 0) {
                sendError(resp, 400, "Vui lòng đính kèm file âm thanh (audioFile).");
                return;
            }
            if (referenceText == null || referenceText.trim().isEmpty()) {
                // Nếu không có referenceText, tức là kịch bản STT tự do (Task 60)
                handleFreeSpeechToText(filePart, resp);
                return;
            }

            // Lưu file tạm thời lên server để Azure SDK đọc (Azure SDK yêu cầu file vật lý hoặc Stream đặc thù)
            File tempAudioFile = File.createTempFile("candidate_audio_", ".wav");
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, tempAudioFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // Gửi qua Service chấm điểm
            PronunciationResult result = speechService.assessPronunciation(tempAudioFile, referenceText);
            
            // Xóa file tạm
            tempAudioFile.delete();

            if (result.isSuccess()) {
                responseData.put("success", true);
                responseData.put("data", result);
                
                // Lưu kết quả vào DB nếu có truyền detailId (Trường hợp 1)
                if (detailId > 0) {
                    boolean isSaved = submissionService.updateSpeakingEvaluation(
                            detailId, 
                            result.getRecognizedText(), 
                            result.getPronunciationScore()
                    );
                    if (!isSaved) {
                        System.err.println("Cảnh báo: Không thể lưu kết quả Speaking vào DB cho DetailID = " + detailId);
                    } else if (isUnscripted) {
                        // Kích hoạt tiến trình chấm IELTS Speaking với Gemini
                        String topic = submissionService.getQuestionContentByDetailId(detailId);
                        if (topic != null) {
                            aiEvaluationService.evaluateSpeakingAsync(detailId, topic, result.getRecognizedText(), result.getPronunciationScore());
                        } else {
                            System.err.println("Không thể lấy đề bài (topic) để chấm AI cho DetailID = " + detailId);
                        }
                    }
                }
                
                resp.setStatus(200);
            } else {
                sendError(resp, 500, result.getErrorMessage());
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "Lỗi Server Nội bộ: " + e.getMessage());
            return;
        }

        objectMapper.writeValue(resp.getWriter(), responseData);
    }

    /**
     * Xử lý trường hợp chỉ cần Speech-to-Text (Không có đoạn văn chuẩn)
     */
    private void handleFreeSpeechToText(Part filePart, HttpServletResponse resp) throws IOException {
        Map<String, Object> responseData = new HashMap<>();
        File tempAudioFile = File.createTempFile("stt_audio_", ".wav");
        try {
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, tempAudioFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            String transcript = speechService.speechToText(tempAudioFile);
            
            responseData.put("success", true);
            responseData.put("data", Map.of("transcript", transcript));
            resp.setStatus(200);

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "Lỗi nhận diện Speech-To-Text: " + e.getMessage());
            return;
        } finally {
            tempAudioFile.delete();
        }
        objectMapper.writeValue(resp.getWriter(), responseData);
    }

    private void sendError(HttpServletResponse resp, int statusCode, String message) throws IOException {
        resp.setStatus(statusCode);
        Map<String, Object> errorResp = new HashMap<>();
        errorResp.put("success", false);
        errorResp.put("error", message);
        objectMapper.writeValue(resp.getWriter(), errorResp);
    }
}

package services;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import dao.AIEvaluationDAO;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.FeedbackMistake;
import model.FeedbackWriting;
import model.FeedbackSpeaking;
import model.MentorSkillStat;

/**
 * Service điều phối việc chấm điểm Writing và Speaking bằng Gemini AI.
 *
 * Luồng hoạt động:
 *   1. Nhận bài làm từ Servlet (Writing essay hoặc Speaking transcript)
 *   2. Gọi bất đồng bộ GeminiApiService.generateStructuredContent()
 *   3. Parse JSON kết quả thành FeedbackWriting / FeedbackSpeaking
 *   4. Lưu JSON gốc vào bảng AIEvaluations
 *   5. Cập nhật điểm Band và OverallBand vào TestSubmissions
 */
public class AIEvaluationService {

    private static final Logger LOGGER = Logger.getLogger(AIEvaluationService.class.getName());

    private final GeminiApiService geminiApiService;
    private final AIEvaluationDAO  aiEvaluationDAO;
    private final ObjectMapper     objectMapper;

    // =========================================================================
    // JSON Schema cho Writing (4 tiêu chí IELTS chuẩn)
    // =========================================================================
    private static final String WRITING_SCHEMA =
        "{"
        + "\"type\":\"object\","
        + "\"properties\":{"
        +   "\"taskResponse\":{\"type\":\"number\",\"description\":\"Score for Task Response (0-9)\"},"
        +   "\"coherenceAndCohesion\":{\"type\":\"number\",\"description\":\"Score for Coherence and Cohesion (0-9)\"},"
        +   "\"lexicalResource\":{\"type\":\"number\",\"description\":\"Score for Lexical Resource (0-9)\"},"
        +   "\"grammaticalRangeAndAccuracy\":{\"type\":\"number\",\"description\":\"Score for Grammatical Range and Accuracy (0-9)\"},"
        +   "\"overallBand\":{\"type\":\"number\",\"description\":\"Overall Band Score (0-9)\"},"
        +   "\"overallFeedback\":{\"type\":\"string\",\"description\":\"General feedback and comments in Vietnamese\"},"
        +   "\"mistakes\":{"
        +     "\"type\":\"array\","
        +     "\"items\":{"
        +       "\"type\":\"object\","
        +       "\"properties\":{"
        +         "\"mistake\":{\"type\":\"string\"},"
        +         "\"reason\":{\"type\":\"string\"},"
        +         "\"correction\":{\"type\":\"string\"}"
        +       "},"
        +       "\"required\":[\"mistake\",\"reason\",\"correction\"]"
        +     "}"
        +   "},"
        +   "\"improvementSuggestions\":{"
        +     "\"type\":\"array\","
        +     "\"items\":{\"type\":\"string\"},"
        +     "\"description\":\"Danh sách các gợi ý cải thiện điểm (từ vựng, cấu trúc ngữ pháp, diễn đạt, v.v.) viết bằng tiếng Việt.\""
        +   "}"
        + "},"
        + "\"required\":[\"taskResponse\",\"coherenceAndCohesion\",\"lexicalResource\","
        +              "\"grammaticalRangeAndAccuracy\",\"overallBand\",\"overallFeedback\",\"mistakes\",\"improvementSuggestions\"]"
        + "}";

    // =========================================================================
    // JSON Schema cho Speaking (4 tiêu chí IELTS chuẩn)
    // =========================================================================
    private static final String SPEAKING_SCHEMA =
        "{"
        + "\"type\":\"object\","
        + "\"properties\":{"
        +   "\"fluencyAndCoherence\":{\"type\":\"number\",\"description\":\"Score for Fluency and Coherence (0-9)\"},"
        +   "\"lexicalResource\":{\"type\":\"number\",\"description\":\"Score for Lexical Resource (0-9)\"},"
        +   "\"grammaticalRangeAndAccuracy\":{\"type\":\"number\",\"description\":\"Score for Grammatical Range and Accuracy (0-9)\"},"
        +   "\"pronunciation\":{\"type\":\"number\",\"description\":\"Score for Pronunciation (0-9)\"},"
        +   "\"overallBand\":{\"type\":\"number\",\"description\":\"Overall Band Score (0-9)\"},"
        +   "\"overallFeedback\":{\"type\":\"string\",\"description\":\"General feedback and comments in Vietnamese\"},"
        +   "\"mistakes\":{"
        +     "\"type\":\"array\","
        +     "\"items\":{"
        +       "\"type\":\"object\","
        +       "\"properties\":{"
        +         "\"mistake\":{\"type\":\"string\"},"
        +         "\"reason\":{\"type\":\"string\"},"
        +         "\"correction\":{\"type\":\"string\"}"
        +       "},"
        +       "\"required\":[\"mistake\",\"reason\",\"correction\"]"
        +     "}"
        +   "},"
        +   "\"improvementSuggestions\":{"
        +     "\"type\":\"array\","
        +     "\"items\":{\"type\":\"string\"},"
        +     "\"description\":\"Danh sách các gợi ý cải thiện điểm (từ vựng, cấu trúc ngữ pháp, diễn đạt, v.v.) viết bằng tiếng Việt.\""
        +   "}"
        + "},"
        + "\"required\":[\"fluencyAndCoherence\",\"lexicalResource\",\"grammaticalRangeAndAccuracy\","
        +              "\"pronunciation\",\"overallBand\",\"overallFeedback\",\"mistakes\",\"improvementSuggestions\"]"
        + "}";

    public AIEvaluationService() {
        this.geminiApiService = new GeminiApiService();
        this.aiEvaluationDAO  = new AIEvaluationDAO();
        // FAIL_ON_UNKNOWN_PROPERTIES=false: tránh lỗi nếu AI trả về field lạ
        this.objectMapper = new ObjectMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    // =========================================================================
    // WRITING EVALUATION
    // =========================================================================

    /**
     * Chạy bất đồng bộ việc chấm điểm Writing.
     *
     * @param detailId  ID của SubmissionDetails row
     * @param topic     Đề bài Writing
     * @param essay     Bài làm của thí sinh
     * @return CompletableFuture với kết quả FeedbackWriting (null nếu thất bại)
     */
    public CompletableFuture<FeedbackWriting> evaluateWritingAsync(int detailId, String topic, String essay) {
        return CompletableFuture.supplyAsync(() -> {
            LOGGER.info("[Writing] Starting evaluation for DetailID: " + detailId);

            // Nghỉ 3 giây trước mỗi call để tránh rate-limit khi nhiều task chạy tuần tự
            try { Thread.sleep(3000); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); return null; }

            // Xử lý bài làm null/rỗng
            String safeEssay = (essay == null || essay.isBlank()) ? "" : essay.trim();

            String systemInstruction =
                "Bạn là giám khảo chấm thi IELTS Writing chuyên nghiệp với 20 năm kinh nghiệm.\n"
                + "NHIỆM VỤ: Đánh giá bài IELTS Writing dựa trên 4 tiêu chí chuẩn của British Council.\n"
                + "QUY TẮC BẮT BUỘC:\n"
                + "1. Nếu bài làm trống hoặc dưới 10 từ: chấm 0 điểm tất cả, overallFeedback = 'Bài làm trống hoặc quá ngắn.', mistakes = [], improvementSuggestions = []\n"
                + "2. KHÔNG tự sáng tác bài làm từ đề bài.\n"
                + "3. TẤT CẢ nhận xét viết bằng Tiếng Việt (trừ khi trích dẫn lỗi sai tiếng Anh).\n"
                + "4. BẮT BUỘC cung cấp các gợi ý cụ thể để cải thiện điểm (từ vựng, cấu trúc ngữ pháp, cách diễn đạt...) trong mảng improvementSuggestions.\n"
                + "5. Trả về ĐÚNG format JSON được yêu cầu, KHÔNG thêm text ngoài JSON.";

            String userPrompt = "ĐỀ BÀI:\n" + topic + "\n\nBÀI LÀM:\n" + safeEssay;

            String jsonResult = geminiApiService.generateStructuredContent(
                    systemInstruction, userPrompt, WRITING_SCHEMA);

            if (jsonResult == null) {
                LOGGER.severe("[Writing] Gemini returned null for DetailID: " + detailId
                        + ". Check GeminiApiService logs for API errors.");
                return null;
            }

            LOGGER.info("[Writing] Gemini returned result for DetailID: " + detailId
                    + " - Preview: " + jsonResult.substring(0, Math.min(100, jsonResult.length())));

            try {
                FeedbackWriting feedback = objectMapper.readValue(jsonResult, FeedbackWriting.class);

                // Lưu JSON gốc vào AIEvaluations
                aiEvaluationDAO.insertAIEvaluation(detailId, jsonResult);

                // Cập nhật điểm vào TestSubmissions
                aiEvaluationDAO.updateTestSubmissionBand(
                        detailId, feedback.getOverallBand(), "Writing", feedback.getOverallFeedback());

                LOGGER.info("[Writing] Completed for DetailID: " + detailId
                        + " | Band: " + feedback.getOverallBand());
                return feedback;

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE,
                        "[Writing] Failed to parse JSON for DetailID: " + detailId
                        + " | JSON was: " + jsonResult.substring(0, Math.min(300, jsonResult.length())), e);
                return null;
            }
        });
    }

    // =========================================================================
    // SPEAKING EVALUATION
    // =========================================================================

    /**
     * Chạy bất đồng bộ việc chấm điểm Speaking.
     *
     * @param detailId             ID của SubmissionDetails row
     * @param topic                Câu hỏi/chủ đề Speaking
     * @param transcript           Bản text từ Speech-to-Text
     * @param azurePronScore       Điểm phát âm từ Azure (thang 0-100)
     * @return CompletableFuture với kết quả FeedbackSpeaking (null nếu thất bại)
     */
    public CompletableFuture<FeedbackSpeaking> evaluateSpeakingAsync(
            int detailId, String topic, String transcript, double azurePronScore) {

        return CompletableFuture.supplyAsync(() -> {
            LOGGER.info("[Speaking] Starting evaluation for DetailID: " + detailId);

            // Nghỉ 3 giây trước mỗi call để tránh rate-limit khi nhiều task chạy tuần tự
            try { Thread.sleep(3000); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); return null; }

            // Xử lý transcript null/rỗng
            String safeTranscript = (transcript == null || transcript.isBlank()) ? "" : transcript.trim();

            String systemInstruction =
                "Bạn là giám khảo chấm thi IELTS Speaking chuyên nghiệp với 20 năm kinh nghiệm.\n"
                + "NHIỆM VỤ: Đánh giá phần thi IELTS Speaking dựa trên 4 tiêu chí chuẩn của British Council.\n"
                + "THÔNG TIN PHÁT ÂM: Hệ thống Azure AI đã chấm điểm phát âm: "
                + String.format("%.1f", azurePronScore) + "/100. "
                + "Quy đổi điểm này sang thang IELTS 0-9 để điền vào tiêu chí 'pronunciation'.\n"
                + "QUY TẮC BẮT BUỘC:\n"
                + "1. Nếu transcript trống hoặc dưới 5 từ: chấm 0 điểm tất cả, overallFeedback = 'Thí sinh chưa nói hoặc ghi âm quá ngắn.', mistakes = [], improvementSuggestions = []\n"
                + "2. KHÔNG tự sáng tác transcript.\n"
                + "3. TẤT CẢ nhận xét viết bằng Tiếng Việt (trừ khi trích dẫn lỗi sai tiếng Anh).\n"
                + "4. BẮT BUỘC cung cấp các gợi ý cụ thể để cải thiện điểm (từ vựng, cấu trúc ngữ pháp, cách diễn đạt...) trong mảng improvementSuggestions.\n"
                + "5. Trả về ĐÚNG format JSON được yêu cầu, KHÔNG thêm text ngoài JSON.";

            String userPrompt = "CÂU HỎI:\n" + topic + "\n\nLỜI NÓI (TRANSCRIPT):\n" + safeTranscript;

            String jsonResult = geminiApiService.generateStructuredContent(
                    systemInstruction, userPrompt, SPEAKING_SCHEMA);

            if (jsonResult == null) {
                LOGGER.severe("[Speaking] Gemini returned null for DetailID: " + detailId
                        + ". Check GeminiApiService logs for API errors.");
                return null;
            }

            LOGGER.info("[Speaking] Gemini returned result for DetailID: " + detailId
                    + " - Preview: " + jsonResult.substring(0, Math.min(100, jsonResult.length())));

            try {
                FeedbackSpeaking feedback = objectMapper.readValue(jsonResult, FeedbackSpeaking.class);

                // Lưu JSON gốc vào AIEvaluations
                aiEvaluationDAO.insertAIEvaluation(detailId, jsonResult);

                // Cập nhật điểm vào TestSubmissions
                aiEvaluationDAO.updateTestSubmissionBand(
                        detailId, feedback.getOverallBand(), "Speaking", feedback.getOverallFeedback());

                LOGGER.info("[Speaking] Completed for DetailID: " + detailId
                        + " | Band: " + feedback.getOverallBand());
                return feedback;

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE,
                        "[Speaking] Failed to parse JSON for DetailID: " + detailId
                        + " | JSON was: " + jsonResult.substring(0, Math.min(300, jsonResult.length())), e);
                return null;
            }
        });
    }

    private static final Map<String, String> REASON_KEYWORDS = new LinkedHashMap<>();
    static {
        REASON_KEYWORDS.put("Grammar",     "grammar|tense|verb|subject|agreement|clause|syntax|article");
        REASON_KEYWORDS.put("Vocabulary",  "vocabulary|word choice|lexical|collocation|synonym|idiom|diction");
        REASON_KEYWORDS.put("Coherence",   "coherence|cohesion|structure|paragraph|transition|organization|flow");
        REASON_KEYWORDS.put("Pronunciation","pronunciation|sound|phoneme|intonation|stress|accent");
        REASON_KEYWORDS.put("Fluency",     "fluency|hesitation|pace|pause|filler");
    }

    private String categorize(String reason) {
        if (reason == null) return "Other";
        String lower = reason.toLowerCase();
        for (Map.Entry<String, String> entry : REASON_KEYWORDS.entrySet()) {
            if (lower.matches(".*(" + entry.getValue() + ").*")) {
                return entry.getKey();
            }
        }
        return "Other";
    }

    public Map<String, MentorSkillStat> getMentorStats(int mentorId) {
        Map<String, MentorSkillStat> statMap = new LinkedHashMap<>();
        statMap.put("Writing", new MentorSkillStat());
        statMap.get("Writing").setSkill("Writing");
        statMap.put("Speaking", new MentorSkillStat());
        statMap.get("Speaking").setSkill("Speaking");

        List<Object[]> rows = aiEvaluationDAO.getAllFeedbackByMentor(mentorId);
        Map<String, Double> bandSumMap = new HashMap<>();
        bandSumMap.put("Writing", 0.0);
        bandSumMap.put("Speaking", 0.0);

        for (Object[] row : rows) {
            String json  = (String) row[0];
            String skill = (String) row[1];
            if (json == null || skill == null) continue;

            MentorSkillStat stat = statMap.get(skill);
            if (stat == null) continue;

            try {
                List<FeedbackMistake> mistakes;
                double band;
                if ("Writing".equalsIgnoreCase(skill)) {
                    FeedbackWriting fw = objectMapper.readValue(json, FeedbackWriting.class);
                    mistakes = fw.getMistakes();
                    band = fw.getOverallBand();
                } else {
                    FeedbackSpeaking fs = objectMapper.readValue(json, FeedbackSpeaking.class);
                    mistakes = fs.getMistakes();
                    band = fs.getOverallBand();
                }
                stat.setSubmissionCount(stat.getSubmissionCount() + 1);
                bandSumMap.put(skill, bandSumMap.get(skill) + band);

                if (mistakes != null) {
                    stat.setTotalMistakes(stat.getTotalMistakes() + mistakes.size());
                    for (FeedbackMistake m : mistakes) {
                        String cat = categorize(m.getReason());
                        stat.getMistakesByCategory().merge(cat, 1, Integer::sum);
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Không parse được feedbackJson, bỏ qua.", e);
            }
        }

        // Compute averages
        for (String skill : statMap.keySet()) {
            MentorSkillStat stat = statMap.get(skill);
            if (stat.getSubmissionCount() > 0) {
                stat.setAvgBand(bandSumMap.get(skill) / stat.getSubmissionCount());
            }
        }
        return statMap;
    }
}

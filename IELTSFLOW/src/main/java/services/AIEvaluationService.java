package services;

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

public class AIEvaluationService {
    private static final Logger LOGGER = Logger.getLogger(AIEvaluationService.class.getName());
    
    private final GeminiApiService geminiApiService;
    private final AIEvaluationDAO aiEvaluationDAO;
    private final ObjectMapper objectMapper;
    
    private static final String WRITING_SCHEMA = "{" +
            "  \"type\": \"OBJECT\"," +
            "  \"properties\": {" +
            "    \"taskResponse\": { \"type\": \"NUMBER\", \"description\": \"Score for Task Response (0-9)\" }," +
            "    \"coherenceAndCohesion\": { \"type\": \"NUMBER\", \"description\": \"Score for Coherence and Cohesion (0-9)\" }," +
            "    \"lexicalResource\": { \"type\": \"NUMBER\", \"description\": \"Score for Lexical Resource (0-9)\" }," +
            "    \"grammaticalRangeAndAccuracy\": { \"type\": \"NUMBER\", \"description\": \"Score for Grammatical Range and Accuracy (0-9)\" }," +
            "    \"overallBand\": { \"type\": \"NUMBER\", \"description\": \"Overall Band Score (0-9)\" }," +
            "    \"overallFeedback\": { \"type\": \"STRING\", \"description\": \"General feedback and comments\" }," +
            "    \"mistakes\": {" +
            "      \"type\": \"ARRAY\"," +
            "      \"description\": \"List of mistakes found\"," +
            "      \"items\": {" +
            "        \"type\": \"OBJECT\"," +
            "        \"properties\": {" +
            "          \"mistake\": { \"type\": \"STRING\", \"description\": \"The incorrect text\" }," +
            "          \"reason\": { \"type\": \"STRING\", \"description\": \"Why it is incorrect\" }," +
            "          \"correction\": { \"type\": \"STRING\", \"description\": \"Suggested correction\" }" +
            "        }," +
            "        \"required\": [\"mistake\", \"reason\", \"correction\"]" +
            "      }" +
            "    }" +
            "  }," +
            "  \"required\": [\"taskResponse\", \"coherenceAndCohesion\", \"lexicalResource\", \"grammaticalRangeAndAccuracy\", \"overallBand\", \"overallFeedback\", \"mistakes\"]" +
            "}";

    private static final String SPEAKING_SCHEMA = "{" +
            "  \"type\": \"OBJECT\"," +
            "  \"properties\": {" +
            "    \"fluencyAndCoherence\": { \"type\": \"NUMBER\", \"description\": \"Score for Fluency and Coherence (0-9)\" }," +
            "    \"lexicalResource\": { \"type\": \"NUMBER\", \"description\": \"Score for Lexical Resource (0-9)\" }," +
            "    \"grammaticalRangeAndAccuracy\": { \"type\": \"NUMBER\", \"description\": \"Score for Grammatical Range and Accuracy (0-9)\" }," +
            "    \"pronunciation\": { \"type\": \"NUMBER\", \"description\": \"Score for Pronunciation (0-9).\" }," +
            "    \"overallBand\": { \"type\": \"NUMBER\", \"description\": \"Overall Band Score (0-9)\" }," +
            "    \"overallFeedback\": { \"type\": \"STRING\", \"description\": \"General feedback and comments\" }," +
            "    \"mistakes\": {" +
            "      \"type\": \"ARRAY\"," +
            "      \"description\": \"List of mistakes found\"," +
            "      \"items\": {" +
            "        \"type\": \"OBJECT\"," +
            "        \"properties\": {" +
            "          \"mistake\": { \"type\": \"STRING\", \"description\": \"The incorrect text\" }," +
            "          \"reason\": { \"type\": \"STRING\", \"description\": \"Why it is incorrect\" }," +
            "          \"correction\": { \"type\": \"STRING\", \"description\": \"Suggested correction\" }" +
            "        }," +
            "        \"required\": [\"mistake\", \"reason\", \"correction\"]" +
            "      }" +
            "    }" +
            "  }," +
            "  \"required\": [\"fluencyAndCoherence\", \"lexicalResource\", \"grammaticalRangeAndAccuracy\", \"pronunciation\", \"overallBand\", \"overallFeedback\", \"mistakes\"]" +
            "}";
            
    public AIEvaluationService() {
        this.geminiApiService = new GeminiApiService();
        this.aiEvaluationDAO = new AIEvaluationDAO();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Chạy ngầm (Asynchronous) việc chấm điểm Writing
     *
     * @param detailId ID chi tiết bài làm
     * @param topic Đề bài
     * @param essay Bài làm của Candidate
     * @return CompletableFuture chứa kết quả FeedbackWriting
     */
    public CompletableFuture<FeedbackWriting> evaluateWritingAsync(int detailId, String topic, String essay) {
        return CompletableFuture.supplyAsync(() -> {
            LOGGER.info("Bắt đầu chấm điểm Writing cho DetailID: " + detailId);
            String systemInstruction = "Role: Bạn là giám khảo chấm thi IELTS Writing chuyên nghiệp.\n" +
                                       "Objective: Đánh giá bài IELTS Writing dựa trên 4 tiêu chí chuẩn.\n" +
                                       "Format: Trả về dữ liệu chính xác theo cấu trúc JSON được yêu cầu, KHÔNG giải thích thêm.";
            String userPrompt = "Đề bài: " + topic + "\nBài làm: " + essay;
            
            String jsonResult = geminiApiService.generateStructuredContent(systemInstruction, userPrompt, WRITING_SCHEMA);
            
            if (jsonResult != null) {
                try {
                    // Lưu DB
                    aiEvaluationDAO.insertAIEvaluation(detailId, jsonResult);
                    
                    // Parse thành object để có thể trả về cho Frontend nếu cần
                    FeedbackWriting feedback = objectMapper.readValue(jsonResult, FeedbackWriting.class);
                    
                    // Cập nhật điểm Band và Feedback lên bảng TestSubmissions
                    aiEvaluationDAO.updateTestSubmissionBand(detailId, feedback.getOverallBand(), "Writing", feedback.getOverallFeedback());
                    
                    LOGGER.info("Hoàn tất chấm điểm Writing cho DetailID: " + detailId);
                    return feedback;
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi parse JSON FeedbackWriting", e);
                }
            }
            return null;
        });
    }
    
    /**
     * Chạy ngầm (Asynchronous) việc chấm điểm Speaking
     *
     * @param detailId ID chi tiết bài làm
     * @param topic Chủ đề nói
     * @param transcript Bản dịch Speech-to-Text
     * @param azurePronunciationScore Điểm phát âm từ hệ thống Azure (thang 100)
     * @return CompletableFuture chứa kết quả FeedbackSpeaking
     */
    public CompletableFuture<FeedbackSpeaking> evaluateSpeakingAsync(int detailId, String topic, String transcript, double azurePronunciationScore) {
        return CompletableFuture.supplyAsync(() -> {
            LOGGER.info("Bắt đầu chấm điểm Speaking cho DetailID: " + detailId);
            String systemInstruction = "Role: Bạn là giám khảo chấm thi IELTS Speaking chuyên nghiệp.\n" +
                                       "Objective: Đánh giá transcript phần thi IELTS Speaking dựa trên 4 tiêu chí chuẩn (Fluency, Lexical, Grammar, Pronunciation).\n" +
                                       "Lưu ý quan trọng: Điểm phát âm hệ thống đã chấm bằng công nghệ AI riêng biệt là " + azurePronunciationScore + "/100. " +
                                       "Hãy dùng điểm số này để ước lượng điểm Pronunciation theo thang điểm IELTS (0-9). Sau đó tập trung đọc Transcript để chấm 3 tiêu chí còn lại.\n" +
                                       "Format: Trả về dữ liệu chính xác theo cấu trúc JSON được yêu cầu, KHÔNG giải thích thêm.";
            String userPrompt = "Chủ đề: " + topic + "\nTranscript: " + transcript;
            
            String jsonResult = geminiApiService.generateStructuredContent(systemInstruction, userPrompt, SPEAKING_SCHEMA);
            
            if (jsonResult != null) {
                try {
                    // Lưu DB
                    aiEvaluationDAO.insertAIEvaluation(detailId, jsonResult);
                    
                    // Parse thành object
                    FeedbackSpeaking feedback = objectMapper.readValue(jsonResult, FeedbackSpeaking.class);
                    
                    // Cập nhật điểm Band và Feedback lên bảng TestSubmissions
                    aiEvaluationDAO.updateTestSubmissionBand(detailId, feedback.getOverallBand(), "Speaking", feedback.getOverallFeedback());
                    
                    LOGGER.info("Hoàn tất chấm điểm Speaking cho DetailID: " + detailId);
                    return feedback;
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi parse JSON FeedbackSpeaking", e);
                }
            }
            return null;
        });
    }

    // Hàm main để test thử luồng AI (Verification)
    public static void main(String[] args) throws Exception {
        // MOCK KEY CHO TEST
        System.setProperty("GEMINI_API_KEYS", "MOCK_KEY_1,MOCK_KEY_2");
        
        AIEvaluationService service = new AIEvaluationService();
        System.out.println("=== TEST WRITING EVALUATION ===");
        CompletableFuture<FeedbackWriting> future = service.evaluateWritingAsync(
                999, 
                "Some people believe that unpaid community service should be a compulsory part of high school programmes. To what extent do you agree or disagree?", 
                "I completely agree that high school students should do unpaid community service. It helps them build character and learn real-world skills."
        );
        
        // Block main thread to wait for result during testing
        try {
            FeedbackWriting result = future.join();
            if (result != null) {
                System.out.println("Overall Band: " + result.getOverallBand());
                System.out.println("Feedback: " + result.getOverallFeedback());
                System.out.println("Mistakes count: " + (result.getMistakes() != null ? result.getMistakes().size() : 0));
            } else {
                System.out.println("Evaluation returned null. Check API Key or logs.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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

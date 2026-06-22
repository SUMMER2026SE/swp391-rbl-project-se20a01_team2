package services;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.TestSubmission;
import model.WeeklyPlan;
import model.WeeklyPlanDTO;

public class AIPathwayService {
    private static final Logger LOGGER = Logger.getLogger(AIPathwayService.class.getName());
    
    private final GeminiApiService geminiApiService;
    private final ObjectMapper objectMapper;
    
    private static final String PATHWAY_SCHEMA = "{" +
            "  \"type\": \"ARRAY\"," +
            "  \"description\": \"Lộ trình học theo từng tuần, tối đa 12 tuần\"," +
            "  \"items\": {" +
            "    \"type\": \"OBJECT\"," +
            "    \"properties\": {" +
            "      \"weekNumber\": { \"type\": \"INTEGER\" }," +
            "      \"skillsFocus\": { \"type\": \"STRING\", \"description\": \"Tên 2 kỹ năng ưu tiên trong tuần\" }," +
            "      \"objectives\": { \"type\": \"STRING\", \"description\": \"Mục tiêu ngắn gọn\" }," +
            "      \"activities\": {" +
            "        \"type\": \"ARRAY\"," +
            "        \"items\": { \"type\": \"STRING\" }" +
            "      }" +
            "    }," +
            "    \"required\": [\"weekNumber\", \"skillsFocus\", \"objectives\", \"activities\"]" +
            "  }" +
            "}";

    public AIPathwayService() {
        this.geminiApiService = new GeminiApiService();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Chạy ngầm (Asynchronous) việc sinh lộ trình học bằng AI
     *
     * @param submission Lịch sử làm bài Placement Test chứa điểm 4 kỹ năng
     * @param targetBand Điểm mục tiêu của học viên
     * @param wrongTagsCount Bản đồ đếm số lỗi sai theo Tag (ví dụ: "Past Tense" -> 5)
     * @return CompletableFuture chứa danh sách các WeeklyPlan (chưa lưu DB)
     */
    public CompletableFuture<List<WeeklyPlan>> generatePathwayAsync(
            TestSubmission submission, 
            BigDecimal targetBand, 
            Map<String, Integer> wrongTagsCount) {
            
        return CompletableFuture.supplyAsync(() -> {
            LOGGER.info("Bắt đầu sinh lộ trình AI cho SubmissionID: " + submission.getSubmissionId());
            
            String systemInstruction = "Role: Bạn là một chuyên gia cố vấn học tập IELTS cực kỳ xuất sắc và am hiểu sư phạm.\n" +
                                       "Objective: Dựa trên điểm số đầu vào 4 kỹ năng, mục tiêu điểm số và ĐẶC BIỆT là các điểm yếu (được phân tích từ loại câu hỏi học viên trả lời sai nhiều nhất), hãy lập lộ trình học 12 tuần (3 tháng) siêu cá nhân hóa.\n" +
                                       "Rules:\n" +
                                       "- Lộ trình tối đa 12 tuần.\n" +
                                       "- Mỗi tuần CHỈ tập trung vào 2 kỹ năng ưu tiên nhất.\n" +
                                       "- Phải thiết kế bài học dựa trên các lỗ hổng kiến thức được cung cấp (ví dụ: nếu sai nhiều Grammar thì tuần đầu phải ôn Grammar).\n" +
                                       "- Trả về MẢNG JSON theo đúng schema, KHÔNG GIẢI THÍCH THÊM.";
            
            StringBuilder promptBuilder = new StringBuilder();
            promptBuilder.append("Thông tin học viên:\n");
            promptBuilder.append("- Điểm đầu vào (Current Band): Overall ").append(submission.getOverallBand()).append("\n");
            promptBuilder.append("  + Listening: ").append(submission.getListeningBand()).append("\n");
            promptBuilder.append("  + Reading: ").append(submission.getReadingBand()).append("\n");
            promptBuilder.append("  + Writing: ").append(submission.getWritingBand()).append("\n");
            promptBuilder.append("  + Speaking: ").append(submission.getSpeakingBand()).append("\n");
            promptBuilder.append("- Điểm mục tiêu (Target Band): ").append(targetBand).append("\n");
            
            if (wrongTagsCount != null && !wrongTagsCount.isEmpty()) {
                promptBuilder.append("- Lỗ hổng kiến thức (số lượng câu làm sai theo từng loại):\n");
                for (Map.Entry<String, Integer> entry : wrongTagsCount.entrySet()) {
                    promptBuilder.append("  + Sai ").append(entry.getValue()).append(" câu ở loại bài: ").append(entry.getKey()).append("\n");
                }
            } else {
                promptBuilder.append("- Lỗ hổng kiến thức: (Không có dữ liệu chi tiết, hãy dựa vào điểm số 4 kỹ năng thấp nhất để phán đoán).\n");
            }
            
            promptBuilder.append("Hãy tạo lộ trình chi tiết cho 12 tuần.");
            
            String userPrompt = promptBuilder.toString();
            
            String jsonResult = geminiApiService.generateStructuredContent(systemInstruction, userPrompt, PATHWAY_SCHEMA);
            
            if (jsonResult != null) {
                try {
                    List<WeeklyPlanDTO> dtoList = objectMapper.readValue(jsonResult, new TypeReference<List<WeeklyPlanDTO>>() {});
                    List<WeeklyPlan> weeklyPlans = new ArrayList<>();
                    
                    for (WeeklyPlanDTO dto : dtoList) {
                        WeeklyPlan plan = new WeeklyPlan();
                        plan.setWeekNumber(dto.getWeekNumber());
                        // Chuyển DTO thành chuỗi JSON string để lưu vào cột PlanContent
                        plan.setPlanContent(objectMapper.writeValueAsString(dto));
                        plan.setCompleted(false);
                        weeklyPlans.add(plan);
                    }
                    
                    LOGGER.info("Hoàn tất sinh lộ trình AI cho SubmissionID: " + submission.getSubmissionId());
                    return weeklyPlans;
                    
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi parse JSON Pathway từ AI", e);
                }
            }
            return null;
        });
    }

    // Hàm main để test thử luồng AI (Verification)
    public static void main(String[] args) {
        // MOCK KEY CHO TEST (Bạn cần gán key thật nếu muốn chạy thử bằng Java IDE)
        // System.setProperty("GEMINI_API_KEYS", "YOUR_API_KEY_HERE");
        
        // Nếu không có KEY thật, quá trình sẽ báo Exception hoặc trả về null.
        if (System.getProperty("GEMINI_API_KEYS") == null) {
            System.out.println("Warning: GEMINI_API_KEYS is not set. Testing will fail.");
            // Set dummy key just to avoid null exception before api call
            System.setProperty("GEMINI_API_KEYS", "DUMMY_KEY"); 
        }

        AIPathwayService service = new AIPathwayService();
        
        TestSubmission mockSubmission = new TestSubmission();
        mockSubmission.setSubmissionId(1);
        mockSubmission.setListeningBand(4.5);
        mockSubmission.setReadingBand(5.0);
        mockSubmission.setWritingBand(4.0);
        mockSubmission.setSpeakingBand(3.5);
        mockSubmission.setOverallBand(4.5);
        
        BigDecimal target = new BigDecimal("6.5");
        
        Map<String, Integer> mockWrongTags = Map.of(
            "Grammar: Past Tense", 5,
            "Vocabulary: Work", 3,
            "Matching Headings", 4
        );
        
        System.out.println("=== BẮT ĐẦU TEST AI PATHWAY GENERATION ===");
        CompletableFuture<List<WeeklyPlan>> future = service.generatePathwayAsync(mockSubmission, target, mockWrongTags);
        
        try {
            List<WeeklyPlan> plans = future.join();
            if (plans != null && !plans.isEmpty()) {
                System.out.println("Đã sinh thành công " + plans.size() + " tuần.");
                for (WeeklyPlan p : plans) {
                    System.out.println("Tuần " + p.getWeekNumber() + ": " + p.getPlanContent());
                }
            } else {
                System.out.println("Sinh lộ trình thất bại (Kết quả null hoặc rỗng). Hãy kiểm tra API Key.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

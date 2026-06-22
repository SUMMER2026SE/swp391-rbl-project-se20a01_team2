# HƯỚNG DẪN TÍCH HỢP TÍNH NĂNG "XÂY DỰNG LỘ TRÌNH HỌC AI"

Tài liệu này dành cho các lập trình viên (đặc biệt là người phụ trách tính năng Nhận lộ trình AI - ví dụ: Tân) để dễ dàng ghép nối (integrate) phần code sinh lộ trình học của AI (do Thanh Phong phát triển) vào giao diện và luồng xử lý của người dùng.

## 1. Tổng quan kiến trúc

Tính năng sinh lộ trình sử dụng `AIPathwayService` (nằm trong thư mục `services`). Service này chịu trách nhiệm:
1. Nhận điểm thi Placement Test, Target Band và **Danh sách các loại câu hỏi làm sai nhiều nhất (Wrong Tags)**.
2. Gửi request lên API của Google Gemini để lấy về lộ trình 12 tuần được cá nhân hóa.
3. Parse kết quả trả về thành chuỗi `List<WeeklyPlan>` chuẩn xác.

> **LƯU Ý:** `AIPathwayService` **KHÔNG** tự động lưu vào Database. Nhiệm vụ của người ghép code là gọi hàm này, nhận kết quả và dùng `PathwayService` để lưu vào bảng `Pathways` và `WeeklyPlans`.

---

## 2. Cách chạy thử độc lập (Test)

Trước khi ghép code vào Controller/Servlet, bạn có thể chạy thử tính năng này trên Console để hiểu rõ dữ liệu trả về trông như thế nào.

1. Mở file `src/main/java/services/TestAIPathway.java`.
2. Uncomment dòng 17 và truyền API KEY thật của bạn vào:
   ```java
   System.setProperty("GEMINI_API_KEYS", "API_KEY_CUA_BAN");
   ```
3. Run file `TestAIPathway` (Shift + F6 trên NetBeans).
4. Quan sát Console, hệ thống sẽ in ra lộ trình mẫu bằng Tiếng Anh để tránh lỗi font chữ trên terminal.

---

## 3. Hướng dẫn ghép nối vào Servlet (Code tham khảo)

Dưới đây là đoạn code chuẩn mực cần đặt vào Servlet (ví dụ: `PlacementTestServlet` hoặc `PathwayGenerationServlet`) ngay sau khi học viên xem xong kết quả Placement Test và bấm nút **"Nhận Lộ Trình Của Tôi"**.

### Bước 1: Chuẩn bị dữ liệu đầu vào

Bạn cần query 3 dữ liệu:
1. Object `TestSubmission` (Kết quả bài test).
2. `TargetBand` (Mục tiêu của user, lấy từ `CandidateTargets`).
3. `Map<String, Integer> wrongTags` (Map đếm số lỗi sai theo từng Tag).

```java
// Giả sử bạn đã có userId và placementTestId (submissionId) từ Session/Request
int userId = 1;
int submissionId = 999;

// 1. Lấy bài TestSubmission (MockTestService hoặc SubmissionService)
TestSubmission submission = mockTestService.getSubmissionById(submissionId);

// 2. Lấy TargetBand của user (CandidateTargetDAO)
BigDecimal targetBand = candidateTargetDAO.findActiveByUserId(userId).get().getTargetBand();

// 3. Tính toán những Tag user làm sai nhiều nhất (Tự viết logic query trong DAO)
// Logic gợi ý: JOIN bảng SubmissionDetails (IsCorrect=0) với ExamQuestions, Questions, QuestionTags và Tags để đếm số lượng lỗi.
Map<String, Integer> wrongTagsCount = new HashMap<>();
wrongTagsCount.put("Grammar: Past Tense", 5); 
wrongTagsCount.put("Reading: Matching Headings", 3);
// ...
```

### Bước 2: Gọi AIPathwayService (Chạy Bất đồng bộ)

Vì gọi API Gemini mất khoảng 5-15 giây, hàm này trả về một `CompletableFuture`. Việc này giúp Main Thread không bị block.

```java
import services.AIPathwayService;
import services.PathwayService;
import model.Pathway;
import model.WeeklyPlan;
import java.util.List;

// Khởi tạo Service
AIPathwayService aiService = new AIPathwayService();
PathwayService pathwayDbService = new PathwayService();

// Bắt đầu gọi AI
aiService.generatePathwayAsync(submission, targetBand, wrongTagsCount)
    .thenAccept(weeklyPlans -> {
        
        if (weeklyPlans != null && !weeklyPlans.isEmpty()) {
            // Bước 3: Lưu thành công vào Database
            System.out.println("AI trả về thành công " + weeklyPlans.size() + " tuần!");
            
            // 3.1: Tạo đối tượng Pathway cha
            Pathway newPathway = new Pathway();
            newPathway.setUserId(userId);
            newPathway.setPlacementTestId(submission.getSubmissionId());
            newPathway.setTargetBand(targetBand);
            newPathway.setCreatedAt(java.time.LocalDateTime.now());
            
            // 3.2: Lưu toàn bộ (PathwayService đã có sẵn hàm này)
            try {
                pathwayDbService.createPathway(newPathway, weeklyPlans);
                System.out.println("Đã lưu Lộ trình vào Database thành công!");
                
                // (Tùy chọn) Có thể bắn Notification báo cho User biết lộ trình đã sẵn sàng
            } catch (Exception e) {
                System.err.println("Lỗi khi lưu DB: " + e.getMessage());
            }
        } else {
            // Xử lý lỗi nếu AI thất bại (do hết quota, timeout, cấu trúc JSON rác...)
            System.err.println("Sinh lộ trình AI thất bại!");
        }
    });

// Lưu ý cho Controller: 
// Vì code chạy Async, bạn KHÔNG NÊN chờ kết quả để redirect. 
// Hãy redirect user về trang Dashboard kèm thông báo: "Hệ thống đang sử dụng AI để phân tích và lập lộ trình, vui lòng kiểm tra lại sau ít phút."
```

## 4. Xử lý PlanContent (Dành cho Frontend)

Khi hiển thị lộ trình lên màn hình cho học viên, bạn dùng hàm `pathwayService.getWeeklyPlans(pathwayId)`.

Mỗi `WeeklyPlan` có cột `PlanContent` chứa chuỗi JSON gốc do AI tạo ra. 
Cấu trúc JSON lưu trong `PlanContent` sẽ như sau:
```json
{
  "weekNumber": 1,
  "skillsFocus": "Reading, Writing",
  "objectives": "Củng cố Grammar (Past Tense) và chiến lược Matching Headings",
  "activities": [
    "Học lý thuyết và làm bài tập thì Quá khứ đơn",
    "Luyện tập dạng bài Matching Headings với 2 bài đọc ngắn"
  ]
}
```

Ở Frontend (JSP/JS), bạn chỉ việc parse chuỗi JSON này ra và vẽ UI:
```javascript
let planStr = '${plan.planContent}';
let planData = JSON.parse(planStr);

console.log(planData.skillsFocus); // "Reading, Writing"
console.log(planData.objectives); // "Củng cố Grammar..."
// Dùng vòng lặp forEach duyệt planData.activities để render thẻ <li>
```

Chúc team tích hợp suôn sẻ và đạt điểm cao!

# Hướng dẫn Tích hợp và Sử dụng AI Evaluation (Chấm điểm bằng Gemini API)

Tài liệu này hướng dẫn các thành viên trong team cách gọi và sử dụng module AI để tự động chấm điểm cho phần thi **Writing** và **Speaking** trong hệ thống IELTSFlow.

---

## 1. Phạm vi hệ thống
Dựa theo thiết kế hệ thống (`swp_motabandau`):
- **Writing & Speaking**: Sử dụng AI (Gemini) để đánh giá tiêu chí, tính điểm Band và sinh Feedback sửa lỗi.
- **Listening & Reading**: KHÔNG dùng AI. Do đây là trắc nghiệm/điền từ, hệ thống tự động chấm Right/Wrong qua đối chiếu Database.

---

## 2. Cấu hình bắt buộc trước khi chạy
Trong môi trường dev (local), mọi người cần tự thêm biến môi trường vào file `.env` nằm trong thư mục `src/main/webapp/WEB-INF/`.

Nếu file chưa có, hãy tạo và cấu hình như sau (Hỗ trợ nhiều key cách nhau bằng dấu phẩy để vượt qua rate limit của Google):
```env
GEMINI_API_KEYS=key_1,key_2,key_3
```
*Lưu ý: Không push file `.env` này lên GitHub để bảo mật.*

---

## 3. Cách gọi API chấm điểm trong Controller (Servlet)
Module AI được thiết kế chạy ngầm (Asynchronous). Việc này giúp giao diện Frontend không bị treo khi chờ API xử lý (có thể tốn từ 10-20 giây).

### A. Chấm điểm bài Writing
Khi Candidate nộp bài Writing, bên cạnh việc lưu câu trả lời vào `SubmissionDetails`, bạn gọi `AIEvaluationService` như sau:

```java
import services.AIEvaluationService;

// Tạo mới instance (Nên khởi tạo ở đầu hoặc dùng Dependency Injection nếu có)
AIEvaluationService aiService = new AIEvaluationService();

int detailId = 123; // ID bài làm lấy từ bảng SubmissionDetails
String topic = "Some people believe that unpaid community service should be compulsory...";
String essay = "I completely agree that high school students...";

// Gọi hàm xử lý Async
aiService.evaluateWritingAsync(detailId, topic, essay).thenAccept(feedback -> {
    // Đoạn code trong này sẽ được gọi KHI AI CHẤM XONG (ngầm).
    // 1. Hệ thống TỰ ĐỘNG lưu toàn bộ JSON kết quả vào CSDL bảng `AIEvaluations` cho detailId này.
    // 2. Hệ thống TỰ ĐỘNG cập nhật `WritingBand` và `OverallAIFeedback` vào bảng `TestSubmissions`.
    
    // Bạn có thể log ra để kiểm tra
    if (feedback != null) {
        System.out.println("AI chấm xong Writing! Overall: " + feedback.getOverallBand());
    }
});

// Code ở dưới chạy bình thường không bị block. Bạn có thể redirect user sang trang "Đang chờ chấm điểm".
```

### B. Chấm điểm bài Speaking
Phần Speaking tương tự, sau khi Frontend đã thu âm, gọi API Speech-to-Text chuyển thành văn bản (`transcript`), bạn truyền nó vào module AI:

```java
import services.AIEvaluationService;

AIEvaluationService aiService = new AIEvaluationService();

int detailId = 456; 
String topic = "Describe a beautiful place you have visited.";
String transcript = "I would like to talk about Da Lat city..."; // Bản dịch từ Speech-to-Text

aiService.evaluateSpeakingAsync(detailId, topic, transcript).thenAccept(feedback -> {
    if (feedback != null) {
        System.out.println("AI chấm xong Speaking! Overall: " + feedback.getOverallBand());
    }
});
```

---

## 4. Cách lấy kết quả hiển thị lên giao diện (JSP/Frontend)

Sau khi AI chấm xong, thông tin sẽ được lưu ở 2 nơi:
1. Cột `WritingBand` / `SpeakingBand` và `OverallAIFeedback` trong bảng `TestSubmissions`: Dùng để hiển thị biểu đồ và lịch sử chung.
2. Cột `FeedbackJSON` trong bảng `AIEvaluations`: Dùng để hiển thị phân tích chi tiết (Feedback, Gợi ý cải thiện, Lỗi sai).

Khi làm giao diện "Xem chi tiết bài giải" (View Result Dashboard), bạn sẽ lấy chuỗi JSON này từ CSDL lên và parse (ép kiểu) lại thành Object để dễ dàng truy xuất:

```java
import com.fasterxml.jackson.databind.ObjectMapper;
import model.FeedbackWriting;

// 1. Fetch `feedbackJsonStr` từ DB bằng DAO của bạn...
String feedbackJsonStr = "..."; // (Lấy từ bảng AIEvaluations)

// 2. Parse JSON string thành Java Object (POJO)
ObjectMapper mapper = new ObjectMapper();
try {
    FeedbackWriting fw = mapper.readValue(feedbackJsonStr, FeedbackWriting.class);
    
    // 3. Bây giờ bạn có thể ném vào request attribute để JSP hiển thị
    request.setAttribute("writingScore", fw);
    /* 
       Trong file JSP bạn có thể gọi:
       Điểm Grammar: ${writingScore.grammaticalRangeAndAccuracy}
       Nhận xét: ${writingScore.overallFeedback}
       Lỗi sai: 
       <c:forEach var="mistake" items="${writingScore.mistakes}">
           Sai: ${mistake.mistake} - Sửa: ${mistake.correction} - Lý do: ${mistake.reason}
       </c:forEach>
    */
} catch (Exception e) {
    e.printStackTrace();
}
```

## 5. Lỗi thường gặp & Xử lý
- **Lỗi `GEMINI_API_KEYS is not set`:** Do quên chưa config file `.env` hoặc Servlet chưa trigger `AppContextListener` lúc start Tomcat.
- **AI trả về null:** Thường do lỗi Timeout (Google phản hồi quá chậm) hoặc Key bị block/quá giới hạn. Hãy check Server Log, hệ thống sẽ tự động in ra lỗi chi tiết (`LOGGER.severe`). Mọi người không cần tự catch exception vì `AIEvaluationService` đã handle toàn bộ exception ngầm.

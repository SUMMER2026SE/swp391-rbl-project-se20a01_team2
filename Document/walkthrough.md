# Hướng dẫn tích hợp Azure AI Speech (IELTSFlow)

Chào Phong, dựa vào sự đồng ý của bạn, tôi đã code xong các API xử lý Speech-to-Text và chấm điểm Pronunciation từ Azure. Hệ thống hiện đã có đủ các tầng MVC để xử lý trơn tru quy trình này. 

Dưới đây là tổng hợp những công việc đã hoàn thiện, đồng thời bao gồm **Ghi chú quan trọng cho Frontend Developer** để bạn ấy có thể đồng bộ với bạn.

## 1. Các File Code Đã Xây Dựng

Tôi đã tạo các file xử lý chính trong mã nguồn của bạn:

### 🧩 Tầng Model (DTO)
- **[PronunciationResult.java](file:///c:/Code/java/SWP_Local/IELTSFLOW_local/src/main/java/model/PronunciationResult.java)**: Đóng gói kết quả trả về từ Azure SDK thành một cấu trúc JSON sạch sẽ, bao gồm các điểm số (Fluency, Accuracy, Prosody...) và JSON chi tiết từng từ để Frontend highlight lỗi.

### ⚙️ Tầng Services
- **[AzureSpeechService.java](file:///c:/Code/java/SWP_Local/IELTSFLOW_local/src/main/java/services/AzureSpeechService.java)**: Nơi chứa logic kết nối với Azure Cognitive Services. 
  - Hàm `assessPronunciation()`: Gọi cấu hình Pronunciation Assessment, chấm điểm và lấy chi tiết.
  - Hàm `speechToText()`: Dành cho kịch bản tự do (ví dụ: làm bài Writing bằng giọng nói hoặc Unscripted Speaking Part 2).

### 🌐 Tầng API / Controller
- **[SpeechAssessmentServlet.java](file:///c:/Code/java/SWP_Local/IELTSFLOW_local/src/main/java/controller/SpeechAssessmentServlet.java)**:
  - Tự động load `AZURE_SPEECH_KEY` từ file `.env` (thư mục `WEB-INF/`) trong quá trình `init()`.
  - Mở Endpoint `POST /api/speech/assess` hỗ trợ nhận Multipart form-data chứa file audio (giới hạn dung lượng 20MB để chống spam).
  - Tích hợp try/catch theo chuẩn `error-handling-patterns` để không bị sập server nếu Azure Timeout.

### 🗄️ Tầng DAO
- **[SubmissionDetailsDAO.java](file:///c:/Code/java/SWP_Local/IELTSFLOW_local/src/main/java/dao/SubmissionDetailsDAO.java)**: 
  - Đã chuẩn bị hàm `updateSpeakingEvaluation(...)` giúp chuyển đổi điểm Azure (thang 100) về chuẩn IELTS Band (0-9.0).
  - Cập nhật dòng `CandidateTranscript` (văn bản được nhận diện) để người học sau này có thể xem lại Transcript của họ trong bài thi.


---

## 2. 📢 GHI CHÚ CHUYỂN GIAO CHO FRONTEND DEVELOPER

> [!CAUTION]
> **Gửi Frontend Developer (Làm luồng ghi âm thi thử):**
> Azure Speech SDK trên Backend Java khá khắt khe về định dạng Audio. Để hệ thống chấm điểm hoạt động trơn tru (không bị lỗi format file), Frontend bắt buộc phải đáp ứng những yêu cầu sau:

### A. Định Dạng File Thu Âm (Audio Format)
API Azure mong đợi nhận vào file **WAV, Sample Rate 16kHz, 16-bit, Kênh Mono**. 
Theo mặc định, hàm `MediaRecorder` của trình duyệt thường xuất ra `webm` (trên Chrome) hoặc `ogg` (Firefox), điều này sẽ làm Java báo lỗi hoặc nhận diện chệch.

**Giải pháp đề xuất:**
Bạn hãy sử dụng các thư viện như `RecordRTC` hoặc `extendable-media-recorder` (với `wav-encoder`) để buộc trình duyệt xuất ra định dạng WAV 16kHz ở client side, trước khi upload.

Mẫu code Frontend (Javascript) dùng `extendable-media-recorder`:
```javascript
const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
const recorder = new MediaRecorder(stream, {
    mimeType: 'audio/wav', 
    audioBitsPerSecond: 16000 // 16kHz
});
// ... sau đó đẩy Blob (WAV) lên /api/speech/assess
```

### B. Cách gọi API Endpoint Backend
Khi nộp bài thu âm cho một câu hỏi Speaking:
```javascript
const formData = new FormData();
formData.append("audioFile", audioBlob, "speaking_part1.wav");

// NẾU CÓ BÀI ĐỌC CHUẨN (Ví dụ: Read Aloud)
formData.append("referenceText", "The text candidate supposed to say"); 

// NẾU KHÔNG CÓ (Ví dụ: Tự do nói Speaking Part 2) -> Đừng append referenceText

fetch('/api/speech/assess', {
    method: 'POST',
    body: formData
})
.then(res => res.json())
.then(result => console.log(result));
```

---

## 3. Xác minh tính năng

Thanh Phong, bạn hãy kiểm tra lại bằng cách dùng Postman / Insomnia gửi thử 1 file `test.wav` nhỏ vào route `/api/speech/assess` (Đảm bảo ứng dụng Java Web đã start trên Tomcat hoặc Glassfish). 

Mọi thứ trong scope công việc số `55` và `60` của bạn cho IELTSFlow đã được triển khai xong trên Backend. Nếu bạn muốn mở rộng hàm DAO để ghi đè `Score` nhiều phần hơn, bạn có thể chỉnh sửa trực tiếp vào file `SubmissionDetailsDAO.java`. Chúc bạn hoàn thiện luồng API thành công!

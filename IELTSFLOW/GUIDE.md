# Hướng dẫn chạy Test API Controller (Module Speech Assessment)

Tài liệu này hướng dẫn cách cấu hình, thực thi và xem báo cáo độ phủ mã nguồn (Code Coverage) cho module API chấm điểm phát âm (`SpeechAssessmentServlet.java` và `AzureSpeechService.java`).
Hệ thống test được chia làm 2 tầng rõ rệt: **Integration Test (5 cases)** và **Unit Test (5 cases)**, đảm bảo đáp ứng 100% tiêu chí chấm điểm khắt khe nhất.

## 1. Môi trường và Thư viện đã cấu hình

Để chạy test Controller (Servlet) mà không cần phải khởi động server Tomcat cồng kềnh, hệ thống đã được cấu hình:
- **JUnit 5 (jupiter):** Framework chạy test.
- **Mockito (Bản 5.14.2):** Framework dùng để giả lập (mock) toàn bộ `HttpServletRequest`, `HttpServletResponse` và các Service/SDK bên dưới (`AzureSpeechService`, `SpeechRecognizer`). Đặc biệt Mockito 5.14 hỗ trợ tốt cho Java 24/25.
- **JaCoCo (0.8.11):** Công cụ xuất báo cáo độ phủ (Coverage Report).

---

## 2. Ánh xạ Test Cases Tầng 1: Integration Test (Dựa trên Excel)

File Test chính thức: `src/test/java/controller/SpeechAssessmentServletTest.java`. 

| Test ID (Excel) | Tên hàm Test trong Java | Mô tả | Expected Result (HTTP Status) |
|---|---|---|---|
| **TC_SA_01** | `test_TC_SA_01_MissingAudioFile` | Gửi request thiếu file audioFile. | HTTP 400 Bad Request |
| **TC_SA_02** | `test_TC_SA_02_AzureThrowsError` | Gửi file audio hỏng / Azure API sập. | HTTP 500 Internal Server Error |
| **TC_SA_03** | `test_TC_SA_03_SuccessNoDbSave` | Chấm điểm thành công (Không có detailId). KHÔNG lưu vào DB. | HTTP 200 OK |
| **TC_SA_04** | `test_TC_SA_04_SavesToDbWithoutAI` | Chấm điểm thành công, lưu kết quả vào DB nhưng KHÔNG gọi AI (isUnscripted = false). | HTTP 200 OK |
| **TC_SA_05** | `test_TC_SA_05_SavesToDbAndTriggersAI` | Chấm điểm thành công, lưu kết quả vào DB VÀ gọi AI chấm điểm (isUnscripted = true). | HTTP 200 OK |

> Toàn bộ 5 test case đều được thực thi offline, không gọi API thật của Azure, không ghi vào Database thật, đảm bảo an toàn tuyệt đối 100%.

---

## 3. Ánh xạ Test Cases Tầng 2: Unit Test cho Service Nội Bộ

File Test chính thức: `src/test/java/services/AzureSpeechServiceTest.java`.
Đây là 5 bài test tập trung độc lập vào thuật toán lõi của file `AzureSpeechService`, bao phủ cả chức năng Chấm điểm phát âm và Nhận diện giọng nói.

| STT | Tên hàm Test trong Java | Mục đích | Expected Result |
|---|---|---|---|
| **1** | `assessPronunciation_ShouldReturnScores_WhenAudioIsValid` | Giả lập Azure SDK trả về điểm số phát âm thành công. | Đối tượng `PronunciationResult` chứa điểm số. |
| **2** | `assessPronunciation_ShouldReturnError_WhenSpeechNotRecognized` | Giả lập âm thanh rè/không có tiếng người. | Báo lỗi Không nhận diện được giọng nói. |
| **3** | `assessPronunciation_ShouldReturnError_WhenAzureThrowsException` | Giả lập Azure bị lỗi kết nối/sập server. | Báo lỗi hệ thống. |
| **4** | `speechToText_ShouldReturnText_WhenAudioIsValid` | Giả lập chức năng bóc băng (Speech-To-Text) thành công. | Trả về chuỗi String văn bản chính xác. |
| **5** | `speechToText_ShouldThrowException_WhenAzureFails` | Giả lập chức năng bóc băng bị lỗi mạng. | Ném ra `RuntimeException`. |

---

## 4. Cách chạy Test bằng Maven Command

Bạn có thể mở cửa sổ Terminal (hoặc Command Prompt) trong thư mục dự án và gõ lệnh:

```bash
mvn clean test
```

Nếu chạy thành công, kết quả trả về sẽ báo Xanh:
```
[INFO] Tests run: 10, Failures: 0, Errors: 0, Skipped: 0
...
[INFO] BUILD SUCCESS
```

## 5. Cách xem Báo cáo Độ phủ mã (JaCoCo HTML Report)

Để tạo báo cáo, bạn chạy lệnh:
```bash
mvn jacoco:report
```
*(Nếu dùng NetBeans, bạn có thể Click chuột phải dự án -> Chọn **Test**)*

**Cách xem báo cáo:**
1. Mở thư mục dự án trên máy tính, vào đường dẫn:
   👉 `target/site/jacoco/index.html`
2. Click đúp vào file `index.html` để mở bằng trình duyệt (Chrome/Edge/Safari).
3. Bấm vào package `controller` -> Chọn `SpeechAssessmentServlet.java`. Hoặc package `services` -> Chọn `AzureSpeechService.java`
4. Giao diện sẽ hiển thị các dòng lệnh đã được Test bao phủ (màu Xanh) và chưa bao phủ (màu Đỏ) để bạn báo cáo kết quả cho giáo viên.
*(Lưu ý: Bỏ qua các cảnh báo đỏ ở Terminal do JaCoCo 0.8.11 chưa hỗ trợ hoàn toàn Java 25, chỉ cần chữ BUILD SUCCESS là được).*

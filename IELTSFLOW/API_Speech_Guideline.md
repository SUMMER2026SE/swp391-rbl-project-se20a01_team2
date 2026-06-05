# TÀI LIỆU HƯỚNG DẪN TÍCH HỢP API SPEECH-TO-TEXT VÀ CHẤM ĐIỂM SPEAKING
**Người lập:** Thanh Phong
**Dự án:** IELTSFlow

Tài liệu này hướng dẫn các thành viên trong dự án (đặc biệt là Frontend Team) cách kết nối và sử dụng API xử lý giọng nói do Backend cung cấp. API này sử dụng dịch vụ Azure AI Speech để giải quyết 2 bài toán cốt lõi:
1. **Speech-to-Text (STT)**: Chuyển đổi giọng nói thành văn bản.
2. **Pronunciation Assessment**: Chấm điểm phát âm dựa trên 4 tiêu chí (Fluency, Accuracy, Completeness, Prosody).

---

## 1. THÔNG TIN ENDPOINT CHÍNH

- **URL:** `POST /api/speech/assess`
- **Content-Type:** `multipart/form-data`

API này xử lý gộp cả 2 trường hợp:
- **Trường hợp A (Có kịch bản - Read Aloud)**: Bạn gửi lên file ghi âm (`audioFile`) + Đoạn text thí sinh cần đọc (`referenceText`). API sẽ trả về Bảng điểm Pronunciation (phát âm).
- **Trường hợp B (Nói tự do - Unscripted - Áp dụng Luồng Tối Ưu Mới)**: Frontend sẽ chịu trách nhiệm tự dịch Speech-to-Text (STT) trước (Ví dụ: sử dụng `Web Speech API` của trình duyệt). Sau đó, bạn gửi lên file ghi âm (`audioFile`) + Đoạn text vừa dịch được (`referenceText`) + cờ `isUnscripted=true`.
  - Kết quả trả về ngay lập tức: JSON Bảng điểm Pronunciation (giúp Frontend hiển thị/bôi đỏ các từ thí sinh phát âm sai).
  - Xử lý ngầm (Backend): Backend sẽ tự động gọi AI (Gemini) để chấm điểm Grammar, Vocabulary, Coherence dựa trên `referenceText` và lưu vào Database.

---

## 2. YÊU CẦU ĐỊNH DẠNG ÂM THANH (QUAN TRỌNG)

> [!WARNING]
> Azure SDK backend yêu cầu định dạng audio nghiêm ngặt. Nếu gửi sai, API sẽ báo lỗi 500 hoặc `NoMatch`.
> **Định dạng bắt buộc:** `WAV`, Sample Rate `16000Hz (16kHz)`, `16-bit`, `Mono (1 kênh)`.

**Gợi ý cho Frontend (JavaScript) - Xử lý Audio & STT:**
1. **Thu âm**: Bởi vì `MediaRecorder` mặc định của trình duyệt web thường tạo ra `.webm` (Chrome) hoặc `.ogg` (Firefox), bạn không thể gửi trực tiếp file này lên Server. Cần dùng thư viện như `recordrtc` hoặc `extendable-media-recorder` kết hợp `wav-encoder` để thu âm và nén đúng chuẩn WAV.
2. **Speech-to-Text (STT) cho bài thi tự do**: Frontend có thể sử dụng `Web Speech API` (cụ thể là `SpeechRecognition` object có sẵn trên hầu hết các trình duyệt hiện đại) để chuyển đổi giọng nói thành văn bản realtime ngay trong lúc thí sinh thu âm. Hoặc sử dụng 1 dịch vụ STT nhẹ ở client-side để lấy text trước khi gửi cho Backend.

---

## 3. CÁCH GỌI API (REQUEST)

Sử dụng `FormData` trong JavaScript để đóng gói dữ liệu:

### Mẫu Code Frontend (Fetch API)

```javascript
// Giả sử audioBlob là file WAV 16kHz lấy từ bộ ghi âm của Frontend
const formData = new FormData();
formData.append("audioFile", audioBlob, "speaking_record.wav");

// NẾU CÓ ĐỀ BÀI ĐỌC CHUẨN (Ví dụ: Thí sinh đang làm dạng bài Read Aloud)
// Bạn cần gửi thêm câu chữ mà thí sinh phải đọc để AI đối chiếu
formData.append("referenceText", "This is the text the candidate is supposed to read."); 

// NẾU THÍ SINH NÓI TỰ DO (Ví dụ: Speaking Part 2)
// Theo luồng tối ưu: Frontend tự chạy STT để lấy văn bản, sau đó truyền văn bản này vào biến referenceText
// Đồng thời, TRUYỀN THÊM CỜ `isUnscripted = true` để Backend biết đây là bài nói tự do và kích hoạt AI chấm Grammar/Vocabulary sau khi chấm phát âm.
// formData.append("referenceText", textTuSTT);
// formData.append("isUnscripted", "true");

fetch('http://localhost:8080/IELTSFLOW/api/speech/assess', {
    method: 'POST',
    body: formData
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error("Lỗi:", error));
```

---

## 4. CẤU TRÚC PHẢN HỒI (RESPONSE JSON)

### Trường hợp 1: Chấm điểm phát âm thành công (Có gửi `referenceText`)
Hệ thống sẽ trả về JSON chứa đầy đủ các điểm (thang 100) và chuỗi `detailedJson` để Frontend có thể hiển thị đổi màu các từ đọc sai.

```json
{
  "success": true,
  "data": {
    "success": true,
    "accuracyScore": 85.0,
    "fluencyScore": 79.0,
    "completenessScore": 100.0,
    "prosodyScore": 81.0,
    "pronunciationScore": 83.0,
    "recognizedText": "This is the text the candidate is supposed to read.",
    "errorMessage": null,
    "detailedJson": {
        // ... (Cấu trúc JSON chi tiết từ Azure, chứa mảng Words và ErrorType: Omission, Insertion, Mispronunciation)
    }
  }
}
```

### Trường hợp 2: STT tự do thành công (Không gửi `referenceText`)

```json
{
  "success": true,
  "data": {
    "transcript": "Well in my opinion learning English is very important because..."
  }
}
```

### Trường hợp 3: Có lỗi xảy ra

```json
{
  "success": false,
  "error": "Vui lòng đính kèm file âm thanh (audioFile)."
}
```

---

## 5. LƯU Ý CHO BACKEND TEAM (Ghi chú nội bộ)

Khi API chạy thành công ở Trường hợp 1 (chấm điểm), Backend (cụ thể là class `SpeechAssessmentServlet.java`) sẽ tự động gọi qua tầng `SubmissionDetailsDAO.java`.
Hàm `updateSpeakingEvaluation(detailId, transcript, azureScore)` sẽ đảm nhận việc:
1. Convert con số điểm `pronunciationScore` (ví dụ 83.0) sang chuẩn IELTS Band (từ 0 đến 9.0).
2. Lưu kết quả Band điểm vào cột `Score` và lưu chữ vào cột `CandidateTranscript` trên Table `SubmissionDetails` của cơ sở dữ liệu.

Nếu mọi người gặp lỗi khi test nghiệm thu tính năng này trên máy Local, hãy đảm bảo các bạn đã kéo file `.env` mới nhất hoặc thêm 2 biến `SPEECH_KEY` và `SPEECH_REGION` (được anh Phong cung cấp nội bộ) vào file `.env` trong máy của các bạn.

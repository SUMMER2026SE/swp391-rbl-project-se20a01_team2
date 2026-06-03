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
- **Trường hợp A (Có kịch bản - Read Aloud)**: Bạn gửi lên file ghi âm + Đoạn text thí sinh cần đọc. API sẽ trả về STT và Bảng điểm Pronunciation.
- **Trường hợp B (Nói tự do - Unscripted)**: Bạn chỉ gửi lên file ghi âm. API chỉ trả về văn bản dịch ra (STT).

---

## 2. YÊU CẦU ĐỊNH DẠNG ÂM THANH (QUAN TRỌNG)

> [!WARNING]
> Azure SDK backend yêu cầu định dạng audio nghiêm ngặt. Nếu gửi sai, API sẽ báo lỗi 500 hoặc `NoMatch`.
> **Định dạng bắt buộc:** `WAV`, Sample Rate `16000Hz (16kHz)`, `16-bit`, `Mono (1 kênh)`.

**Gợi ý cho Frontend (JavaScript):**
Bởi vì `MediaRecorder` mặc định của trình duyệt web thường tạo ra `.webm` (Chrome) hoặc `.ogg` (Firefox), bạn không thể gửi trực tiếp file này lên Server.
Frontend cần dùng các thư viện như `recordrtc` hoặc `extendable-media-recorder` kết hợp `wav-encoder` để thu âm và nén đúng chuẩn WAV trước khi gửi request.

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
// KHÔNG truyền biến referenceText, hệ thống sẽ tự động hiểu là chỉ cần dịch STT.

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

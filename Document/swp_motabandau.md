# **TÀI LIỆU MÔ TẢ HỆ THỐNG: IELTSFlow**

## **1\. Tổng quan dự án (Project Overview)**

**IELTSFlow** là một nền tảng Web-based hỗ trợ học và luyện thi IELTS toàn diện 4 kỹ năng (Listening, Reading, Writing, Speaking). Hệ thống giải quyết bài toán thiếu môi trường thực hành, thiếu lộ trình cá nhân hóa và thời gian chờ chấm chữa bài lâu bằng cách tích hợp Trí tuệ Nhân tạo (AI).

Hệ thống hoạt động dựa trên cơ chế: Mentor tạo kho dữ liệu (Ngân hàng đề) nội bộ. Người học (Candidate) truy cập, làm bài kiểm tra đầu vào (Placement Test) để AI phân tích và tự động tạo lộ trình học cá nhân hóa. Candidate làm bài tập/thi thử sẽ được lấy đề ngẫu nhiên từ ngân hàng đề , sau đó AI sẽ chấm điểm, dự đoán Band điểm và đưa ra phản hồi chi tiết (Feedback).

## **2\. Các Tác nhân (Actors)**

Hệ thống bao gồm 5 nhóm tác nhân chính:

1. **Guest (Khách):** Người dùng chưa có tài khoản hoặc chưa đăng nhập.  
2. **Candidate (Học viên):** Người dùng chính, trả phí hoặc dùng bản dùng thử để học và thi.  
3. **Mentor (Giảng viên/Chuyên môn):** Người chịu trách nhiệm tạo nội dung học, ngân hàng đề thi, tài liệu và giải đáp thắc mắc.  
4. **Admin (Quản trị viên):** Quản lý toàn bộ hệ thống, tài khoản, doanh thu và phân quyền.  
5. **AI Service:** Hệ thống API bên thứ 3 (VD: OpenAI, Google Speech-to-Text) tích hợp ngầm để xử lý đánh giá, chấm điểm.

---

## **3\. Yêu cầu Chức năng chi tiết (Functional Requirements)**

### **3.1. Phân hệ Guest (Khách)**

* **Landing Page:** Xem giới thiệu tính năng, review từ học viên, bảng giá các gói Subscription (Candidate Pro).  
* **Xác thực:** Đăng ký, đăng nhập (Hỗ trợ Email/Password và Google).

### **3.2. Phân hệ Candidate (Học viên)**

**A. Quản lý tài khoản & Mục tiêu**

* Quản lý thông tin cá nhân, đổi mật khẩu.(mật khẩu phải được mã hóa)  
* Đặt mục tiêu IELTS (Target Band, Thời gian dự kiến thi).  
* **Gói thành viên (Subscription):** Nâng cấp tài khoản lên gói Pro (3 tháng, 6 tháng, 1 năm), thanh toán qua Cổng thanh toán, xem lịch sử giao dịch và thời hạn gói.

**B. Onboarding & Lộ trình (Placement Test & AI Pathway)**

* **Placement Test:** Làm bài test đầu vào đủ 4 kỹ năng.  
* **Pathway Generation:** Dựa trên điểm Placement Test và Target Band, AI sinh ra lộ trình học từng tuần (Weekly Plan).Với các logic  sau:  
      \-  AI chỉ xây dựng lộ trình học theo từng tuần (với 2 kỹ năng được AI đề xuất mỗi tuần).Logic: AI tính toán từ điểm bài test và band điểm mong muốn, tính toán lộ trình để đạt được trong thời gian đó nhưng chỉ bắt AI  trả về lộ trình từng tuần trong  3 tháng đầu tiên trong lộ trình AI suy tính  cho hệ thống .  
      \-Mỗi khi kết thúc giai đoạn 3 tháng này, người học bắt buộc phải thực hiện bài kiểm tra đánh giá lại (re-test) nếu muốn xem tiếp lộ trình, để hệ thống có cơ sở cập nhật và hiển thị các giai đoạn tiếp theo của lộ trình.Lộ trình mới sẽ nối tiếp lộ trình trước đó  
                
   Ví dụ:     .

Một cách hợp lý là map:

**Band hiện tại \+ Band mục tiêu \+ Thời gian → lộ trình theo tuần**

Ví dụ:

* Current: 4.5  
* Goal: 6.5  
* Time: 12 tuần  
* Weak: Speaking \+ Writing

AI sẽ ưu tiên Speaking/Writing nhiều hơn.

Có thể thiết kế rule mẫu theo band điểm:

# **Band 3.0–4.5 (Foundation)**

Mục tiêu:

* Xây nền ngữ pháp  
* Từ vựng cơ bản  
* Làm quen format IELTS

### **Tuần 1–2**

* Grammar cơ bản  
* Từ vựng chủ đề Education  
* Listening Part 1  
* Speaking Part 1 đơn giản

### **Tuần 3–4**

* Reading skimming/scanning  
* Vocabulary chủ đề Work  
* Writing Task 1 cơ bản

### **Tuần 5–6**

* Listening Part 2–3  
* Speaking Part 2  
* Mini test

---

# **Band 5.0–6.0 (Intermediate)**

Mục tiêu:

* Tăng tốc làm bài  
* Học kỹ năng xử lý đề

### **Tuần 1–2**

* Reading Matching Heading  
* Writing Task 1 nâng cao  
* Speaking cue card

### **Tuần 3–4**

* Listening section 3–4  
* Paraphrase  
* Từ vựng học thuật

### **Tuần 5–6**

* Full skill practice  
* Mock Test

---

# **Band 6.0–7.0 (Upper Intermediate)**

Mục tiêu:

* Tối ưu điểm yếu  
* Tăng độ tự nhiên

### **Tuần 1–2**

* Speaking fluency  
* Complex grammar  
* Reading True/False/Not Given

### **Tuần 3–4**

* Writing Task 2  
* Tăng tốc độ làm bài

### **Tuần 5–6**

* Full test có timer

---

# **Band 7.0+**

Mục tiêu:

* Chiến lược thi  
* Giảm lỗi nhỏ

### **Tuần 1–2**

* Mock test toàn phần

### **Tuần 3–4**

* Phân tích lỗi

### **Tuần 5–6**

* Thi thử liên tục

    

**C. Phân hệ Luyện tập (Practice & Learning)**

* **Hỏi đáp:** Viết ticket để trao đổi với mentor  
* **Học lý thuyết:** Xem video bài giảng, đọc tài liệu từ Mentor.  
* **Đánh dấu bài tập :** Đánh dấu bài tập đã học và chưa học  
* **Nhận thông báo nhắc học**   
* **Luyện Listening & Reading:**  
  * Làm bài trắc nghiệm, điền từ, matching.  
  * Hệ thống tự động chấm điểm Right/Wrong tức thì và giải thích đáp án (Script/Text).  
* **Luyện Writing:**  
  * Giao diện nhập text có đếm số từ.  
  * **AI Evaluation:** AI chấm theo 4 tiêu chí IELTS (Task Response, Coherence, Lexical Resource, Grammar) và gợi ý cách sửa lỗi (Grammar check).  
* **Luyện Speaking:**  
  * Thu âm trực tiếp trên trình duyệt có đếm thời gian.  
  * **Speech-to-text:** Chuyển giọng nói thành văn bản để AI phân tích.  
  * **AI Evaluation:** Chấm điểm Pronunciation, Fluency, Vocabulary, Grammar và đưa ra Feedback.

**D. Phân hệ Thi thử (Mock Test)**

* Lấy 1 bộ đề ngẫu nhiên từ các bộ đề được mentor đóng gói sẵn. Tuy nhiên, thứ tự câu hỏi sẽ được sắp xếp ngẫu nhiên.  
* Thi mô phỏng đủ 4 kỹ năng có đếm ngược thời gian.  
* **Focus Mode (Chế độ tập trung):** Yêu cầu full-screen, cảnh báo nếu chuyển tab.  
* Trả kết quả: Điểm 4 kỹ năng, Dự đoán Overal Band.

**E. Thống kê & Lịch sử (Dashboard)**

* Hiển thị biểu đồ tiến bộ (Progress chart) dựa trên các bài test đã làm.  
* Xem lại lịch sử làm bài, đáp án chi tiết và AI Feedback của các bài cũ.

### **3.3. Phân hệ Mentor (Giảng viên)**

* **Quản lý Ngân hàng đề (Bank Management):** Tạo/Sửa/Xóa câu hỏi cho Listening, Reading, Writing, Speaking. Phân loại câu hỏi theo Tags (Dạng bài, Độ khó, Chủ đề).  
* **Quản lý Đề thi:** Ghép các câu hỏi thành 1 Mock Test hoàn chỉnh.  
* **Quản lý Tài liệu:** Đăng tải bài giảng (Video/PDF).  
* **Hỗ trợ học viên:** Xem thống kê lỗi sai phổ biến của hệ thống để điều chỉnh bài giảng; Trả lời câu hỏi/ticket của học viên.

### **3.4. Phân hệ Admin (Quản trị)**

* **Xem log hệ thống** :xem lịch sử thao tác của hệ thống(lưu trên database)  
* **User Management:** Khóa, cấp quyền tài khoản (chỉ định ai là Mentor).  
* **Finance:** Quản lý các gói Subscription, cấu hình giá, xem thống kê doanh thu.  
* **System Dashboard:** Xem lượng user active, log hệ thống, tổng số bài test đã thực hiện.

---

## **4\. LUỒNG TƯƠNG TÁC AI (AI SERVICE INTEGRATION)**

Hệ thống backend sẽ gọi API qua các Prompt mẫu được thiết kế sẵn.

* \* \*\*Với Writing:\*\* Backend gửi đề bài \+ Bài làm của Candidate. AI trả về JSON chứa: Điểm 4 tiêu chí, Nhận xét chung, Danh sách các câu sai ngữ pháp và Gợi ý sửa.    
* \* \*\*Với Speaking (Luồng Tối Ưu Mới):\*\*   
    \- Bước 1: Frontend thu âm và tự chạy tính năng Speech-to-Text (STT) để lấy văn bản thô (Raw Transcript).  
    \- Bước 2: Frontend gửi gói tin gồm \`Audio\` \+ \`Raw Transcript\` (vào biến \`referenceText\`) \+ cờ \`isUnscripted=true\` lên API Backend.  
    \- Bước 3: Backend dùng Azure AI để chấm điểm \*\*Phát âm (Pronunciation)\*\* và bắt lỗi từng từ dựa trên file Audio và Transcript.  
    \- Bước 4: Backend chạy ngầm AI Model (Gemini) để phân tích Ngữ pháp, Từ vựng, Mạch lạc dựa trên Transcript và điểm phát âm từ Azure.  
* \* \*\*Với Study Pathway:\*\* Gửi điểm đầu vào \+ mục tiêu \+ quỹ thời gian. AI trả về 1 mảng JSON chứa lộ trình học từng tuần( hệ thông đọc json và trả về một trình theo tuần) ..

---

## **5\. CÁC ĐIỂM ĐÃ TỐI ƯU, THÊM VÀ BỚT (Ghi chú quan trọng cho Dev)**

Tôi đã phân tích và thực hiện một số tinh chỉnh so với mô tả ban đầu để hệ thống dễ triển khai (Implementation) hơn nhưng vẫn hiệu quả:

### **🌟 Những điểm LƯỢC BỚT hoặc LÀM RÕ (Để tránh code quá khó):**

1. "Secure Exam Mode" (Chế độ thi an toàn): Thay vì tích hợp các phần mềm giám sát (Proctoring) dùng Camera/AI nhận diện khuôn mặt (rất khó, đắt đỏ và nặng server), tôi tối ưu thành **"Focus Mode"**. Tức là trình duyệt yêu cầu Full-screen, dùng Javascript bắt sự kiện visibilitychange. Nếu User chuyển Tab hoặc thoát Full-screen quá 3 lần \-\> Tự động nộp bài và đánh dấu gian lận.  
2. AI chấm Speaking: AI thuần túy (như ChatGPT) không nghe được âm điệu (intonation). Do đó, tôi làm rõ luồng: Bắt buộc phải qua 1 lớp API Speech-to-text trước. Phần đánh giá "Phát âm" sẽ dựa vào tỷ lệ nhận diện đúng của Speech-to-text (Nếu AI dịch đúng ý tức là phát âm rõ ràng).

### **🌟 Những điểm THÊM VÀO (Để hệ thống hoàn chỉnh và thương mại hóa được):**

1. **Thêm Cổng thanh toán (Payment Gateway):** Vì có các gói "Candidate Pro", hệ thống bắt buộc phải thiết kế luồng tích hợp với VNPay, MoMo hoặc Stripe. (Đã bổ sung vào phần Candidate/Admin).  
2. **Thêm hệ thống Ticket (Hỗ trợ Q\&A):** Thay vì Mentor và Candidate chat realtime (tốn resource, khó quản lý), tôi thiết kế thành "Hỗ trợ học viên qua Ticket/Comments" để Candidate để lại câu hỏi, Mentor vào trả lời sau.  
3. **Chuẩn hóa Data AI (JSON Output):** Đã note rõ cho Dev Backend rằng kết quả trả về từ AI phải được ép kiểu về chuẩn JSON (thay vì Text tự do) để Frontend dễ dàng vẽ biểu đồ và highlight lỗi sai.

   ## **6\. Luồng lấy, lưu dữ liệu bài thi**

**6.1. Đối với câu hỏi dạng matching:**  
**1\. Luồng Lưu Dữ Liệu (Save / Create) \- Dành cho Admin/Mentor**

Khi Mentor tạo một câu hỏi Matching, frontend của hệ thống quản lý sẽ gửi xuống backend toàn bộ dữ liệu (câu hỏi, các vế trái/phải, và đáp án đúng). Backend của cậu phải xử lý theo luồng sau:

1. **Nhận Dữ liệu từ frontend:**  
2. **Tách Dữ Liệu (Decoupling):** \* Trích xuất các option bên trái (`left_side`) và bên phải (`right_side`) đóng gói thành một object JSON dành riêng cho `contentJSON`.  
   * Trích xuất các cặp map đúng đóng gói thành một object JSON dành riêng cho bảng `Answers` chứa mapping đúng.  
3. **Database Transaction:** Mở một SQL Transaction để lưu

### **2\. Luồng Lấy Đề Thi (Retrieve / Fetch) \- Dành cho Học viên**

Đây là chỗ dễ sai lầm nhất. Nếu không cẩn thận, cậu sẽ leak đáp án.

1. **Query Database:** Backend query lấy danh sách câu hỏi từ bảng `Questions`  
   * **Tuyệt đối không JOIN với bảng `Answers`** trong API lấy đề thi này.  
2. **Format Response:** Parse cái `ContentJSON` từ chuỗi string thành JSON Object.  
3. **Xử Lý hiện thị câu hỏi:** **Shuffle (xáo trộn)** vị trí của mảng `right_side` (và có thể cả `left_side`) trước khi render ra UI.

### **3\. Luồng Nộp Bài & Chấm Điểm (Submit & Evaluate)**

Khi học viên bấm "Nộp bài", frontend sẽ gửi một payload chứa những gì user đã chọn.

1. **Frontend gửi data lên backend.**  
2. **Truy Xuất Đáp Án:** Backend nhận `question_id`, query thẳng vào bảng `Answers`   
3. **So Sánh (Evaluation):** \* Parse `ContentJSON` của bảng `Answers` thành Dictionary/Object.  
   * Duyệt qua từng key của `user_answers` và so sánh value với dictionary đáp án chuẩn.  
   * Tính điểm: Có thể tính điểm tuyệt đối (đúng hết mới có điểm) hoặc điểm thành phần (đúng bao nhiêu cặp được bấy nhiêu điểm) tùy logic requirement của cậu.

### **4\. Cấu trúc JSON:** **câu hỏi:** 

| {   "left\_side": \[     {"id": "1", "text": "option 1"},     {"id": "2", "text": "option 2"}   \],   "right\_side": \[     {"id": "a", "text": "option A"},     {"id": "b", "text": "option B"},     {"id": "c", "text": "distractor option"}    \] }  |
| :---- |

### matching đúng (lưu bảng answer): 

| {   "1": "b",   "2": "a" }  |
| :---- |

**6.2. Đối với câu hỏi dạng fill in blank:**

### **1\. Luồng Lưu Dữ Liệu (Save / Create)**

Luồng này xử lý khi Mentor tạo câu hỏi trên hệ thống quản lý.

1. **Nhận dữ liệu từ frontend:**.  
2. **Đóng Gói JSON:** Backend validate dữ liệu:  
   * Tạo `ContentJSON` để lưu bảng question  
   * Tạo object `AnswerMap` chứa các mảng text đáp án hợp lệ.  
3. **Lưu vào db**

### **3\. Luồng Lấy Đề Thi (Retrieve / Fetch)**

Khi hiển thị đề cho học viên, nguyên tắc tối thượng vẫn là không được lộ dữ liệu chấm điểm.

1. **Query Data:** Backend truy vấn bảng `Questions`, tuyệt đối bỏ qua bảng `Answers`.  
2. **Render:** Frontend hiện 1 danh sách các thẻ `<input type="text">` hoặc `<select>`  dựa vào số chỗ  trống  cần điền từ  thông tin đọc được từ `contentJSON`.

### **4\. Luồng Nộp Bài & Chấm Điểm (Submit & Evaluate)**

Đây là nơi cần xử lý logic tinh tế nhất để học viên không bị trừ điểm oan uổng vì những lỗi lặt vặt.

1. **Frontend gửi data lên backend.**  
2. **Truy Xuất Tương Đáp Án:** Backend lấy chuỗi JSON từ bảng `Answers` và parse thành đối tượng Dictionary chứa Array.  
3. **Logic Chấm Điểm (Evaluation Engine):**  
   * Duyệt qua từng key trong `user_answers`.  
   * **Tiền xử lý (Sanitize):** Nếu là text input, backend bắt buộc phải `Trim()` (cắt khoảng trắng 2 đầu) và `ToLower()` cả chuỗi của user lẫn mảng đáp án chuẩn   
   * **So sánh:** Kiểm tra xem chuỗi user đã nhập (sau khi đã sanitize) có tồn tại trong mảng đáp án chuẩn hay không  
   * Cộng điểm thành phần cho mỗi ô điền đúng.

### **4\. Cấu trúc JSON:** **câu hỏi:** 

| {   "blanks": {     "1": { "type": "text", "placeholder": "Nhập tên ngôn ngữ..." },     "2": { "type": "dropdown", "options": \["C\#", "Java", "PHP", "C++"\] }   } }  |
| :---- |

### matching đúng (lưu bảng answer):

| {   "1": \["Python", "python", "PYTHON"\],   "2": \["C\#", "Java"\]  }  |
| :---- |

**6.3. Đối với câu hỏi dạng Multiple Choise:**

## **7\. Use case:**

**A. Guest**

1. Xem trang chủ  
2. Xem giới thiệu khóa học  
3. Đăng ký  
4. Đăng nhập  
5. Xem thông tin hệ thống  
   **B. Candidate (Người học)**  
1. Quản lý tài khoản  
2. Tìm kiếm bài học  
3. Cập nhật hồ sơ  
4. Đổi mật khẩu  
5. Đặt mục tiêu IELTS  
6. Làm Placement Test  
7. Xem kết quả  
8. Nhận lộ trình AI  
9. Xem bài học  
10. Làm bài luyện tập  
11. Đánh dấu bài tập  
12. Xem lộ trình học  
13. Nhận gợi ý học hôm nay  
14. Làm bài Mock Test  
15. Xem band dự đoán  
16. Bắt đầu chế độ tập trung (Focus Mode)  
17. Nhận cảnh báo vi phạm trong quá trình thi  
18. Xem lịch sử học  
19. Xem thống kê tiến độ học tập  
20. Xem biểu đồ kết quả  
21. Xem chi tiết kết quả bài làm  
22. Làm lại bài luyện tập  
23. Nhận thông báo nhắc học  
24. Tìm kiếm bài học / đề thi  
25. Xem transcript Speaking  
26. Gửi và xem ticket đã gửi cho Mentor  
27. Xem danh sách gói Candidate Pro  
28. Xem chi tiết quyền lợi gói  
29. Mua gói Pro  
30. Xem lịch sử thanh toán  
31. Gia hạn gói thành viên  
32. Xem thời gian còn lại của gói  
      
    **C. Mentor**  
1. Tạo / sửa / xóa bài học  
2. Tạo / sửa / xóa câu hỏi  
3. Gắn tag câu hỏi  
4. Quán lý các Tag  
5. Tạo / sửa / xóa đề luyện tập  
6. Tạo / sửa / xóa đề thi thử  
7. Xem tiến độ học viên  
8. Tạo / sửa / xỏa tài liệu học tập  
9. Xem / trả lời câu hỏi học viên  
10. Xem thống kê hiệu quả bộ đề  
    **D. Admin**  
1. Thêm / sửa / khóa tài khoản người dùng  
2. Phân quyền Mentor  
3. Xem thống kê hệ thống  
4. Xem log hệ thống  
5. Quản lý gói thành viên  
6. Tạo / sửa / xóa gói Pro  
7. Xem thống kê doanh thu  
8. Quản lý giao dịch  
     
   **E. AI Service**  
1. Chấm và đánh giá bài làm  
2. Tạo feedback  
3. Ước lượng band IELTS  
4. Xây dựng lộ trình học  
5. Gợi ý cải thiện kỹ năng

\-- Tạo cơ sở dữ liệu

CREATE DATABASE IELTSFlow;

GO

USE IELTSFlow;

GO

\-- \==========================================

\-- NHÓM QUẢN TRỊ NGƯỜI DÙNG & HỒ SƠ

\-- \==========================================

CREATE TABLE Roles (

    RoleID INT IDENTITY(1,1) PRIMARY KEY,

    RoleName NVARCHAR(50) NOT NULL UNIQUE, \-- Admin, Mentor, Candidate

    Description NVARCHAR(255)

);

CREATE TABLE Users (

    UserID INT IDENTITY(1,1) PRIMARY KEY,

    RoleID INT NOT NULL,

    Email NVARCHAR(255) NOT NULL UNIQUE,

    PasswordHash NVARCHAR(255) NULL, \-- Cho phép NULL để hỗ trợ Social Login

    AuthProvider NVARCHAR(50) DEFAULT 'Local', \-- Local, Google, Facebook

    ProviderID NVARCHAR(100) NULL, \-- ID trả về từ Google/Facebook

    FullName NVARCHAR(100) NOT NULL,

    Status NVARCHAR(20) DEFAULT 'Active', \-- Active, Inactive, Banned

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),

    Deleted BIT DEFAULT 0

);

CREATE TABLE CandidateTargets (

    TargetID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    TargetBand DECIMAL(3,1) NOT NULL, \-- Ví dụ: 6.5, 7.0

    CurrentBand DECIMAL(3,1),

    ExamDate DATE,

    IsActive BIT DEFAULT 1, \-- \[CẬP NHẬT\] Đánh dấu mục tiêu hiện tại đang active để AI lên lộ trình

    FOREIGN KEY (UserID) REFERENCES Users(UserID)

);

\-- \==========================================

\-- NHÓM GÓI CƯỚC & THANH TOÁN

\-- \==========================================

CREATE TABLE SubscriptionPackages (

    PackageID INT IDENTITY(1,1) PRIMARY KEY,

    Name NVARCHAR(100) NOT NULL,

    DurationMonths INT NOT NULL,

    Price DECIMAL(18,2) NOT NULL,

    Description NVARCHAR(500),

    Deleted BIT DEFAULT 0

);

CREATE TABLE Transactions (

    TransactionID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    PackageID INT NOT NULL,

    Amount DECIMAL(18,2) NOT NULL,

    PaymentMethod NVARCHAR(50), \-- VNPay, MoMo, Stripe

    GatewayTransactionID NVARCHAR(100) NULL, \-- Mã đối soát từ Cổng thanh toán (TxnRef)

    GatewayPayload NVARCHAR(MAX) NULL, \-- \[CẬP NHẬT\] Lưu trữ JSON payload gốc từ webhook để đối soát khi có lỗi

    Status NVARCHAR(50) DEFAULT 'Pending', \-- Pending, Success, Failed

    PaymentDate DATETIME NULL, \-- Thời gian thanh toán thực tế ghi nhận từ Webhook

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID),

    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)

);

CREATE TABLE UserSubscriptions (

    UserSubID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    PackageID INT NOT NULL,

    StartDate DATETIME NOT NULL,

    EndDate DATETIME NOT NULL,

    Status NVARCHAR(50) DEFAULT 'Active', \-- Active, Expired, Cancelled

    FOREIGN KEY (UserID) REFERENCES Users(UserID),

    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)

);

\-- \==========================================

\-- NHÓM NGÂN HÀNG ĐỀ THI & HỌC LIỆU

\-- \==========================================

CREATE TABLE QuestionResource (

    ResourceID INT IDENTITY(1,1) PRIMARY KEY,

    ResourceText NVARCHAR(MAX),

    ResourceAudioURL NVARCHAR(500),

    ResourceImageURL NVARCHAR(500),

    Type NVARCHAR(50) NOT NULL, \-- Passage, Audio

    CreatedBy INT NULL, \-- Theo dõi Mentor nào tạo

    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),

    Deleted BIT DEFAULT 0

);

CREATE TABLE Questions (

    QuestionID INT IDENTITY(1,1) PRIMARY KEY,

    ResourceID INT NULL, 

    Content NVARCHAR(MAX) NOT NULL,

    QuestionType NVARCHAR(50) NOT NULL, \-- MultipleChoice, Matching, FillInBlanks. Note: Matching sẽ lấy data từ cột contentJson từ cả 2 bảng Question và Answer. Còn FillInBlanks sẽ lấy câu hỏi từ cột content của Questions; còn answer sẽ lấy từ json của answers

    Skill NVARCHAR(20) NOT NULL, \-- Listening, Reading, Writing, Speaking

    Difficulty NVARCHAR(20), \-- Easy, Medium, Hard

    Explanation NVARCHAR(MAX),

    OrderInResource INT NULL, \-- \[CẬP NHẬT\] Thứ tự câu hỏi đi theo 1 bài đọc (Passage) hoặc audio

    contentJSON NVARCHAR(MAX) NOT NULL, 

    CreatedBy INT NULL, \-- Theo dõi Mentor nào tạo

    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID),

    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),

    Deleted BIT DEFAULT 0

);

CREATE TABLE Answers (

    AnswerID INT IDENTITY(1,1) PRIMARY KEY,

    QuestionID INT NOT NULL,

    Content NVARCHAR(MAX) NOT NULL, \-- text, 

    ContentJson NVARCHAR(MAX) NOT NULL, \-- JSON

    IsCorrect BIT NOT NULL DEFAULT 0,

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE

);

CREATE TABLE Tags (

    TagID INT IDENTITY(1,1) PRIMARY KEY,

    Name NVARCHAR(100) NOT NULL,

    Type NVARCHAR(50) \-- Topic, Grammar, Vocabulary...

);

CREATE TABLE QuestionTags (

    QuestionID INT NOT NULL,

    TagID INT NOT NULL,

    PRIMARY KEY (QuestionID, TagID),

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,

    FOREIGN KEY (TagID) REFERENCES Tags(TagID) ON DELETE CASCADE

);

CREATE TABLE Lessons (

    LessonID INT IDENTITY(1,1) PRIMARY KEY,

    Title NVARCHAR(200) NOT NULL,

    Content NVARCHAR(MAX),

    VideoURL NVARCHAR(500),

    DocumentURL NVARCHAR(500) NULL, \-- Lưu trữ PDF/Tài liệu

    CreatedBy INT NULL, \-- Theo dõi Mentor đăng bài

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),

    Deleted BIT DEFAULT 0,

    Skill NVARCHAR(20)

);

\-- Bảng quản lý Tiến độ & Đánh dấu bài học

CREATE TABLE UserLessonProgress (

    ProgressID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    LessonID INT NOT NULL,

    IsCompleted BIT DEFAULT 0, \-- Đã học xong chưa

    IsBookmarked BIT DEFAULT 0, \-- Đánh dấu bài học

    LastAccessed DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,

    FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE

);

\-- \[CẬP NHẬT BẢNG MỚI\] Bảng lưu lại các câu hỏi/bài tập học viên muốn đánh dấu học lại

CREATE TABLE UserQuestionBookmarks (

    BookmarkID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    QuestionID INT NOT NULL,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,

    CONSTRAINT UQ\_User\_Question UNIQUE (UserID, QuestionID)

);

\-- \==========================================

\-- NHÓM BÀI THI & CHẤM ĐIỂM

\-- \==========================================

CREATE TABLE Exams (

    ExamID INT IDENTITY(1,1) PRIMARY KEY,

    Title NVARCHAR(200) NOT NULL,

    Type NVARCHAR(50) NOT NULL, \-- Mock Test, Placement Test, Practice

    SkillFocus NVARCHAR(20) DEFAULT 'All', \-- \[CẬP NHẬT\] Đánh dấu đề là Reading, Listening, Writing, Speaking hay Full Test (All)

    Duration INT NOT NULL, 

    MentorID INT,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (MentorID) REFERENCES Users(UserID),

    Deleted BIT DEFAULT 0

);

CREATE TABLE ExamSections (

    SectionID INT IDENTITY(1,1) PRIMARY KEY,

    ExamID INT NOT NULL,

    SectionName NVARCHAR(100) NOT NULL, \-- Ví dụ: "Reading \- Passage 1", "Listening \- Part 3"

    ResourceID INT NULL, \-- Gắn Passage/Audio thẳng vào Section (nếu có)

    OrderIndex INT NOT NULL, 

    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID) ON DELETE CASCADE,

    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID)

);

CREATE TABLE ExamQuestions (

    SectionID INT NOT NULL,

    QuestionID INT NOT NULL,

    OrderIndex INT NOT NULL, 

    PRIMARY KEY (SectionID, QuestionID),

    FOREIGN KEY (SectionID) REFERENCES ExamSections(SectionID) ON DELETE CASCADE,

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE

);

CREATE TABLE TestSubmissions (

    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    ExamID INT NOT NULL,

    StartTime DATETIME NOT NULL,

    EndTime DATETIME,

    

    \-- Điểm thành phần để vẽ biểu đồ

    ListeningBand DECIMAL(3,1) NULL,

    ReadingBand DECIMAL(3,1) NULL,

    WritingBand DECIMAL(3,1) NULL,

    SpeakingBand DECIMAL(3,1) NULL,

    OverallBand DECIMAL(3,1) NULL,

    TotalScore DECIMAL(5,2) NULL,

    

    \-- Chống gian lận & Trạng thái làm bài

    ViolationCount INT DEFAULT 0, 

    IsCheated BIT DEFAULT 0, 

    Status NVARCHAR(20) DEFAULT 'InProgress', \-- InProgress, Completed, Abandoned

    \-- AI feedback

    OverallAIFeedback NVARCHAR(MAX),

    FOREIGN KEY (UserID) REFERENCES Users(UserID),

    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)

);

CREATE TABLE SubmissionDetails (

    DetailID INT IDENTITY(1,1) PRIMARY KEY,

    SubmissionID INT NOT NULL,

    QuestionID INT NOT NULL,

    CandidateAnswer NVARCHAR(MAX),

    SpeakingUrl NVARCHAR(500), 

    CandidateTranscript NVARCHAR(MAX) NULL, \-- \[CẬP NHẬT\] Lưu text sau khi Speech-to-text dịch ra để user xem lại và AI đọc

    IsCorrect BIT,

    Score DECIMAL(5,2),

    GradingStatus NVARCHAR(50) DEFAULT 'Graded', \-- 'Pending\_AI', 'Processing', 'Graded', 'Failed'

    FOREIGN KEY (SubmissionID) REFERENCES TestSubmissions(SubmissionID) ON DELETE CASCADE,

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)

);

CREATE TABLE AIEvaluations (

    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,

    DetailID INT NOT NULL,

    FeedbackJSON NVARCHAR(MAX) NOT NULL,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (DetailID) REFERENCES SubmissionDetails(DetailID) ON DELETE CASCADE,

    CONSTRAINT CHK\_FeedbackJSON CHECK (ISJSON(FeedbackJSON) \= 1\) 

);

\-- \==========================================

\-- NHÓM LỘ TRÌNH HỌC TẬP (AI SINH RA)

\-- \==========================================

CREATE TABLE Pathways (

    PathwayID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    PlacementTestID INT NULL, \-- Link với bài test đầu vào để biết điểm yếu

    TargetBand DECIMAL(3,1) NOT NULL,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID),

    FOREIGN KEY (PlacementTestID) REFERENCES TestSubmissions(SubmissionID)

);

CREATE TABLE WeeklyPlans (

    PlanID INT IDENTITY(1,1) PRIMARY KEY,

    PathwayID INT NOT NULL,

    WeekNumber INT NOT NULL,

    PlanContent NVARCHAR(MAX) NOT NULL, 

    IsCompleted BIT DEFAULT 0,

    FOREIGN KEY (PathwayID) REFERENCES Pathways(PathwayID) ON DELETE CASCADE,

    CONSTRAINT CHK\_PlanContent CHECK (ISJSON(PlanContent) \= 1\) 

);

\-- \==========================================

\-- NHÓM HỖ TRỢ, THÔNG BÁO & LOG HỆ THỐNG

\-- \==========================================

CREATE TABLE Tickets (

    TicketID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    Subject NVARCHAR(255) NOT NULL,

    Status NVARCHAR(50) DEFAULT 'Open', 

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID)

);

CREATE TABLE TicketReplies (

    ReplyID INT IDENTITY(1,1) PRIMARY KEY,

    TicketID INT NOT NULL,

    SenderID INT NOT NULL, 

    Message NVARCHAR(MAX) NOT NULL,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID) ON DELETE CASCADE,

    FOREIGN KEY (SenderID) REFERENCES Users(UserID)

);

\-- Bảng quản lý Thông báo

CREATE TABLE Notifications (

    NotificationID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    Title NVARCHAR(200) NOT NULL,

    Content NVARCHAR(MAX) NOT NULL,

    Type NVARCHAR(50) DEFAULT 'System', \-- System, Reminder, Payment, Exam

    IsRead BIT DEFAULT 0,

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE

);

\-- Bảng lưu Log hệ thống cho Admin

CREATE TABLE SystemLogs (

    LogID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NULL, \-- ID người thực hiện (NULL nếu là auto system event)

    Action NVARCHAR(100) NOT NULL, \-- Ví dụ: 'DELETE\_USER', 'API\_ERROR'

    Entity NVARCHAR(50), \-- Bảng hoặc Module bị tác động

    Details NVARCHAR(MAX), \-- Lưu raw error message hoặc JSON thao tác

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID)

);

GO

\-- \==========================================

\-- DỮ LIỆU MẶC ĐỊNH

\-- \==========================================

IF NOT EXISTS (SELECT \* FROM Roles WHERE RoleName \= 'Admin')

INSERT INTO Roles (RoleName, Description) VALUES

    ('Admin', N'Quản trị viên hệ thống'),

    ('Mentor', N'Giảng viên / Mentor IELTS'),

    ('Candidate', N'Học viên luyện thi IELTS');

GO

:**Lưu ý bổ sung về lộ trình học:**

* Hệ thống chỉ xây dựng lộ trình học theo từng tuần (với 2 kỹ năng được AI đề xuất mỗi tuần) trong thời hạn tối đa là 3 tháng.  
* Sau khi kết thúc giai đoạn 3 tháng này, người học bắt buộc phải thực hiện bài kiểm tra đánh giá lại (re-test) để hệ thống có cơ sở cập nhật và hiển thị các giai đoạn tiếp theo của lộ trình.  
* Cần bổ sung thêm trường dữ liệu (cột) trong bảng *WeeklyPlans* để ghi nhận và theo dõi trạng thái tuần học hiện tại của người dùng.

cập nhập cho người chưa tạo:ExamSections   
USE IELTSFlow;

GO

\-- 1\. Xóa bảng ExamQuestions cũ 

\-- LƯU Ý: Nếu đã có dữ liệu test, việc drop bảng này sẽ xóa các link câu hỏi của đề thi cũ.

\-- Vì dự án đang ở giai đoạn đầu, drop/recreate là cách nhanh nhất.

IF OBJECT\_ID('ExamQuestions', 'U') IS NOT NULL

    DROP TABLE ExamQuestions;

GO

\-- 2\. Tạo bảng ExamSections mới

CREATE TABLE ExamSections (

    SectionID INT IDENTITY(1,1) PRIMARY KEY,

    ExamID INT NOT NULL,

    SectionName NVARCHAR(100) NOT NULL, \-- Ví dụ: "Reading \- Passage 1", "Listening \- Part 3"

    ResourceID INT NULL, \-- Gắn Passage/Audio thẳng vào Section (nếu có)

    OrderIndex INT NOT NULL, 

    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID) ON DELETE CASCADE,

    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID)

);

GO

\-- 3\. Tạo lại bảng ExamQuestions theo cấu trúc mới

CREATE TABLE ExamQuestions (

    SectionID INT NOT NULL,

    QuestionID INT NOT NULL,

    OrderIndex INT NOT NULL, 

    PRIMARY KEY (SectionID, QuestionID),

    FOREIGN KEY (SectionID) REFERENCES ExamSections(SectionID) ON DELETE CASCADE,

    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE

);

GO

PRINT N'Đã cập nhật cấu trúc bảng ExamSections và ExamQuestions thành công\!';


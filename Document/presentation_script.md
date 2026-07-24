# Kịch bản Thuyết trình Sơ bộ Database - Dự án IELTSFlow
**Số lượng người trình bày:** 2 người
**Thời lượng dự kiến:** 5 - 7 phút
**Phân chia:** 
- **Người 1:** Overview + Module 1, 2, 3 (Nền tảng, Thanh toán, Dữ liệu học liệu)
- **Người 2:** Module 4, 5, 6, 7 (Thi cử, Lộ trình AI, Log hệ thống) + Tổng kết

---

## 🎤 PHẦN 1: Người trình bày 1 (Mở đầu & Nền tảng Dữ liệu)

**[Lời chào & Giới thiệu tổng quan]**
**Người 1:** "Chào thầy/cô và các bạn. Hôm nay, nhóm chúng em xin trình bày sơ bộ về kiến trúc Cơ sở dữ liệu của dự án IELTSFlow. Để hệ thống hoạt động tối ưu, trơn tru và dễ dàng mở rộng (scale) sau này, chúng em đã chuẩn hóa và chia database thành 7 module chính. Em sẽ trình bày 3 module nền tảng đầu tiên, sau đó bạn [Tên Người 2] sẽ trình bày về phần cốt lõi thi cử và AI."

**[Module 1: Quản trị người dùng & Hồ sơ]**
**Người 1:** "Đầu tiên là **Module Quản trị người dùng & Hồ sơ**. Trái tim của module này là bảng `Users` và `Roles`, giúp phân quyền rõ ràng 3 nhóm: Admin, Mentor và Candidate. Hệ thống có hỗ trợ đăng nhập qua Google/Facebook. Điểm đặc biệt ở đây là bảng `CandidateTargets` lưu trữ mục tiêu Band điểm IELTS của học viên, đây chính là dữ liệu đầu vào quan trọng để AI tính toán lộ trình học sau này."

**[Module 2: Gói cước & Thanh toán]**
**Người 1:** "Tiếp theo là **Module Gói cước & Thanh toán**. Để thương mại hóa sản phẩm, chúng em thiết kế bảng `SubscriptionPackages` chứa các gói học. Khi học viên thanh toán, hệ thống sẽ lưu vào `Transactions` với việc tích hợp Webhook qua SePay để tự động đối soát. Nếu thành công, tài khoản sẽ được cập nhật thời hạn trong bảng `UserSubscriptions`."

**[Module 3: Ngân hàng đề thi & Học liệu]**
**Người 1:** "Thứ ba, và cũng là một module rất lớn: **Ngân hàng đề thi & Học liệu**. Bảng `Questions` và `Answers` được thiết kế linh hoạt bằng cách sử dụng `contentJSON`, cho phép lưu trữ đa dạng các loại câu hỏi phức tạp của IELTS như Matching, Fill in blanks, hay Multiple Choice. Ngoài ra còn có các bảng `Tags` để phân loại độ khó, dạng bài, và bảng `Lessons` để Mentor đăng tải tài liệu học tập.

Tiếp theo, xin mời [Tên Người 2] trình bày về cách hệ thống lấy dữ liệu này để tổ chức thi và tích hợp AI."

---

## 🎤 PHẦN 2: Người trình bày 2 (Thi cử, AI & Hệ thống)

**[Chuyển đoạn & Module 4: Bài thi & Chấm điểm]**
**Người 2:** "Cảm ơn [Tên Người 1]. Chào thầy/cô và các bạn, em xin phép tiếp tục với **Module thứ 4: Bài thi & Chấm điểm**. Từ ngân hàng đề, chúng em cấu trúc thành 1 bài thi hoàn chỉnh qua các bảng `Exams` và `ExamSections`. 
Khi học viên thi xong, dữ liệu nộp bài lưu vào `TestSubmissions`. Đặc biệt với kỹ năng Speaking và Writing, kết quả thô sẽ được đưa cho AI đánh giá, và phản hồi chi tiết của AI sẽ được lưu trữ dưới dạng JSON trong bảng `AIEvaluations` để vẽ biểu đồ và hiển thị lỗi sai cho người dùng."

**[Module 5: Lộ trình học tập (AI)]**
**Người 2:** "Phần nổi bật nhất của dự án là **Module Lộ trình học tập**. Dựa vào kết quả bài thi đầu vào (Placement Test) và mục tiêu điểm số, AI sẽ tạo ra một lộ trình học cá nhân hóa lưu vào bảng `Pathways`. Lộ trình này không phải là một khối cứng nhắc, mà được chia nhỏ theo từng tuần và lưu vào bảng `WeeklyPlans`, giúp học viên biết chính xác mỗi tuần phải tập trung vào kỹ năng nào."

**[Module 6: Hỗ trợ, Thông báo & Log]**
**Người 2:** "Để đảm bảo hệ thống vận hành tốt, chúng em có **Module Hỗ trợ & Log hệ thống**. Gồm bảng `Tickets` để học viên hỏi đáp với Mentor, `Notifications` để nhắc nhở lịch học, lịch hết hạn gói. Và quan trọng nhất là bảng `SystemLogs` để Admin theo dõi, lưu vết (audit) mọi hành động quan trọng trên hệ thống, giúp dễ dàng debug và phát hiện lỗi."

**[Module 7: File Management & Tổng kết]**
**Người 2:** "Cuối cùng là **Module Quản lý File Upload**. Vì hệ thống có nhiều tài liệu, audio, video lớn, chúng em dùng bảng `UploadedFiles` và `upload_sessions` để hỗ trợ cơ chế Upload phân mảnh (Chunked Upload), chống đứt gãy kết nối mạng.

**[Kết luận]**
**Người 2:** "Tóm lại, database của IELTSFlow được thiết kế bám sát kiến trúc hệ thống hiện đại, tối ưu cho việc truy vấn (không JOIN bừa bãi khi lấy đề thi để chống lộ đáp án) và tương thích hoàn toàn với định dạng JSON để tích hợp sâu các API của AI (OpenAI, Gemini).
Đó là tổng quan về thiết kế Database của nhóm em. Cảm ơn thầy/cô và các bạn đã chú ý lắng nghe. Chúng em rất mong nhận được những góp ý từ mọi người ạ!"

# Kế hoạch & Phân công Kiểm thử Tự động (Selenium E2E) - Nhóm 6

## 1. Phân công công việc (Task Distribution)

Dựa trên tài liệu mô tả hệ thống IELTSFlow (tại file `swp_motabandau.md`), công việc viết kịch bản kiểm thử (E2E Test) bằng Selenium được chia đều cho 6 thành viên như sau:

### 🧑‍💻 Thành viên 1: Core Framework & Setup (Nên giao cho Leader/Người cứng code)
- **Nhiệm vụ:**
  - Setup dự án Maven, thêm các thư viện (Selenium 4, JUnit 5, ExtentReports).
  - Viết file `BaseTest.java` chứa các hàm cấu hình chung (`@BeforeEach` khởi tạo WebDriver, `@AfterEach` đóng browser và dọn dẹp).
  - Viết hàm tự động chụp ảnh màn hình (`TakesScreenshot`) khi test fail và lưu vào thư mục `screenshots/`.
  - Cấu hình sinh báo cáo tự động ra file `E2E_TestResults.html`.
  - Viết các hàm tiện ích (Utils) hỗ trợ nhóm: Đăng nhập nhanh (không qua giao diện nếu cần), Wait helper (cấu hình sẵn Explicit Wait).
- **Mục tiêu:** Tạo bộ khung (Base) chuẩn và ổn định. 5 thành viên còn lại chỉ việc sử dụng bộ khung này để tập trung viết test logic.

### 🧑‍💻 Thành viên 2: Phân hệ Guest & Xác thực (Authentication)(Hòa)
- **Nhiệm vụ Test:**
  - **Landing Page:** Kiểm tra hiển thị đúng thông tin, các nút điều hướng.
  - **Form Đăng ký:** Validate dữ liệu (email đã tồn tại, sai format, mật khẩu yếu), đăng ký thành công.
  - **Form Đăng nhập:** Đăng nhập sai thông tin, đăng nhập thành công, đăng nhập qua bên thứ 3 (Google - nếu có thể mock).
  - **Quản lý tài khoản:** Đổi mật khẩu, cập nhật hồ sơ cá nhân, đặt mục tiêu (Target Band) IELTS.

### 🧑‍💻 Thành viên 3: Phân hệ Candidate - Luyện tập & AI (Practice & Learning)(Minh)
- **Nhiệm vụ Test:**
  - **Luyện Listening & Reading:** Thao tác tự động chọn đáp án (Multiple Choice), kéo thả/điền từ (Fill in blanks/Matching) và bấm submit. Kiểm tra kết quả trả về tức thì.
  - **Luyện Writing:** Nhập text vào ô soạn thảo, kiểm tra đếm số từ. Bấm submit và xác minh hệ thống có gọi API chấm điểm AI.
  - **Luyện Speaking:** Viết script mock hành vi thu âm (hoặc đẩy file audio trực tiếp lên API qua DOM) và kiểm tra kết quả phân tích Speech-to-text.

### 🧑‍💻 Thành viên 4: Phân hệ Candidate - Thi thử (Mock Test)(Vương)
- **Nhiệm vụ Test:**
  - **Luồng Mock Test:** Khởi tạo luồng thi mô phỏng 4 kỹ năng có đồng hồ đếm ngược thời gian.
  - **Focus Mode (Chế độ tập trung):** Dùng script giả lập thao tác đổi tab trình duyệt hoặc thoát Full-screen để kiểm tra hệ thống có đếm số lần vi phạm, hiện cảnh báo và tự động nộp bài khi quá giới hạn hay không.
  - **Trả kết quả:** Xác nhận hiển thị điểm 4 kỹ năng, dự đoán Overall Band.

### 🧑‍💻 Thành viên 5: Phân hệ Mentor (Giảng viên)(Duy)
- **Nhiệm vụ Test:**
  - **Quản lý Ngân hàng đề (Bank Management):** Test thao tác Tạo/Sửa/Xóa câu hỏi. *Lưu ý đặc biệt test kỹ các form phức tạp như Matching, Fill in blanks (do lưu bằng JSON)*.
  - **Quản lý Đề thi:** Thao tác ghép câu hỏi thành một Mock Test hoàn chỉnh.
  - **Quản lý Tài liệu:** Luồng upload video hoặc tài liệu dạng PDF.
  - **Q&A/Ticket:** Thao tác trả lời ticket thắc mắc của học viên.

### 🧑‍💻 Thành viên 6: Phân hệ Admin & Thanh toán (Subscription & Payment) (Tân)
- **Nhiệm vụ Test:**
  - **User Management:** Khóa tài khoản, mở khóa, phân quyền user (cấp quyền Mentor).
  - **Finance (Quản lý gói cước):** Tạo/Sửa các gói Subscription (Candidate Pro).
  - **Thanh toán (Payment Gateway):** Test luồng mua gói Pro. Có thể mock payload trả về từ cổng thanh toán (SePay) vào Webhook hoặc DB để kiểm tra xem tài khoản có được tự động cập nhật trạng thái "Active" gói cước hay không.

---

## 2. Hướng dẫn Setup ban đầu cho toàn nhóm

Mọi người thực hiện các bước sau để có thể bắt tay vào code ngay:

### Bước 1: Chuẩn bị Workspace
Nếu nhóm viết code Selenium cùng chung repo với mã nguồn Backend (IELTSFLOW), hãy tạo thư mục chứa test hoặc thêm Module Maven mới (ví dụ: thư mục `E2E_Tests`).

### Bước 2: Cài đặt thư viện (Dependencies)
**Thành viên 1** sẽ cập nhật file `pom.xml` của project test với các thư viện cần thiết. Các thành viên khác chỉ cần `git pull` và Maven Reload.
```xml
<dependencies>
    <!-- Selenium WebDriver -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.18.1</version> <!-- Version mới hỗ trợ Selenium 4 -->
    </dependency>
    <!-- JUnit 5 (Khuyên dùng thay vì JUnit 4) -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-engine</artifactId>
        <version>5.10.2</version>
        <scope>test</scope>
    </dependency>
    <!-- Thư viện tạo file E2E_TestResults.html -->
    <dependency>
        <groupId>com.aventstack</groupId>
        <artifactId>extentreports</artifactId>
        <version>5.1.1</version>
    </dependency>
</dependencies>
```

### Bước 3: Cấu trúc thư mục Test chuẩn hóa (Nên áp dụng Page Object Model - POM)
Nên phân chia các file Java như sau để dễ quản lý giữa 6 người:
- `src/test/java/com/ieltsflow/automation/base/` : Chứa `BaseTest.java`.
- `src/test/java/com/ieltsflow/automation/pages/` : Chứa các định nghĩa Element (Locators) của các trang (VD: `LoginPage.java`, `MentorDashboardPage.java`).
- `src/test/java/com/ieltsflow/automation/tests/` : Chứa các file kịch bản Test cụ thể (VD: `AuthenticationTest.java`, `MockTestFlowTest.java`).
- `src/test/java/com/ieltsflow/automation/utils/` : Hàm Helper, Screenshot, Config.

### Bước 4: Viết AutomationLog.md chung
Tạo 1 file `AutomationLog.md` ở thư mục gốc của project.
Trong quá trình code, ai gặp khó khăn/lỗi thì **bắt buộc** phải ghi vào đây theo format:
- **[Tên thành viên] - [Tính năng]:** [Lỗi gặp phải] -> **Cách giải quyết:** [Cách sửa].
*Ví dụ:* "[Nguyễn Văn A] - [Login]: Lỗi nút Đăng nhập bị chặn click -> Cách giải quyết: Đổi từ click chuột thông thường sang dùng JavascriptExecutor".

### ⚠️ QUY TẮC BẮT BUỘC (Tránh conflict và vỡ test):
1. **Locators:** Tuyệt đối không copy XPath tuyệt đối từ trình duyệt. Chỉ dùng ID, Name, hoặc CSS Selector ngắn gọn.
2. **Waits:** Không được viết lệnh `Thread.sleep(3000)`. Hãy dùng `WebDriverWait` kết hợp `ExpectedConditions` (Explicit Wait).
3. **Độc lập:** Mỗi Test Case (`@Test`) phải hoàn toàn độc lập, chạy riêng lẻ vẫn phải Pass, không được phụ thuộc trạng thái của Test Case trước.

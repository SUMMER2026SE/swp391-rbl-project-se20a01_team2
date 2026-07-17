# IELTSFLOW E2E Automation Testing Framework

Tài liệu này mô tả cấu trúc và hướng dẫn cách thiết lập, cấu hình và chạy bộ End-to-End (E2E) Test cho dự án IELTSFLOW. 
Framework được xây dựng dựa trên **Selenium WebDriver**, **JUnit 5**, và áp dụng mô hình **Page Object Model (POM)** để đảm bảo tính tái sử dụng và dễ bảo trì.

---

## 1. Kiến Trúc Framework (Page Object Model)

Mã nguồn test automation nằm trong thư mục: `src/test/java/com/ieltsflow/automation/`.

Framework tuân thủ thiết kế **Page Object Model (POM)** với cấu trúc thư mục như sau:

```text
automation/
├── base/          # Nền tảng của Framework
│   ├── BasePage.java   # Class cha của tất cả các Pages, chứa các hàm thao tác web chung (click, sendKeys, getText,...)
│   └── BaseTest.java   # Class cha của tất cả các Tests, quản lý vòng đời WebDriver (Setup/Teardown) và ExtentReports
├── pages/         # Page Objects (Đại diện cho UI của trang web)
│   ├── LoginPage.java
│   ├── CheckoutPage.java
│   ├── AdminSubscriptionPage.java
│   └── ...             # Mỗi class tương ứng với một trang hoặc một thành phần trên giao diện
├── tests/         # Các kịch bản kiểm thử (Test Cases)
│   ├── AdminSubscriptionTest.java
│   ├── CandidatePaymentTest.java
│   └── ...             # Sử dụng JUnit 5 (@Test) và gọi các hàm từ thư mục pages/
└── utils/         # Các tiện ích (Utilities) hỗ trợ test
    ├── ConfigReader.java        # Đọc cấu hình từ file .properties / .env
    ├── DriverFactory.java       # Khởi tạo và quản lý WebDriver (Chrome, Firefox, Edge)
    ├── WaitHelper.java          # Các hàm Explicit Wait (chờ đợi element)
    └── ExtentReportManager.java # Quản lý xuất file báo cáo HTML sau khi test chạy xong
```

---

## 2. Cấu Hình Chạy Test (Configuration)

Framework hỗ trợ đọc cấu hình với độ ưu tiên như sau:
`System Properties` > `.env` > `{env}.properties` > `OS Environment Variables` > `Giá trị mặc định`.

Môi trường mặc định là `dev`. File cấu hình mẫu được đặt tại:
`src/test/resources/config/dev.properties.example`

### Cách thiết lập cấu hình:
1. Sao chép file `dev.properties.example` thành `dev.properties` trong thư mục `src/test/resources/config/`.
2. Thay đổi các thông số bên trong `dev.properties` cho phù hợp với môi trường chạy ở máy của bạn:

```properties
# Thông tin trình duyệt
browser=chrome       # Các trình duyệt hỗ trợ: chrome, firefox, edge
headless=false       # Đặt true nếu muốn chạy ngầm (không mở UI trình duyệt lên)

# Cấu hình dự án
TEST_BASE_URL=http://localhost:8080/IELTSFLOW

# Tài khoản test
TEST_ADMIN_EMAIL=admin@gmail.com
TEST_ADMIN_PASSWORD=admin123
TEST_CANDIDATE_EMAIL=candidate1@gmail.com
TEST_CANDIDATE_PASSWORD=12345678
```

> **Lưu ý:** Framework cũng có thể lấy trực tiếp các biến môi trường nhạy cảm từ file `src/main/webapp/WEB-INF/.env` nếu có.

---

## 3. Báo Cáo Kết Quả Test (Reporting)

Framework sử dụng **ExtentReports** để tạo báo cáo dưới dạng giao diện HTML trực quan.
- Mỗi khi chạy test (Kế thừa `BaseTest`), báo cáo sẽ tự động được sinh ra.
- **Vị trí file report:** Nằm tại thư mục gốc của project (hoặc thư mục target) với tên dạng `E2E_TestResults.html`.
- Bạn có thể mở file `.html` này bằng trình duyệt web để xem chi tiết kết quả Test (Passed/Failed), thời gian chạy và các bước tương tác.

---

## 4. Hướng Dẫn Chạy Test

**Lưu ý quan trọng:** Các bài kiểm thử Selenium E2E được thiết lập **bỏ qua (exclude)** khi build tự động bằng lệnh `mvn test` mặc định hoặc `mvn clean package` trong cấu hình `pom.xml` (`maven-surefire-plugin`). Điều này để tránh việc build dự án bị chậm hoặc bị lỗi trên server không có giao diện (CI/CD) khi chưa config headless mode.

Vì vậy, bạn cần chạy Test một cách chủ động:

### Cách 1: Chạy bằng IDE (Được khuyến nghị)
*Hỗ trợ tốt nhất trên IntelliJ IDEA, Eclipse, NetBeans.*

1. Đảm bảo ứng dụng backend/server của dự án (`Tomcat` hoặc `Glassfish`) đang chạy ở môi trường Local (`localhost:8080`).
2. Điều hướng đến thư mục `src/test/java/com/ieltsflow/automation/tests/`.
3. Mở một class Test cụ thể (VD: `CandidatePaymentTest.java`).
4. Click chuột phải vào class hoặc nhấn nút `Run` màu xanh (Play button) kế bên khai báo class/hàm `@Test`.
5. IDE sẽ tự động kích hoạt WebDriver, mở trình duyệt và thực thi kịch bản.

### Cách 2: Chạy bằng Maven thông qua Command Line
Nếu muốn ép Maven chạy một file test cụ thể, bạn có thể chạy lệnh:

```bash
mvn -Dtest=com.ieltsflow.automation.tests.CandidatePaymentTest test
```

> Hoặc nếu bạn muốn thiết lập chạy headless trên một môi trường cụ thể (ví dụ staging), truyền biến qua System Property:
```bash
mvn -Dtest=com.ieltsflow.automation.tests.*Test -Denv=staging -Dheadless=true test
```

---

## 5. Quy Ước Khi Viết Test Mới

1. **Tuân thủ POM:** Tuyệt đối không gọi `driver.findElement(...)` trực tiếp trong file Test (`tests/`). Tất cả các thao tác tương tác giao diện phải được viết thành hàm trong lớp Page tương ứng (`pages/`).
2. **Kế thừa đúng class:** 
   - Mọi class trong thư mục `pages/` phải được `extends BasePage`.
   - Mọi class trong thư mục `tests/` phải được `extends BaseTest`.
3. **Sử dụng Utility Waits:** Hãy sử dụng `WaitHelper` hoặc các Wait methods có sẵn trong `BasePage` thay vì dùng `Thread.sleep()` tĩnh để framework chạy ổn định, nhanh và tránh lỗi "No Such Element".

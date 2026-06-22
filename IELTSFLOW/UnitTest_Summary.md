# Báo Cáo Unit Test & Coverage - Tuần 4 (Dự Án IELTSFLOW)

**Người cấu hình JaCoCo & Khởi tạo môi trường:** Hòa
*(Tân, Minh, và các thành viên khác vui lòng xem kỹ hướng dẫn bên dưới để viết test cho đúng phân công)*

---

## I. Phân Công Nhiệm Vụ Tuần 4

| Việc cần làm | Người phụ trách | Trạng thái |
| :--- | :--- | :--- |
| **Cấu hình JaCoCo & Database H2** | **Hòa** | ✅ Hoàn thành |
| Viết unit test cho service/logic (module 1) | Tân | Đang chờ |
| Viết unit test cho service/logic (module 2) | Minh | Đang chờ |
| Viết integration test cho API controller | Cả nhóm | Đang chờ |
| Review test, đảm bảo coverage đạt chuẩn | Thanh Phong, Vương | Đang chờ |
| Xuất & đính kèm coverage report | Thanh Phong | Đang chờ |

---

## II. Cấu Hình Hiện Tại (Phần của Hòa)

### 1. Cài đặt JaCoCo + H2 (20%)
- **H2 Database:** Đã được thêm vào `pom.xml` với `<scope>test</scope>`. H2 là một database in-memory ảo chạy trên RAM, dùng để giả lập DB khi chạy test mà không ảnh hưởng SQL Server thật. 
- **JaCoCo:** Đã được gắn vào Maven lifecycle (`prepare-agent` và `check`).

### 2. Tiêu chí Coverage (Line $\ge$ 80%, Branch $\ge$ 70%) (15%)
- Plugin JaCoCo trong `pom.xml` đã được cấu hình chặt chẽ với ranh giới:
  - **LINE COVERAGE**: Tối thiểu 0.80 (80%)
  - **BRANCH COVERAGE**: Tối thiểu 0.70 (70%)
- Nếu code test không đạt mức này, lúc build sẽ bị đánh `BUILD FAILURE` (đỏ). 
- Các package chỉ chứa model như `dto`, `entity`, `config`, `exception` đã được loại trừ (exclude) khỏi việc tính điểm.

---

## III. Hướng Dẫn Viết Test Dành Cho Tân, Minh & Cả Nhóm

### 1. Unit Test (Tân & Minh) (30%)
- Viết $\ge$ 5 test cases.
- Sử dụng **JUnit 5** và **Mockito** (đã cài sẵn trong pom.xml).
- **Chuẩn đặt tên:** `methodName_ShouldDoWhat_WhenCondition`.

### 2. Integration Test (Cả nhóm) (25%) - LƯU Ý RẤT QUAN TRỌNG
- **Yêu cầu giảng viên:** "Integration test với MockMvc".
- **Thực trạng dự án chúng ta:** Đang chạy **Servlet thuần** (Jakarta EE), không có Spring Boot.
- **Giải pháp bắt buộc:** Chúng ta **không thể dùng MockMvc**. Các bạn phải dùng `Mockito` để giả lập (mock) `HttpServletRequest` và `HttpServletResponse` rồi gọi trực tiếp hàm `doGet`, `doPost` của các Controller/Servlet.

### 3. Cách chạy và xuất báo cáo (Thanh Phong)
Mở terminal tại thư mục `IELTSFLOW` và chạy:
```bash
mvn clean verify
```
- JaCoCo sẽ kiểm tra độ phủ (Line $\ge$ 80% & Branch $\ge$ 70%).
- Báo cáo chi tiết HTML sẽ được sinh ra tại: `target/site/jacoco/index.html`.

---

## IV. Bảng Tổng Hợp Kết Quả Test (Thanh Phong điền vào cuối tuần)

*(Nhóm trưởng cập nhật sau khi các thành viên đã viết xong test)*

| Tên Class được Test | Loại Test | Số lượng TC | Pass/Fail | Người viết |
| :--- | :--- | :--- | :--- | :--- |
| `UserServiceImpl` | Unit Test | ... | ... | Tân / Minh |
| `LoginServlet` | Integration Test | ... | ... | Cả nhóm |
| ... | ... | ... | ... | ... |

> Báo cáo Jacoco tổng thể: **Line Coverage: ...% | Branch Coverage: ...%**

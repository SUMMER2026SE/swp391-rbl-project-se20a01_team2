# Bug Reports - Exploratory Testing
**Người thực hiện:** Thành viên 2 (Hòa)
**Module Test:** Guest, Authentication & Account Management

---

### Bug 01: Mật khẩu yếu vẫn có thể vượt qua validate nếu dùng tiếng Việt có dấu
- **ID:** BUG-AUTH-001
- **Tiêu đề:** Form Đăng ký không chặn mật khẩu yếu khi chứa ký tự tiếng Việt có dấu.
- **Severity (Mức độ nghiêm trọng):** Major
- **Priority (Độ ưu tiên):** P2
- **Môi trường:** 
  - OS: Windows 11
  - Browser: Chrome Version 114.0
  - URL: `http://localhost:8080/auth` (Tab Đăng ký)
- **Bước tái hiện:**
  1. Truy cập trang Đăng ký tài khoản.
  2. Nhập thông tin hợp lệ vào các trường Họ Tên, Email.
  3. Tại trường Mật khẩu, nhập: `mậtkhẩu` (chỉ có chữ thường, không có số hay ký tự đặc biệt, nhưng là tiếng Việt có dấu).
  4. Nhập lại mật khẩu tương tự vào trường Xác nhận mật khẩu.
  5. Tick chọn "Đồng ý điều khoản" và click nút "Đăng ký".
- **Kết quả thực tế:** Hệ thống hiển thị Password Strength là "Yếu" nhưng vẫn cho phép đăng ký thành công và chuyển hướng vào Dashboard.
- **Kết quả mong đợi:** Hệ thống phải chặn lại, hiển thị cảnh báo đỏ "Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số" và không cho form submit.
- **Evidence:** Cần đính kèm ảnh chụp màn hình form đăng ký báo "Yếu" nhưng vẫn có thông báo "Đăng ký thành công".

---

### Bug 02: Lỗi giao diện (UI) thanh điều hướng trên Landing Page khi thu nhỏ màn hình
- **ID:** BUG-UI-002
- **Tiêu đề:** Nút "Đăng nhập" và "Đăng ký" bị tràn ra ngoài màn hình trên thiết bị di động.
- **Severity (Mức độ nghiêm trọng):** Minor
- **Priority (Độ ưu tiên):** P3
- **Môi trường:** 
  - OS: iOS 16 / Windows 11 (Chế độ Responsive Design Mode)
  - Browser: Safari / Chrome (kích thước màn hình iPhone 12 Pro - 390x844)
  - URL: `http://localhost:8080/`
- **Bước tái hiện:**
  1. Mở trang chủ (Landing Page) trên trình duyệt.
  2. Bật công cụ Developer Tools (F12) -> Chọn Responsive Device Mode (Ctrl+Shift+M).
  3. Chọn thiết bị iPhone 12 Pro hoặc thu hẹp chiều ngang cửa sổ xuống dưới 400px.
- **Kết quả thực tế:** Thanh điều hướng (Navbar) không tự động chuyển thành Hamburger Menu. Nút "Đăng ký" bị khuất hoàn toàn bên phải màn hình, người dùng không thể bấm được.
- **Kết quả mong đợi:** CSS Responsive cần hoạt động, Navbar phải gom lại thành icon 3 gạch (Hamburger Menu) để người dùng Mobile có thể thao tác.
- **Evidence:** Cần đính kèm ảnh chụp màn hình (Screenshot) giao diện bị vỡ trên Mobile.

---

### Bug 03: Đổi Target Band IELTS không cập nhật ngay lập tức ở giao diện Header
- **ID:** BUG-ACC-003
- **Tiêu đề:** Nút lưu Target Band báo thành công nhưng số điểm trên Header Navbar không tự động làm mới.
- **Severity (Mức độ nghiêm trọng):** Trivial
- **Priority (Độ ưu tiên):** P4
- **Môi trường:** 
  - OS: MacOS 13
  - Browser: Edge Version 115.0
  - URL: `http://localhost:8080/ielts-target`
- **Bước tái hiện:**
  1. Đăng nhập bằng tài khoản Candidate.
  2. Truy cập vào trang "Thiết lập Target Band".
  3. Chọn mục tiêu mới (ví dụ: từ 6.5 đổi sang 7.5).
  4. Nhấn nút "Lưu thay đổi".
  5. Quan sát thanh Header ở trên cùng (nơi hiển thị Avatar và thông tin tóm tắt).
- **Kết quả thực tế:** Toast message báo "Cập nhật thành công" hiện lên, dữ liệu trong Database đã lưu 7.5, nhưng con số hiển thị trên Header vẫn là 6.5. Người dùng phải bấm F5 tải lại trang thì Header mới cập nhật số mới.
- **Kết quả mong đợi:** Khi lưu thành công (nhận API response 200), frontend cần dùng Javascript để tự động cập nhật số 7.5 lên Header mà không cần tải lại toàn bộ trang.
- **Evidence:** Cần đính kèm Video quay lại màn hình thao tác đổi điểm.

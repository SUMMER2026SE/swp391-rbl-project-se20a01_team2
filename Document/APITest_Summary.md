# Tổng kết Kiểm thử API (API Test Summary)

Tài liệu này ghi nhận kết quả chạy test API bằng Postman cho hệ thống IELTSFlow trên cả 2 môi trường Local và Deploy.

---

## 1. Authentication Endpoints (Xác thực & Quản lý Tài khoản)
**Người thực hiện:** [Tên của bạn]

| API / Endpoint | Method | Test Case (Happy/Negative) | Status (Pass/Fail/Pending) | Ghi chú / Lỗi gặp phải |
| :--- | :---: | :--- | :---: | :--- |
| `/register` | POST | Happy Path (Đăng ký thành công) | Pass | |
| `/register` | POST | Negative: Missing Field (Thiếu Email) | Pass | |
| `/register` | POST | Negative: Wrong Type (Pass không khớp) | Pass | |
| `/api/auth/login` | POST | Happy Path (Đăng nhập đúng thông tin) | Pass | |
| `/api/auth/login` | POST | Negative: Missing Field (Không nhập pass) | Pass | |
| `/api/auth/login` | POST | Negative: Invalid Format (Sai email format) | Pass | |
| `/api/auth/google` | POST | Negative: Token không hợp lệ | Pass | Cần Token thực để test Happy Path |
| `/api/auth/logout` | POST | Happy Path (Đăng xuất khi có Session) | Pass | Xác nhận đã Clear cookie JSESSIONID |
| `/api/auth/logout` | POST | Negative: Không có Session | Pass | |
| `/forgot-password` | POST | Happy Path (Gửi OTP thành công) | Pass | |
| `/forgot-password` | POST | Negative (Thiếu email) | Pass | |
| `/change-password` | POST | Happy Path (Đổi mật khẩu thành công) | Pass | Cần login session |
| `/change-password` | POST | Negative (Mật khẩu không khớp) | Pass | Cần login session |
| `/verify-email` | GET | Happy Path (Xác thực email thành công) | Pass | Cần token hợp lệ |
| `/verify-email` | GET | Negative (Thiếu token) | Pass | |
| `/auth` | POST | Happy Path (Forward sang trang đăng nhập/đăng ký) | Pass | |
| `/auth` | POST | Negative (Action không hợp lệ) | Pass | |

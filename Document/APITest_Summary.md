# Tổng kết Kiểm thử API (API Test Summary)

Tài liệu này ghi nhận kết quả chạy test API bằng Postman cho hệ thống IELTSFlow trên cả 2 môi trường Local và Deploy.

---

## 1. Authentication Endpoints (Xác thực & Quản lý Tài khoản)
**Người thực hiện:** [Tên của bạn]

| API / Endpoint | Method | Test Case (Happy/Negative) | Status (Pass/Fail/Pending) | Ghi chú / Lỗi gặp phải |
| :--- | :---: | :--- | :---: | :--- |
| `/register` | POST | Happy Path (Đăng ký thành công) | Pending | |
| `/register` | POST | Negative: Missing Field (Thiếu Email) | Pending | |
| `/register` | POST | Negative: Wrong Type (Pass không khớp) | Pending | |
| `/api/auth/login` | POST | Happy Path (Đăng nhập đúng thông tin) | Pending | |
| `/api/auth/login` | POST | Negative: Missing Field (Không nhập pass) | Pending | |
| `/api/auth/login` | POST | Negative: Invalid Format (Sai email format) | Pending | |
| `/api/auth/google` | GET | Happy Path (Chuyển hướng Google OAuth) | Pending | Yêu cầu test trên trình duyệt/cửa sổ thật |
| `/api/auth/logout` | POST | Happy Path (Đăng xuất khi có Session) | Pending | Xác nhận đã Clear cookie JSESSIONID |
| `/api/auth/logout` | POST | Negative: Không có Session | Pending | |

---

## 2. Speech Assessment Endpoints (Chấm điểm phát âm)
**Người thực hiện:** [Tên thành viên 2]

| API / Endpoint | Method | Test Case (Happy/Negative) | Status (Pass/Fail/Pending) | Ghi chú / Lỗi gặp phải |
| :--- | :---: | :--- | :---: | :--- |
| `/api/speech/assess` | POST | Happy: Đánh giá có kịch bản (Reference text) | | |
| `/api/speech/assess` | POST | Happy: Đánh giá tự do (Speech-to-text) | | |
| `/api/speech/assess` | POST | Negative: ... (Bổ sung thêm) | | |

*(Phần này chừa lại để các bạn khác tự bổ sung test cases tương ứng)*

---

## 3. File Upload & Transaction Endpoints (Upload & Thanh toán)
**Người thực hiện:** [Tên thành viên 3]

| API / Endpoint | Method | Test Case (Happy/Negative) | Status (Pass/Fail/Pending) | Ghi chú / Lỗi gặp phải |
| :--- | :---: | :--- | :---: | :--- |
| `/api/upload` | POST | Happy: Upload ảnh/file thành công | | |
| `/webhook/sepay` | POST | Happy: Webhook cập nhật giao dịch thành công | | |
| `/api/transaction/status`| GET | ... (Bổ sung thêm) | | |

*(Phần này chừa lại để các bạn khác tự bổ sung test cases tương ứng)*

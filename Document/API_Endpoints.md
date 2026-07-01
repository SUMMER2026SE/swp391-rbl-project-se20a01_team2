# Tổng quan API IELTSFlow

Tài liệu này tổng hợp toàn bộ các API/Endpoint trong hệ thống web IELTSFlow, được trích xuất trực tiếp từ source code (Controller/Servlet) và đối chiếu với tài liệu `swp_motabandau.md`.
Các endpoint được phân loại theo từng phân hệ và vai trò người dùng để dễ dàng tra cứu.

## 1. Authentication Endpoints (Xác thực & Quản lý Tài khoản)
*(Đây là các endpoint liên quan trực tiếp đến luồng xác thực, đăng nhập và bảo mật tài khoản)*

| Endpoint / URL Pattern | Servlet / Controller | Mô tả dự kiến |
| :--- | :--- | :--- |
| `/api/auth/login`, `/login` | `LoginServlet` | Xử lý đăng nhập bằng email và mật khẩu |
| `/register` | `RegisterServlet` | Đăng ký tài khoản học viên mới |
| `/auth/google`, `/api/auth/google` | `GoogleAuthServlet` | Đăng nhập/Đăng ký qua tài khoản Google (OAuth2) |
| `/api/auth/logout`, `/logout` | `LogoutServlet` | Xử lý đăng xuất và xóa session |
| `/forgot-password` | `ForgotPasswordServlet` | Gửi email khôi phục mật khẩu khi người dùng quên |
| `/change-password` | `ChangePasswordServlet` | Đổi mật khẩu cho người dùng đang đăng nhập |
| `/verify-email` | `VerifyEmailServlet` | Xác thực địa chỉ email sau khi đăng ký |
| `/auth` | `AuthServlet` | Điều hướng hoặc xử lý các lỗi xác thực chung |

---

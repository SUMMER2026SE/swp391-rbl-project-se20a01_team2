package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Render view
        req.getRequestDispatcher("/jsp/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        try {
            if ("sendOtp".equals(action)) {
                String email = req.getParameter("email");
                if (email == null || email.isBlank()) {
                    throw new Exception("Vui lòng nhập email");
                }
                userService.forgotPassword(email);
                session.setAttribute("resetEmail", email);
                req.setAttribute("step", "verifyOtp");
                req.setAttribute("successMessage", "Mã xác thực đã được gửi tới email của bạn.");

            } else if ("verifyOtp".equals(action)) {
                String otp = req.getParameter("otp");
                String email = (String) session.getAttribute("resetEmail");
                if (email == null) {
                    throw new Exception("Yêu cầu đã hết hạn. Vui lòng thử lại.");
                }
                
                String resetToken = userService.verifyOtp(email, otp);
                session.setAttribute("resetToken", resetToken);
                req.setAttribute("step", "resetPassword");

            } else if ("resetPassword".equals(action)) {
                String newPassword = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");
                String resetToken = (String) session.getAttribute("resetToken");

                if (resetToken == null) {
                    throw new Exception("Phiên làm việc hết hạn. Vui lòng thử lại.");
                }

                if (newPassword == null || newPassword.length() < 8) {
                    throw new Exception("Mật khẩu phải có ít nhất 8 ký tự.");
                }

                if (!newPassword.equals(confirmPassword)) {
                    throw new Exception("Mật khẩu xác nhận không khớp.");
                }

                userService.resetPassword(resetToken, newPassword);
                
                // Clear session attributes
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetToken");
                
                req.setAttribute("successMessage", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay bây giờ.");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            // Keep the current step if error occurs
            if ("sendOtp".equals(action)) {
                req.setAttribute("step", "sendOtp");
            } else if ("verifyOtp".equals(action)) {
                req.setAttribute("step", "verifyOtp");
            } else if ("resetPassword".equals(action)) {
                req.setAttribute("step", "resetPassword");
            }
        }

        req.getRequestDispatcher("/jsp/forgot-password.jsp").forward(req, resp);
    }
}

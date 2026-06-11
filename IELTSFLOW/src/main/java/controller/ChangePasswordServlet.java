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

/**
 * Servlet xử lý chức năng Đổi mật khẩu trong trang tài khoản.
 * URL: /change-password
 * - GET  → Forward tới change-password.jsp
 * - POST → Xử lý đổi mật khẩu, redirect về account
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Set encoding UTF-8 (Thêm vào để đảm bảo request không bị lỗi font từ form gửi lên)
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate
        if (currentPassword == null || currentPassword.isBlank()
                || newPassword == null || newPassword.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường");
            req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.changePassword(userId, currentPassword, newPassword);
            // Đổi mật khẩu thành công → redirect về account với thông báo
            resp.sendRedirect(req.getContextPath() + "/account?success=Đổi+mật+khẩu+thành+công");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
        }
    }
}
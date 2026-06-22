package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

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
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin tài khoản: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
        } catch (Exception e) {
            // Ignored
        }

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
            resp.sendRedirect(req.getContextPath() + "/change-password?success=" + java.net.URLEncoder.encode("Cập nhật mật khẩu thành công", "UTF-8"));
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/change-password.jsp").forward(req, resp);
        }
    }
}

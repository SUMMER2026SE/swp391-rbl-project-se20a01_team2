package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verify-email"})
public class VerifyEmailServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/auth?redirect_error=" + java.net.URLEncoder.encode("Link xác thực không hợp lệ.", "UTF-8"));
            return;
        }

        try {
            userService.verifyEmail(token);
            String successMsg = java.net.URLEncoder.encode("Xác thực email thành công! Bây giờ bạn đã có thể đăng nhập.", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/auth?successMessage=" + successMsg);
        } catch (Exception e) {
            String errorMsg = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/auth?redirect_error=" + errorMsg + "&tab=login");
        }
    }
}

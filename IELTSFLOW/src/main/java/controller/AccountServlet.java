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

/**
 * Servlet quản lý trang tài khoản cá nhân (Account Management).
 * URL: /account
 * - GET  → Load thông tin user từ DB, forward tới account.jsp
 * - POST → Cập nhật hồ sơ (fullName) và cập nhật session
 */
@WebServlet(name = "AccountServlet", urlPatterns = {"/account"})
public class AccountServlet extends HttpServlet {

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

        int userId = (int) session.getAttribute("userId");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
            
            services.SubscriptionService subscriptionService = new services.SubscriptionService();
            model.UserSubscription activeSubscription = subscriptionService.getActiveSubscriptionByUserId(userId);
            req.setAttribute("activeSubscription", activeSubscription);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin tài khoản: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = req.getParameter("fullName");
            String profilePic = req.getParameter("profilePic");

            if (fullName == null || fullName.trim().isEmpty()) {
                req.setAttribute("error", "Họ và tên không được để trống");
                doGet(req, resp);
                return;
            }

            try {
                // Cập nhật fullName và profilePic trong DB thông qua UserService
                userService.updateProfile(userId, fullName.trim(), profilePic);

                // Cập nhật lại session
                session.setAttribute("fullName", fullName.trim());
                if (profilePic != null && !profilePic.isBlank()) {
                    session.setAttribute("profilePic", profilePic.trim());
                }

                resp.sendRedirect(req.getContextPath() + "/account?success=" + java.net.URLEncoder.encode("Cập nhật hồ sơ thành công", "UTF-8"));
            } catch (Exception e) {
                req.setAttribute("error", "Cập nhật thất bại: " + e.getMessage());
                doGet(req, resp);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/account");
        }
    }
}

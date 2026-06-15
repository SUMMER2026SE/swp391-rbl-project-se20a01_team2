package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserSubscription;
import services.SubscriptionService;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

@WebServlet(name = "UserSubscriptionServlet", urlPatterns = {"/my-subscription"})
public class UserSubscriptionServlet extends HttpServlet {

    private UserService userService;
    private SubscriptionService subscriptionService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        subscriptionService = new SubscriptionService();
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

            UserSubscription activeSubscription = subscriptionService.getActiveSubscriptionByUserId(userId);
            req.setAttribute("activeSubscription", activeSubscription);

        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin gói đăng ký: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/my-subscription.jsp").forward(req, resp);
    }
}

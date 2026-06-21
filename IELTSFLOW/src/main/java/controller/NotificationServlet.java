package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import services.NotificationService;

import java.io.IOException;
import java.util.List;

import model.User;
import services.UserService;
import services.UserServiceImpl;

/**
 * Servlet quản lý thông báo của người dùng.
 * URL: /notifications
 * - GET                    → Hiển thị danh sách thông báo
 * - POST action=markRead    → Đánh dấu một thông báo đã đọc
 * - POST action=markAllRead → Đánh dấu tất cả đã đọc
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/candidate/notifications"})
public class NotificationServlet extends HttpServlet {

    private NotificationService notificationService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
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
            
            List<Notification> notifications = notificationService.getNotifications(userId);
            long unreadCount = notificationService.countUnread(userId);
            req.setAttribute("notifications", notifications);
            req.setAttribute("unreadCount", unreadCount);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông báo: " + e.getMessage());
        }
        
        req.getRequestDispatcher("/jsp/candidate/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            
        // Thiết lập bộ mã UTF-8 cho Request nhận dữ liệu từ Client
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        
        try {
            if ("markRead".equals(action)) {
                int notifId = Integer.parseInt(req.getParameter("notificationId"));
                notificationService.markAsRead(notifId, userId);
            } else if ("markAllRead".equals(action)) {
                notificationService.markAllAsRead(userId);
            }
        } catch (Exception e) {
            // Có thể bổ sung log lỗi hoặc đẩy thông báo lỗi vào session nếu cần
        }
        
        resp.sendRedirect(req.getContextPath() + "/candidate/notifications");
    }
}

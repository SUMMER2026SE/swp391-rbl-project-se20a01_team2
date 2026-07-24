package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.NotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * API để xử lý thông báo (Notification) thông qua AJAX.
 * Endpoint: /api/notifications/unread
 */
@WebServlet(name = "NotificationApiServlet", urlPatterns = {"/api/notifications/unread"})
public class NotificationApiServlet extends HttpServlet {

    private NotificationService notificationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession(false);
        PrintWriter out = resp.getWriter();
        Map<String, Object> responseData = new HashMap<>();

        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            responseData.put("error", "Unauthorized");
            out.print(gson.toJson(responseData));
            out.flush();
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            long unreadCount = notificationService.countUnread(userId);
            
            responseData.put("unreadCount", unreadCount);
            responseData.put("success", true);
            out.print(gson.toJson(responseData));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("error", e.getMessage());
            responseData.put("success", false);
            out.print(gson.toJson(responseData));
        } finally {
            out.flush();
        }
    }
}

package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.UserService;
import services.UserServiceImpl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * REST API cho các tác vụ của User (vd: đổi mật khẩu).
 * URL: /api/user/*
 */
@WebServlet(name = "UserApiServlet", urlPatterns = {"/api/user/change-password"})
public class UserApiServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(401);
            out.print("{\"error\":\"Unauthenticated\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            // Đọc payload JSON
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            if (sb.toString().isEmpty()) {
                resp.setStatus(400);
                out.print("{\"error\":\"Empty payload\"}");
                return;
            }

            JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();
            String currentPassword = json.has("currentPassword") ? json.get("currentPassword").getAsString() : "";
            String newPassword = json.has("newPassword") ? json.get("newPassword").getAsString() : "";

            if (currentPassword.isEmpty() || newPassword.isEmpty()) {
                resp.setStatus(400);
                out.print("{\"error\":\"Vui lòng nhập đầy đủ mật khẩu hiện tại và mật khẩu mới.\"}");
                return;
            }

            // UserService.changePassword() đã xử lý hash (PasswordUtil.hashPassword)
            userService.changePassword(userId, currentPassword, newPassword);

            out.print("{\"success\":true}");

        } catch (Exception e) {
            resp.setStatus(400);
            out.print("{\"error\":\"" + e.getMessage().replace("\"", "'") + "\", \"message\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}

package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * API lấy thông tin User đang đăng nhập từ Session.
 * Frontend gọi GET /api/user/me để lấy thông tin thật (tên, email, roleId).
 * Trả về 401 nếu chưa đăng nhập.
 */
@WebServlet("/api/user/me")
public class UserMeServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        // Cho phép JS của cùng origin gọi
        resp.setHeader("Cache-Control", "no-store");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "Chưa đăng nhập");
            mapper.writeValue(resp.getOutputStream(), err);
            return;
        }

        // Lấy thông tin từ session
        Map<String, Object> userData = new HashMap<>();
        userData.put("userId",   session.getAttribute("userId"));
        userData.put("email",    session.getAttribute("userEmail"));
        userData.put("fullName", session.getAttribute("fullName"));
        userData.put("roleId",   session.getAttribute("roleId"));

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data",    userData);
        mapper.writeValue(resp.getOutputStream(), result);
    }
}

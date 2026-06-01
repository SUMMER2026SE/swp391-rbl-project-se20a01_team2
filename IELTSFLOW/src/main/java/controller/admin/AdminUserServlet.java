package controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Admin API – Quản lý người dùng.
 *
 * GET  /api/admin/users          → Danh sách tất cả user + thống kê
 * POST /api/admin/users/ban      → Khóa tài khoản { userId, action: "ban"|"unban" }
 */
@WebServlet("/api/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        // Kiểm tra quyền Admin (filter đã kiểm tra, đây là double-check)
        Object roleIdObj = req.getSession(false) != null
                ? req.getSession(false).getAttribute("roleId") : null;
        if (roleIdObj == null || (int) roleIdObj != 1) {
            resp.setStatus(403);
            mapper.writeValue(resp.getOutputStream(), Map.of("success", false, "message", "Không có quyền"));
            return;
        }

        try {
            List<Map<String, Object>> users = userDAO.findAllForAdmin();
            Map<String, Object> stats = userDAO.getStats();

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("users", users);
            result.put("stats", stats);
            mapper.writeValue(resp.getOutputStream(), result);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            mapper.writeValue(resp.getOutputStream(),
                    Map.of("success", false, "message", "Lỗi server: " + e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        Object roleIdObj = req.getSession(false) != null
                ? req.getSession(false).getAttribute("roleId") : null;
        if (roleIdObj == null || (int) roleIdObj != 1) {
            resp.setStatus(403);
            mapper.writeValue(resp.getOutputStream(), Map.of("success", false, "message", "Không có quyền"));
            return;
        }

        try {
            Map<String, Object> body = mapper.readValue(req.getInputStream(), Map.class);
            int targetUserId = (int) body.get("userId");
            String action    = (String) body.get("action"); // "ban" hoặc "unban"

            String newStatus = "ban".equals(action) ? "Banned" : "Active";
            boolean ok = userDAO.updateStatus(targetUserId, newStatus);

            if (ok) {
                mapper.writeValue(resp.getOutputStream(),
                        Map.of("success", true, "message",
                                "ban".equals(action) ? "Đã khóa tài khoản" : "Đã mở khóa tài khoản"));
            } else {
                resp.setStatus(500);
                mapper.writeValue(resp.getOutputStream(),
                        Map.of("success", false, "message", "Cập nhật thất bại"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            mapper.writeValue(resp.getOutputStream(),
                    Map.of("success", false, "message", "Lỗi: " + e.getMessage()));
        }
    }
}

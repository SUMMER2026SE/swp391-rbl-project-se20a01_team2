package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import services.UserService;

import java.io.IOException;
import java.util.Map;

/**
 * UserManagementController - xử lý các chức năng:
 *   #48 Thêm/sửa/khóa tài khoản : GET/POST/PUT/DELETE /api/admin/users
 *   #49 Phân quyền Mentor        : PUT /api/admin/users/{id}/role
 *
 * Lưu ý: việc kiểm tra quyền Admin sẽ được xử lý bởi AuthFilter (của thành viên khác).
 */
@WebServlet("/api/admin/users/*")
public class UserManagementController extends HttpServlet {

    private final UserService userService = new UserService();
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // #48 Lấy danh sách tất cả user
                mapper.writeValue(resp.getWriter(), userService.getAllUsers());
            } else {
                String[] parts = pathInfo.substring(1).split("/");
                int id = Integer.parseInt(parts[0]);

                if (parts.length > 1 && "mentors".equals(parts[1])) {
                    // #49 Lấy danh sách Mentor
                    mapper.writeValue(resp.getWriter(), userService.getMentors());
                } else {
                    // #48 Lấy chi tiết 1 user
                    User user = userService.getUserById(id);
                    if (user == null) {
                        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        resp.getWriter().write("{\"error\":\"User not found\"}");
                        return;
                    }
                    mapper.writeValue(resp.getWriter(), user);
                }
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid ID format\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // #48 Thêm user mới
        resp.setContentType("application/json;charset=UTF-8");
        try {
            User user = mapper.readValue(req.getReader(), User.class);
            userService.createUser(user);
            resp.setStatus(HttpServletResponse.SC_CREATED);
            // Không trả về passwordHash
            user.setPasswordHash(null);
            mapper.writeValue(resp.getWriter(), user);
        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_CONFLICT);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"ID is required\"}");
                return;
            }

            String[] parts = pathInfo.substring(1).split("/");
            int id = Integer.parseInt(parts[0]);

            if (parts.length > 1 && "role".equals(parts[1])) {
                // #49 Phân quyền Mentor: PUT /api/admin/users/{id}/role
                // Body: { "action": "assign" } hoặc { "action": "revoke" }
                @SuppressWarnings("unchecked")
                Map<String, String> body = mapper.readValue(req.getReader(), Map.class);
                String action = body.getOrDefault("action", "assign");
                if ("revoke".equals(action)) {
                    userService.revokeMentorRole(id);
                    resp.getWriter().write("{\"message\":\"Đã thu hồi quyền Mentor\"}");
                } else {
                    userService.assignMentorRole(id);
                    resp.getWriter().write("{\"message\":\"Đã phân quyền Mentor thành công\"}");
                }

            } else if (parts.length > 1 && "lock".equals(parts[1])) {
                // #48 Khóa tài khoản: PUT /api/admin/users/{id}/lock
                userService.lockUser(id);
                resp.getWriter().write("{\"message\":\"Tài khoản đã bị khóa\"}");

            } else {
                // #48 Cập nhật thông tin user: PUT /api/admin/users/{id}
                // Chỉ cho phép sửa fullName, email, status — không cho sửa role/password
                @SuppressWarnings("unchecked")
                Map<String, String> body = mapper.readValue(req.getReader(), Map.class);
                userService.updateUser(
                        id,
                        body.get("fullName"),
                        body.get("email"),
                        body.get("status")
                );
                resp.getWriter().write("{\"message\":\"Cập nhật thành công\"}");
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid ID format\"}");
        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // #48 Xóa user
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            userService.deleteUser(Integer.parseInt(pathInfo.substring(1)));
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}

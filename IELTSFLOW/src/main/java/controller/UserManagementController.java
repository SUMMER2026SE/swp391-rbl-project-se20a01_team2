package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import services.UserService;
import services.UserServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * UserManagementController - SSR refactored:
 *   GET /admin/users          : Lấy danh sách user và forward to JSP
 *   GET /admin/users/mentors  : Lấy danh sách mentor và forward to JSP
 *   POST /admin/users         : Xử lý Add/Edit/Delete/Lock qua form parameter (action)
 */
@WebServlet({"/admin/users/*", "/api/admin/users/ban"})
public class UserManagementController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.equals("/mentors")) {
                List<User> mentors = userService.getMentors();
                req.setAttribute("users", mentors);
                req.setAttribute("isMentorView", true);
                req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
            } else {
                List<User> users = userService.getAllUsers();
                req.setAttribute("users", users);
                req.setAttribute("isMentorView", false);
                req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/api/admin/users/ban".equals(servletPath)) {
            resp.setContentType("application/json;charset=UTF-8");
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                java.util.Map<String, Object> body = mapper.readValue(req.getInputStream(), java.util.Map.class);
                int targetUserId = (int) body.get("userId");
                String actionApi = (String) body.get("action"); // "ban" hoặc "unban"
                String newStatus = "ban".equals(actionApi) ? "Banned" : "Active";
                
                userService.updateUserStatus(targetUserId, newStatus);
                
                mapper.writeValue(resp.getOutputStream(),
                        java.util.Map.of("success", true, "message",
                                "ban".equals(actionApi) ? "Đã khóa tài khoản" : "Đã mở khóa tài khoản"));
            } catch (Exception e) {
                e.printStackTrace();
                resp.setStatus(500);
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                mapper.writeValue(resp.getOutputStream(),
                        java.util.Map.of("success", false, "message", "Lỗi: " + e.getMessage()));
            }
            return;
        }

        String action = req.getParameter("action");
        String pathInfo = req.getPathInfo();
        
        try {
            if ("create".equals(action)) {
                User user = new User();
                user.setFullName(req.getParameter("fullName"));
                user.setEmail(req.getParameter("email"));
                user.setRoleId(Integer.parseInt(req.getParameter("roleId")));
                user.setStatus(req.getParameter("status"));
                userService.createUser(user);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.updateUser(
                        id,
                        req.getParameter("fullName"),
                        req.getParameter("email"),
                        req.getParameter("status")
                );
            } else if ("lock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.updateUserStatus(id, "Inactive");
            } else if ("unlock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.updateUserStatus(id, "Active");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.deleteUser(id);
            } else if ("assign_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.assignMentorRole(id);
            } else if ("revoke_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.revokeMentorRole(id);
            }
            
            // Redirect based on the current view to avoid form resubmission
            if (pathInfo != null && pathInfo.equals("/mentors")) {
                resp.sendRedirect(req.getContextPath() + "/admin/users/mentors");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
            
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}

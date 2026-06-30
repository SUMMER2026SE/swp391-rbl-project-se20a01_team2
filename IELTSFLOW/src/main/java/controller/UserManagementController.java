package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import services.UserService;
import services.UserServiceImpl;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet({"/admin/users/*", "/api/admin/users/ban"})
public class UserManagementController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("export".equals(action)) {
            exportCsv(req, resp);
            return;
        }

        try {
            int page = 1;
            int limit = 10;
            if (req.getParameter("page") != null) {
                try { page = Integer.parseInt(req.getParameter("page")); } catch(Exception ignored) {}
            }
            if (req.getParameter("limit") != null) {
                try { limit = Integer.parseInt(req.getParameter("limit")); } catch(Exception ignored) {}
            }
            
            String search = req.getParameter("search");
            String roleFilter = req.getParameter("roleFilter");
            String statusFilter = req.getParameter("statusFilter");
            String sortBy = req.getParameter("sortBy");
            String sortOrder = req.getParameter("sortOrder");
            
            List<User> users = userService.findUsers(page, limit, search, roleFilter, statusFilter, sortBy, sortOrder);
            long totalUsers = userService.countUsers(search, roleFilter, statusFilter);
            int totalPages = (int) Math.ceil((double) totalUsers / limit);
            if (totalPages == 0) totalPages = 1;
            
            req.setAttribute("users", users);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("limit", limit);
            req.setAttribute("search", search);
            req.setAttribute("roleFilter", roleFilter);
            req.setAttribute("statusFilter", statusFilter);
            req.setAttribute("sortBy", sortBy);
            req.setAttribute("sortOrder", sortOrder);
            
            req.setAttribute("isMentorView", false);
            req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
        }
    }

    private void exportCsv(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"users_export.csv\"");
        java.io.PrintWriter writer = resp.getWriter();
        writer.write('\uFEFF'); // BOM
        writer.println("ID,Họ và tên,Email,Trạng thái,Vai trò,Ngày tạo");
        
        List<User> users = userService.getAllUsers();
        for (User u : users) {
            String roleStr = (u.getRoleId() == 1) ? "Admin" : ((u.getRoleId() == 2) ? "Mentor" : "Candidate");
            String dateStr = u.getCreatedAt() != null ? u.getCreatedAt().toString() : "";
            writer.println(String.format("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"", 
                u.getUserId(), u.getFullName().replace("\"", "\"\""), u.getEmail(), u.getStatus(), roleStr, dateStr));
        }
        writer.flush();
        writer.close();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        
        User loggedInAdmin = (User) req.getSession().getAttribute("user");
        int adminId = (loggedInAdmin != null) ? loggedInAdmin.getUserId() : 1;
        
        if ("/api/admin/users/ban".equals(servletPath)) {
            resp.setContentType("application/json;charset=UTF-8");
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                java.util.Map<String, Object> body = mapper.readValue(req.getInputStream(), java.util.Map.class);
                int targetUserId = (int) body.get("userId");
                String actionApi = (String) body.get("action"); // "ban" hoặc "unban"
                String newStatus = "ban".equals(actionApi) ? "Banned" : "Active";
                
                userService.adminUpdateUserStatus(adminId, targetUserId, newStatus);
                
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
                int roleId = Integer.parseInt(req.getParameter("roleId"));
                userService.updateUser(
                        id,
                        req.getParameter("fullName"),
                        req.getParameter("email"),
                        req.getParameter("status"),
                        roleId
                );
            } else if ("lock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.adminUpdateUserStatus(adminId, id, "Inactive");
            } else if ("unlock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.adminUpdateUserStatus(adminId, id, "Active");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.adminDeleteUser(adminId, id);
            } else if ("change_password".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String newPassword = req.getParameter("newPassword");
                userService.adminChangePassword(adminId, id, newPassword);
            } else if ("bulk_action".equals(action)) {
                String actionType = req.getParameter("actionType");
                String[] userIdsStr = req.getParameterValues("userIds");
                if (userIdsStr != null && userIdsStr.length > 0) {
                    List<Integer> userIds = new ArrayList<>();
                    for (String s : userIdsStr) userIds.add(Integer.parseInt(s));
                    userService.bulkAction(adminId, actionType, userIds);
                }
            } else if ("assign_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.assignMentorRole(id);
            } else if ("revoke_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                userService.revokeMentorRole(id);
            }
            
            // Generate query string for pagination state retention (from referrer or just redirect back)
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}

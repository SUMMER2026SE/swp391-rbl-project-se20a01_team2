package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import services.UserService;
import services.UserServiceImpl;
import dao.SystemLogDAO;
import model.SystemLog;
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
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userService.getAllUsers();
            req.setAttribute("users", users);
            req.setAttribute("isMentorView", false);
            req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        User adminUser = (User) req.getSession().getAttribute("user");
        Integer adminId = adminUser != null ? adminUser.getUserId() : null;

        if ("/api/admin/users/ban".equals(servletPath)) {
            resp.setContentType("application/json;charset=UTF-8");
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                java.util.Map<String, Object> body = mapper.readValue(req.getInputStream(), java.util.Map.class);
                int targetUserId = (int) body.get("userId");
                String actionApi = (String) body.get("action"); // "ban" hoặc "unban"
                String newStatus = "ban".equals(actionApi) ? "Banned" : "Active";
                
                User oldUser = userService.getUserById(targetUserId);
                userService.updateUserStatus(targetUserId, newStatus);
                
                String actionName = "ban".equals(actionApi) ? "LOCK" : "UNLOCK";
                String detail = "Thay đổi: status từ '" + oldUser.getStatus() + "' sang '" + newStatus + "'";
                systemLogDAO.createSystemLog(new SystemLog(adminId, actionName, "User", detail));
                
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
                systemLogDAO.createSystemLog(new SystemLog(adminId, "CREATE", "User", "Tạo tài khoản mới: " + user.getEmail()));
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String newFullName = req.getParameter("fullName");
                String newEmail = req.getParameter("email");
                String newStatus = req.getParameter("status");
                int newRoleId = Integer.parseInt(req.getParameter("roleId"));
                
                User oldUser = userService.getUserById(id);
                userService.updateUser(id, newFullName, newEmail, newStatus, newRoleId);
                
                StringBuilder details = new StringBuilder("Thay đổi: ");
                String oldFullName = oldUser.getFullName() != null ? oldUser.getFullName() : "";
                if (!oldFullName.equals(newFullName)) details.append("fullName từ '").append(oldFullName).append("' sang '").append(newFullName).append("', ");
                
                String oldEmail = oldUser.getEmail() != null ? oldUser.getEmail() : "";
                if (!oldEmail.equals(newEmail)) details.append("email từ '").append(oldEmail).append("' sang '").append(newEmail).append("', ");
                
                String oldStatus = oldUser.getStatus() != null ? oldUser.getStatus() : "";
                if (!oldStatus.equals(newStatus)) details.append("status từ '").append(oldStatus).append("' sang '").append(newStatus).append("', ");
                
                if (oldUser.getRoleId() != newRoleId) details.append("roleId từ '").append(oldUser.getRoleId()).append("' sang '").append(newRoleId).append("', ");
                
                if (details.length() > 10) {
                    details.setLength(details.length() - 2); // Xoá dấu phẩy cuối
                    systemLogDAO.createSystemLog(new SystemLog(adminId, "UPDATE", "User", details.toString()));
                }
            } else if ("lock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                User oldUser = userService.getUserById(id);
                userService.updateUserStatus(id, "Inactive");
                systemLogDAO.createSystemLog(new SystemLog(adminId, "LOCK", "User", "Thay đổi: status từ '" + oldUser.getStatus() + "' sang 'Inactive'"));
            } else if ("unlock".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                User oldUser = userService.getUserById(id);
                userService.updateUserStatus(id, "Active");
                systemLogDAO.createSystemLog(new SystemLog(adminId, "UNLOCK", "User", "Thay đổi: status từ '" + oldUser.getStatus() + "' sang 'Active'"));
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                User oldUser = userService.getUserById(id);
                userService.deleteUser(id);
                systemLogDAO.createSystemLog(new SystemLog(adminId, "DELETE", "User", "Xóa tài khoản: " + oldUser.getEmail()));
            } else if ("assign_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                User oldUser = userService.getUserById(id);
                userService.assignMentorRole(id);
                systemLogDAO.createSystemLog(new SystemLog(adminId, "ASSIGN_MENTOR", "User", "Thay đổi: roleId từ '" + oldUser.getRoleId() + "' sang '" + UserServiceImpl.ROLE_MENTOR + "'"));
            } else if ("revoke_mentor".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                User oldUser = userService.getUserById(id);
                userService.revokeMentorRole(id);
                systemLogDAO.createSystemLog(new SystemLog(adminId, "REVOKE_MENTOR", "User", "Thay đổi: roleId từ '" + oldUser.getRoleId() + "' sang '" + UserServiceImpl.ROLE_CANDIDATE + "'"));
            }
            
            // Redirect to avoid form resubmission
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}

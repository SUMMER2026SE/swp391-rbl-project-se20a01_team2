package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import services.UserService;

import java.io.IOException;
import java.util.List;

/**
 * UserManagementController - SSR refactored:
 *   GET /admin/users          : Lấy danh sách user và forward to JSP
 *   GET /admin/users/mentors  : Lấy danh sách mentor và forward to JSP
 *   POST /admin/users         : Xử lý Add/Edit/Delete/Lock qua form parameter (action)
 */
@WebServlet("/admin/users/*")
public class UserManagementController extends HttpServlet {

    private final UserService userService = new UserService();

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
                userService.lockUser(id);
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

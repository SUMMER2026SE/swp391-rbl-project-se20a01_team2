package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        String redirect = req.getParameter("redirect");

        // Nếu đã đăng nhập, chuyển hướng luôn
        if (session != null && session.getAttribute("userId") != null) {
            int roleId = session.getAttribute("roleId") != null ? (int) session.getAttribute("roleId") : 0;
            if (roleId == 1) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            } else if (roleId == 2) {
                resp.sendRedirect(req.getContextPath() + "/mentor/dashboard");
                return;
            } else {
                if (redirect != null && !redirect.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/candidate/" + redirect.trim());
                } else {
                    resp.sendRedirect(req.getContextPath() + "/candidate/dashboard");
                }
                return;
            }
        }

        // Lưu redirect target vào session nếu có (cho người dùng chưa đăng nhập)
        if (redirect != null && !redirect.trim().isEmpty()) {
            req.getSession(true).setAttribute("redirectAfterLogin", redirect.trim());
        }
        req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("login".equals(action)) {
            // Forward internally to LoginServlet
            req.getRequestDispatcher("/login").forward(req, resp);
        } else if ("register".equals(action)) {
            // Forward internally to RegisterServlet
            req.getRequestDispatcher("/register").forward(req, resp);
        } else {
            // Default fallback
            resp.sendRedirect(req.getContextPath() + "/auth");
        }
    }
}

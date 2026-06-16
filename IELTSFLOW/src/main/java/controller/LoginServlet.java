package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtil;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "LoginServlet", urlPatterns = {"/api/auth/login", "/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }

        try {
            Optional<User> userOpt = userDAO.findByEmail(email);

            if (!userOpt.isPresent()) {
                req.setAttribute("error", "Tài khoản không tồn tại");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }

            User user = userOpt.get();

            if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                req.setAttribute("error", "Sai mật khẩu");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }

            if ("Banned".equals(user.getStatus())) {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }
            if ("Inactive".equals(user.getStatus())) {
                req.setAttribute("error", "Tài khoản chưa được xác thực. Vui lòng kiểm tra email (kể cả mục Spam) để kích hoạt.");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }

            // Dang nhap thanh cong, luu session
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("roleId", user.getRoleId());

            if (user.getRoleId() == 1 || user.getRoleId() == 2) { // Admin or Mentor
                resp.sendRedirect(req.getContextPath() + "/jsp/admin/dashboard.jsp");
            } else { // Candidate
                resp.sendRedirect(req.getContextPath() + "/candidate/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
        }
    }
}
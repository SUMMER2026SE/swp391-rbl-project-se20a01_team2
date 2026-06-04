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
import java.util.regex.Pattern;

/**
 * Servlet xu ly dang ky tai khoan (SSR - khong JSON API).
 * URL: /register
 * POST → Xu ly dang ky, chuyen trang hoan toan (Server-Side Rendering)
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate
        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập họ và tên");
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }
        if (email == null || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            req.setAttribute("error", "Email không hợp lệ");
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }
        if (password == null || !PasswordUtil.isPasswordStrong(password)) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số");
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }
        if (confirmPassword != null && !password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.emailExists(email.trim())) {
                req.setAttribute("error", "Email này đã được đăng ký. Vui lòng đăng nhập.");
                req.setAttribute("tab", "register");
                req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
                return;
            }

            String passwordHash = PasswordUtil.hashPassword(password);
            int roleId = userDAO.getCandidateRoleId();

            User newUser = new User(roleId, email.trim(), passwordHash, fullName.trim());
            newUser.setStatus("Active");
            newUser.setAuthProvider("Local");

            int userId = userDAO.create(newUser);

            // Tao session va dang nhap luon sau khi dang ky
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", userId);
            session.setAttribute("userEmail", email.trim());
            session.setAttribute("fullName", fullName.trim());
            session.setAttribute("roleId", roleId);

            resp.sendRedirect(req.getContextPath() + "/account?success=Dang+ky+thanh+cong%21+Chao+mung+ban+den+voi+IELTS+Flow");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
        }
    }
}

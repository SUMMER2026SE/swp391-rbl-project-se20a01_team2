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
            services.UserService userService = new services.UserServiceImpl();
            
            // Xây dựng baseUrl động, hỗ trợ Nginx reverse proxy
            String scheme = req.getHeader("X-Forwarded-Proto");
            if (scheme == null) {
                scheme = req.getScheme();
            }
            String host = req.getHeader("X-Forwarded-Host");
            if (host == null) {
                host = req.getServerName() + ":" + req.getServerPort();
            }
            String baseUrl = scheme + "://" + host + req.getContextPath();

            // Gọi service layer để xử lý logic đăng ký và gửi email
            userService.registerUser(fullName.trim(), email.trim(), password, baseUrl);

            req.setAttribute("successMessage", "Đăng ký thành công! Vui lòng kiểm tra hộp thư email (kể cả mục Spam) để kích hoạt tài khoản.");
            req.setAttribute("tab", "login");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.setAttribute("tab", "register");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
        }
    }
}

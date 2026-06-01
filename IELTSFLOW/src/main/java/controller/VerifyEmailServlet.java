package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import services.OtpService;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet xử lý khi người dùng nhấn vào link xác thực trong email
 */
@WebServlet("/api/auth/verify-email")
public class VerifyEmailServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.html?error=invalid-token");
            return;
        }

        String email = OtpService.getInstance().consumeVerifyToken(token);

        if (email != null) {
            Optional<User> userOpt = userDAO.findByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                if ("Inactive".equalsIgnoreCase(user.getStatus())) {
                    userDAO.updateStatus(user.getUserId(), "Active");
                    resp.sendRedirect(req.getContextPath() + "/pages/login.html?verified=true");
                    return;
                }
            }
        }

        // Token sai, hết hạn, hoặc user đã active rồi
        resp.sendRedirect(req.getContextPath() + "/pages/login.html?error=invalid-token");
    }
}

package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import services.OtpService;
import util.PasswordUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Servlet xử lý đổi mật khẩu (Reset Password sau khi nhập OTP)
 */
@WebServlet("/api/auth/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        setCorsHeaders(resp);

        try {
            Map<String, String> body = mapper.readValue(req.getInputStream(), Map.class);
            String email = body.get("email");
            String resetToken = body.get("resetToken");
            String newPassword = body.get("newPassword");

            if (email == null || resetToken == null || newPassword == null) {
                sendError(resp, 400, "Dữ liệu không hợp lệ");
                return;
            }

            if (!PasswordUtil.isPasswordStrong(newPassword)) {
                sendError(resp, 400, "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số");
                return;
            }

            // Kiểm tra token
            boolean isValid = OtpService.getInstance().consumeResetToken(email, resetToken);
            if (!isValid) {
                sendError(resp, 400, "Yêu cầu đổi mật khẩu đã hết hạn hoặc không hợp lệ. Vui lòng thử lại từ đầu.");
                return;
            }

            Optional<User> userOpt = userDAO.findByEmail(email);
            if (userOpt.isPresent()) {
                String hash = PasswordUtil.hashPassword(newPassword);
                userDAO.updatePassword(userOpt.get().getUserId(), hash);
                sendSuccess(resp, "Mật khẩu đã được đặt lại thành công!");
            } else {
                sendError(resp, 404, "Không tìm thấy người dùng");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setCorsHeaders(resp);
        resp.setStatus(HttpServletResponse.SC_OK);
    }

    private void setCorsHeaders(HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }

    private void sendSuccess(HttpServletResponse resp, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);
        mapper.writeValue(resp.getOutputStream(), result);
    }

    private void sendError(HttpServletResponse resp, int statusCode, String message) throws IOException {
        resp.setStatus(statusCode);
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        mapper.writeValue(resp.getOutputStream(), result);
    }
}

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
import util.ResendUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Servlet xử lý đăng ký tài khoản
 */
@WebServlet("/api/auth/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        setCorsHeaders(resp);

        try {
            Map<String, String> body = mapper.readValue(req.getInputStream(), Map.class);
            String fullName = body.get("fullName");
            String email = body.get("email");
            String password = body.get("password");

            // Validate dữ liệu
            if (fullName == null || fullName.trim().isEmpty()) {
                sendError(resp, 400, "Vui lòng nhập họ tên");
                return;
            }
            if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
                sendError(resp, 400, "Email không hợp lệ");
                return;
            }
            if (!PasswordUtil.isPasswordStrong(password)) {
                sendError(resp, 400, "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số");
                return;
            }

            // Kiểm tra trùng email
            if (userDAO.emailExists(email)) {
                sendError(resp, 409, "Email này đã được đăng ký");
                return;
            }

            // Tạo hash mật khẩu
            String passwordHash = PasswordUtil.hashPassword(password);
            int roleId = userDAO.getCandidateRoleId();

            // Tạo đối tượng User mới (status mặc định là Inactive)
            User newUser = new User(roleId, email, passwordHash, fullName);
            
            // Lưu vào DB
            int userId = userDAO.create(newUser);
            newUser.setUserId(userId);

            // Gửi email xác thực
            String verifyToken = OtpService.getInstance().generateVerifyToken(email);
            
            // Cấu hình URL đầy đủ tùy vào domain thật hoặc localhost
            String verifyUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() 
                    + req.getContextPath() + "/api/auth/verify-email?token=" + verifyToken;
            
            String from = "IELTS Flow <onboarding@resend.dev>";
            String domain = System.getProperty("RESEND_SEND_DOMAIN");
            if (domain != null && !domain.isEmpty() && !domain.equals("your_email_domain_here")) {
                from = "IELTS Flow <noreply@" + domain + ">";
            }
            
            String htmlBody = "<h3>Chào mừng đến với IELTS Flow!</h3>"
                    + "<p>Vui lòng nhấn vào link bên dưới để xác thực tài khoản của bạn:</p>"
                    + "<p><a href='" + verifyUrl + "' style='padding: 10px 20px; background-color: #3B82F6; color: white; text-decoration: none; border-radius: 5px;'>Xác thực ngay</a></p>"
                    + "<p>Link này có hiệu lực trong 24 giờ.</p>";
            
            ResendUtil.sendMail(from, email, "Xác thực tài khoản IELTS Flow", htmlBody);

            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", newUser.getUserId());
            userData.put("email", newUser.getEmail());
            userData.put("fullName", newUser.getFullName());

            resp.setStatus(HttpServletResponse.SC_CREATED);
            sendSuccess(resp, "Đăng ký thành công. Vui lòng kiểm tra email để xác thực.", userData);

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

    private void sendSuccess(HttpServletResponse resp, String message, Object data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);
        if (data != null) result.put("data", data);
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

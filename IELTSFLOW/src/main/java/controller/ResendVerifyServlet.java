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
import util.ResendUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Servlet xử lý yêu cầu gửi lại email xác thực
 */
@WebServlet("/api/auth/resend-verify")
public class ResendVerifyServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        setCorsHeaders(resp);

        try {
            Map<String, String> body = mapper.readValue(req.getInputStream(), Map.class);
            String email = body.get("email");

            if (email == null || email.trim().isEmpty()) {
                sendError(resp, 400, "Vui lòng cung cấp email");
                return;
            }

            Optional<User> userOpt = userDAO.findByEmail(email);

            if (userOpt.isPresent()) {
                User user = userOpt.get();
                // Chỉ gửi lại nếu tài khoản đang Inactive
                if ("Inactive".equalsIgnoreCase(user.getStatus())) {
                    String verifyToken = OtpService.getInstance().generateVerifyToken(email);
                    
                    String verifyUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() 
                            + req.getContextPath() + "/api/auth/verify-email?token=" + verifyToken;
                    
                    String from = "IELTS Flow <onboarding@resend.dev>";
                    String domain = System.getProperty("RESEND_SEND_DOMAIN");
                    if (domain != null && !domain.isEmpty() && !domain.equals("your_email_domain_here")) {
                        from = "IELTS Flow <noreply@" + domain + ">";
                    }

                    String htmlBody = "<h3>Chào mừng đến với IELTS Flow!</h3>"
                            + "<p>Đây là email xác thực được gửi lại. Vui lòng nhấn vào link bên dưới để xác thực tài khoản của bạn:</p>"
                            + "<p><a href='" + verifyUrl + "' style='padding: 10px 20px; background-color: #3B82F6; color: white; text-decoration: none; border-radius: 5px;'>Xác thực ngay</a></p>"
                            + "<p>Link này có hiệu lực trong 24 giờ.</p>";

                    ResendUtil.sendMail(from, email, "Xác thực tài khoản IELTS Flow (Gửi lại)", htmlBody);
                }
            }

            // Luôn trả về thành công
            sendSuccess(resp, "Nếu tài khoản của bạn chưa xác thực, chúng tôi đã gửi lại email. Vui lòng kiểm tra hộp thư.");

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

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
 * Servlet xá»­ lÃ½ yÃªu cáº§u quÃªn máº­t kháº©u (Gá»­i mÃ£ OTP qua email)
 */
@WebServlet("/api/auth/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

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
                sendError(resp, 400, "Vui lÃ²ng nháº­p email");
                return;
            }

            Optional<User> userOpt = userDAO.findByEmail(email);

            if (userOpt.isPresent()) {
                String code = OtpService.getInstance().generateOtp(email);
                
                String from = "IELTS Flow <onboarding@resend.dev>";
                String domain = System.getProperty("RESEND_SEND_DOMAIN");
                if (domain != null && !domain.isEmpty() && !domain.equals("your_email_domain_here")) {
                    from = "IELTS Flow <noreply@" + domain + ">";
                }
                
                String htmlBody = "<h3>Mã OTP đặt lại mật khẩu</h3>"
                        + "<p>Mã xác nhận của bạn là:</p>"
                        + "<h2 style='background-color: #f3f4f6; padding: 10px; display: inline-block; letter-spacing: 5px; font-size: 24px;'>" + code + "</h2>"
                        + "<p>Mã này có hiệu lực trong 5 phút. Vui lòng không chia sẻ cho bất kỳ ai.</p>";

                boolean sent = ResendUtil.sendMail(from, email, "Mã OTP đặt lại mật khẩu - IELTS Flow", htmlBody);
                if (sent) {
                    sendSuccess(resp, "Mã OTP đã được gửi đến email của bạn.");
                } else {
                    sendError(resp, 500, "Lỗi khi gửi email qua Resend. Vui lòng thử lại sau.");
                }
            } else {
                sendError(resp, 404, "Email này chưa được đăng ký trong hệ thống.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "Lá»—i há»‡ thá»‘ng: " + e.getMessage());
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

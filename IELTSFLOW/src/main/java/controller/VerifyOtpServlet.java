package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.OtpService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý kiểm tra mã OTP
 */
@WebServlet("/api/auth/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        setCorsHeaders(resp);

        try {
            Map<String, String> body = mapper.readValue(req.getInputStream(), Map.class);
            String email = body.get("email");
            String otp = body.get("otp");

            if (email == null || otp == null || otp.trim().isEmpty()) {
                sendError(resp, 400, "Vui lòng nhập mã OTP");
                return;
            }

            boolean isValid = OtpService.getInstance().validateOtp(email, otp);

            if (!isValid) {
                sendError(resp, 400, "Mã OTP không đúng hoặc đã hết hạn");
                return;
            }

            // OTP đúng, tạo reset token (hiệu lực 15 phút)
            String resetToken = OtpService.getInstance().generateResetToken(email);

            Map<String, Object> data = new HashMap<>();
            data.put("resetToken", resetToken);

            sendSuccess(resp, "Mã OTP hợp lệ", data);

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

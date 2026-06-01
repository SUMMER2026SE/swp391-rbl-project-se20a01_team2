package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Servlet xử lý đăng nhập
 */
@WebServlet("/api/auth/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        setCorsHeaders(resp);

        try {
            Map<String, String> body = mapper.readValue(req.getInputStream(), Map.class);
            String email = body.get("email");
            String password = body.get("password");

            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                sendError(resp, 400, "Vui lòng nhập đầy đủ email và mật khẩu");
                return;
            }

            Optional<User> userOpt = userDAO.findByEmail(email);

            if (userOpt.isEmpty()) {
                sendError(resp, 401, "Tài khoản hoặc mật khẩu không chính xác");
                return;
            }

            User user = userOpt.get();

            // Nếu chỉ đăng nhập bằng mạng xã hội, chưa có mật khẩu
            if (user.getPasswordHash() == null) {
                sendError(resp, 401, "Tài khoản này được đăng ký qua Google/Facebook. Vui lòng sử dụng tính năng đăng nhập tương ứng.");
                return;
            }

            if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                sendError(resp, 401, "Tài khoản hoặc mật khẩu không chính xác");
                return;
            }

            // Kiểm tra trạng thái
            if ("Banned".equalsIgnoreCase(user.getStatus())) {
                sendError(resp, 403, "Tài khoản của bạn đã bị khóa");
                return;
            }

            if ("Inactive".equalsIgnoreCase(user.getStatus())) {
                sendError(resp, 403, "Tài khoản chưa được xác thực email. Vui lòng kiểm tra hộp thư.");
                return;
            }

            // Đăng nhập thành công, tạo session (30 phút cấu hình trong web.xml)
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("roleId", user.getRoleId());

            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("roleId", user.getRoleId());

            sendSuccess(resp, "Đăng nhập thành công", userData);

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

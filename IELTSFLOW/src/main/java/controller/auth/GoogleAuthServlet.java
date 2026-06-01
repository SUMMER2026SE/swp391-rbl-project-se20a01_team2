package controller.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import dao.UserDAO;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Servlet for handling Google Sign-In via ID Token
 */
@WebServlet("/api/auth/google")
public class GoogleAuthServlet extends HttpServlet {

    private String clientId;
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() throws ServletException {
        try {
            String envPath = getServletContext().getRealPath("/WEB-INF");
            Dotenv dotenv = Dotenv.configure().directory(envPath).load();
            clientId = dotenv.get("GOOGLE_CLIENT_ID");
            if (clientId == null || clientId.trim().isEmpty()) {
                System.err.println("WARNING: GOOGLE_CLIENT_ID is not configured in .env");
            }
        } catch (Exception e) {
            System.err.println("ERROR: Could not load .env file for GoogleAuthServlet: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String idTokenString = request.getParameter("idToken");
        String accessTokenString = request.getParameter("accessToken");

        if ((idTokenString == null || idTokenString.trim().isEmpty()) && 
            (accessTokenString == null || accessTokenString.trim().isEmpty())) {
            sendError(response, 400, "Token không hợp lệ");
            return;
        }

        if (clientId == null || "YOUR_GOOGLE_CLIENT_ID_HERE".equals(clientId)) {
            sendError(response, 500, "Hệ thống chưa được cấu hình GOOGLE_CLIENT_ID. Vui lòng liên hệ Admin.");
            return;
        }

        try {
            String email = null;
            String name = null;
            String subjectId = null;
            boolean emailVerified = false;

            if (accessTokenString != null && !accessTokenString.trim().isEmpty()) {
                // Verify via Access Token calling UserInfo API
                URL url = new URL("https://www.googleapis.com/oauth2/v3/userinfo");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestProperty("Authorization", "Bearer " + accessTokenString);
                
                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                    StringBuilder jsonResponse = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) {
                        jsonResponse.append(line);
                    }
                    in.close();
                    
                    Map<String, Object> userInfo = mapper.readValue(jsonResponse.toString(), Map.class);
                    email = (String) userInfo.get("email");
                    name = (String) userInfo.get("name");
                    subjectId = (String) userInfo.get("sub");
                    Object ev = userInfo.get("email_verified");
                    emailVerified = ev != null && ev.toString().equals("true");
                } else {
                    sendError(response, 401, "Access Token không hợp lệ hoặc đã hết hạn");
                    return;
                }
            } else {
                // Verify via ID Token (fallback)
                GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                        .setAudience(Collections.singletonList(clientId))
                        .build();
                GoogleIdToken idToken = verifier.verify(idTokenString);
                if (idToken != null) {
                    Payload payload = idToken.getPayload();
                    email = payload.getEmail();
                    emailVerified = Boolean.valueOf(payload.getEmailVerified());
                    name = (String) payload.get("name");
                    subjectId = payload.getSubject();
                } else {
                    sendError(response, 401, "Xác thực Google thất bại (ID Token không hợp lệ)");
                    return;
                }
            }

            if (email != null) {
                if (!emailVerified) {
                    sendError(response, 403, "Email Google chưa được xác thực");
                    return;
                }

                UserDAO userDAO = new UserDAO();
                Optional<User> optionalUser = userDAO.findByEmail(email);
                User user;

                if (optionalUser.isPresent()) {
                    user = optionalUser.get();
                    if (!"Google".equals(user.getAuthProvider())) {
                        user.setAuthProvider("Google");
                        user.setProviderId(subjectId);
                        user.setStatus("Active");
                    }
                } else {
                    user = new User();
                    user.setEmail(email);
                    user.setFullName(name);
                    user.setAuthProvider("Google");
                    user.setProviderId(subjectId);
                    user.setPasswordHash("");
                    user.setStatus("Active");
                    user.setRoleId(userDAO.getCandidateRoleId());
                    
                    userDAO.create(user);
                }

                HttpSession session = request.getSession(true);
                // QUAN TRỌNG: Dùng đúng tên attribute giống LoginServlet
                session.setAttribute("userId",    user.getUserId());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("fullName",  user.getFullName());
                session.setAttribute("roleId",    user.getRoleId());

                Map<String, Object> userData = new HashMap<>();
                userData.put("userId",   user.getUserId());
                userData.put("email",    user.getEmail());
                userData.put("fullName", user.getFullName());
                userData.put("roleId",   user.getRoleId());
                sendSuccess(response, "Đăng nhập Google thành công", userData);
            } else {
                sendError(response, 401, "Không lấy được thông tin người dùng từ Google");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, 500, "Lỗi máy chủ khi xác thực Google: " + e.getMessage());
        }
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

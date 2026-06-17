package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.UserDAO;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collections;
import java.util.Optional;

@WebServlet(name = "GoogleAuthServlet", urlPatterns = {"/auth/google", "/api/auth/google"})
public class GoogleAuthServlet extends HttpServlet {

    private String clientId;
    private final UserDAO userDAO = new UserDAO();

    @Override
    public void init() throws ServletException {
        try {
            String envPath = getServletContext().getRealPath("/WEB-INF");
            Dotenv dotenv = Dotenv.configure().directory(envPath).load();
            clientId = dotenv.get("GOOGLE_CLIENT_ID");
        } catch (Exception e) {
            System.out.println("No .env found or loaded for GoogleAuthServlet");
        }
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String errorMsg) throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/jsp/auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tokenString = request.getParameter("idToken");
        if (tokenString == null || tokenString.trim().isEmpty()) {
            tokenString = request.getParameter("accessToken");
        }

        if (tokenString == null || tokenString.trim().isEmpty()) {
            forwardError(request, response, "Token không hợp lệ (null)");
            return;
        }

        if (clientId == null || "YOUR_GOOGLE_CLIENT_ID_HERE".equals(clientId)) {
            forwardError(request, response, "Hệ thống chưa cấu hình Google Client ID");
            return;
        }

        try {
            String email = null;
            String name = null;

            if (tokenString.split("\\.").length == 3) {
                GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                        .setAudience(Collections.singletonList(clientId))
                        .build();

                GoogleIdToken idToken = verifier.verify(tokenString);
                if (idToken != null) {
                    Payload payload = idToken.getPayload();
                    email = payload.getEmail();
                    name = (String) payload.get("name");
                }
            } else {
                URL url = new URL("https://www.googleapis.com/oauth2/v3/userinfo");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Authorization", "Bearer " + tokenString);
                
                if (conn.getResponseCode() == 200) {
                    try (InputStreamReader reader = new InputStreamReader(conn.getInputStream())) {
                        JsonObject json = JsonParser.parseReader(reader).getAsJsonObject();
                        if (json.has("email")) email = json.get("email").getAsString();
                        if (json.has("name")) name = json.get("name").getAsString();
                    }
                }
            }

            if (email != null) {
                Optional<User> userOpt = userDAO.findByEmail(email);
                User user;
                if (userOpt.isPresent()) {
                    user = userOpt.get();
                    if ("Banned".equals(user.getStatus())) {
                        forwardError(request, response, "Tài khoản của bạn đã bị khóa (Banned)");
                        return;
                    }
                    if ("Inactive".equals(user.getStatus())) {
                        forwardError(request, response, "Tài khoản của bạn hiện đang bị khóa tạm thời (Inactive)");
                        return;
                    }
                    if (user.getAuthProvider() != null && user.getAuthProvider().equals("Local")) {
                        forwardError(request, response, "Tài khoản email này đã được đăng ký thủ công. Vui lòng đăng nhập bằng mật khẩu.");
                        return;
                    }
                } else {
                    user = new User();
                    user.setEmail(email);
                    if (name == null || name.isEmpty()) name = email.split("@")[0];
                    user.setFullName(name);
                    user.setAuthProvider("Google");
                    user.setStatus("Active");
                    user.setRoleId(userDAO.getCandidateRoleId()); // Candidate
                    userDAO.create(user);
                    
                    userOpt = userDAO.findByEmail(email);
                    if (userOpt.isPresent()) user = userOpt.get();
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("roleId", user.getRoleId());
                if (user.getProfilePic() != null) {
                    session.setAttribute("profilePic", user.getProfilePic());
                }

                if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
                }
            } else {
                forwardError(request, response, "Token không hợp lệ hoặc đã hết hạn");
            }
        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "Lỗi hệ thống khi xác thực Google");
        }
    }
}
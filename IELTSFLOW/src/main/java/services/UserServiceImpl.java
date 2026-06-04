package services;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import util.ResendUtil;

import java.util.Map;
import java.util.Optional;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;
    private final OtpService otpService;

    public UserServiceImpl() {
        this.userDAO = new UserDAO();
        this.otpService = OtpService.getInstance();
    }

    @Override
    public User authenticateUser(String email, String password) throws Exception {
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new Exception("Email không tồn tại.");
        }
        User user = userOpt.get();

        if (user.getAuthProvider() != null && user.getAuthProvider().equals("Google")) {
            throw new Exception("Tài khoản này được đăng ký bằng Google. Vui lòng đăng nhập bằng Google.");
        }

        if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            throw new Exception("Mật khẩu không đúng.");
        }

        if ("Banned".equals(user.getStatus())) {
            throw new Exception("Tài khoản của bạn đã bị khóa vi phạm chính sách.");
        }
        if ("Inactive".equals(user.getStatus())) {
            throw new Exception("Tài khoản chưa được xác thực email. INACTIVE_USER");
        }

        return user;
    }

    @Override
    public User registerUser(String fullName, String email, String password) throws Exception {
        if (userDAO.emailExists(email)) {
            throw new Exception("Email đã được sử dụng!");
        }

        String hashedPassword = PasswordUtil.hashPassword(password);
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(2); // User
        user.setStatus("Active"); // Bypass email verification for local development
        user.setAuthProvider("Local");

        if (userDAO.create(user) <= 0) {
            throw new Exception("Lỗi cơ sở dữ liệu. Không thể tạo tài khoản.");
        }

        // Gi OTP xA?c thc
        String token = otpService.generateVerifyToken(email);
        String verifyLink = "http://localhost:8080/IELTSFLOW/verify-email?token=" + token;
        ResendUtil.sendMail("IELTS Flow <noreply@email.tanmanh350.ovh>", email, "Xác nhận tài khoản IELTS FLOW", 
            "Chào " + fullName + ",<br><br>Vui lòng click vào link bên dưới để xác thực tài khoản:<br>" +
            "<a href='" + verifyLink + "'>XÁC NHẬN TÀI KHOẢN</a>");

        return user;
    }

    @Override
    public User authenticateGoogleUser(String idTokenString) throws Exception {
        // We will move Google token logic here or keep it in Servlet for HTTP reasons?
        // Let's assume the servlet parses the token and extracts email/name.
        throw new UnsupportedOperationException("Implement in Servlet for HTTP Client API.");
    }

    @Override
    public void forgotPassword(String email) throws Exception {
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new Exception("Email không tồn tại trong hệ thống!");
        }
        
        String code = otpService.generateOtp(email);
        boolean sent = ResendUtil.sendMail("IELTS Flow <noreply@email.tanmanh350.ovh>", email, "Mã OTP Quên Mật Khẩu - IELTS FLOW", 
                "Mã OTP 6 số của bạn là: <b>" + code + "</b>. Mã có hiệu lực 5 phút.");
        
        if (!sent) {
            throw new Exception("Lỗi hệ thống gửi mail, vui lòng thử lại sau.");
        }
    }

    @Override
    public void verifyOtp(String email, String otp) throws Exception {
        if (!otpService.validateOtp(email, otp)) {
            throw new Exception("Mã OTP không chính xác hoặc đã hết hạn!");
        }
    }

    @Override
    public void resetPassword(String resetToken, String newPassword) throws Exception {
        String email = otpService.consumeResetToken(resetToken);
        if (email == null) {
            throw new Exception("Token không hợp lệ hoặc đã hết hạn.");
        }
        
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            userDAO.updatePassword(user.getUserId(), PasswordUtil.hashPassword(newPassword));
        } else {
            throw new Exception("Không tìm thấy user.");
        }
    }

    @Override
    public void verifyEmail(String token) throws Exception {
        String email = otpService.consumeVerifyToken(token);
        if (email == null) {
            throw new Exception("Link xác thực không hợp lệ hoặc đã hết hạn.");
        }

        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new Exception("Không tìm thấy tài khoản. Có thể đã bị xóa.");
        }

        User user = userOpt.get();
        if ("Active".equals(user.getStatus())) {
            throw new Exception("Tài khoản đã được xác thực từ trước rồi.");
        }

        if (!userDAO.updateStatus(user.getUserId(), "Active")) {
            throw new Exception("L-i h th`ng khi c-p nh-t trng thA?i.");
        }
    }

    @Override
    public void resendVerification(String email) throws Exception {
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new Exception("Email khA'ng tA'n tAoi.");
        }
        User user = userOpt.get();
        if ("Active".equals(user.getStatus())) {
            throw new Exception("Tài khoản đã xác thực. Không cần gửi lại.");
        }
        
        String token = otpService.generateVerifyToken(email);
        String verifyLink = "http://localhost:8080/IELTSFLOW/verify-email?token=" + token;
        ResendUtil.sendMail("IELTS Flow <noreply@email.tanmanh350.ovh>", email, "Xác nhận tài khoản IELTS FLOW", 
            "Vui lòng click vào link bên dưới để xác thực tài khoản:<br><a href='" + verifyLink + "'>XÁC NHẬN</a>");
    }

    @Override
    public void toggleUserBan(int userId) throws Exception {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            throw new Exception("Không tìm thấy người dùng.");
        }

        User user = userOpt.get();
        if (user.getRoleId() == 1) {
            throw new Exception("Không thể khóa tài khoản Admin!");
        }

        String newStatus = "Active".equals(user.getStatus()) ? "Banned" : "Active";
        if (!userDAO.updateStatus(user.getUserId(), newStatus)) {
            throw new Exception("L-i h th`ng khi c-p nh-t trng thA?i.");
        }
    }

    @Override
    public Map<String, Object> getSystemStats() throws Exception {
        return userDAO.getStats();
    }

    @Override
    public User getUserById(int userId) throws Exception {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            throw new Exception("User not found");
        }
        return userOpt.get();
    }

    @Override
    public void updateProfile(int userId, String fullName) throws Exception {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new Exception("Họ và tên không được để trống");
        }
        boolean updated = userDAO.updateFullName(userId, fullName.trim());
        if (!updated) {
            throw new Exception("Không thể cập nhật hồ sơ. Vui lòng thử lại.");
        }
    }

    @Override
    public void changePassword(int userId, String currentPassword, String newPassword) throws Exception {
        User user = getUserById(userId);

        if ("Google".equals(user.getAuthProvider())) {
            throw new Exception("Tài khoản Google không thể đổi mật khẩu tại đây.");
        }

        if (!PasswordUtil.checkPassword(currentPassword, user.getPasswordHash())) {
            throw new Exception("Mật khẩu hiện tại không chính xác.");
        }

        if (newPassword == null || newPassword.length() < 8) {
            throw new Exception("Mật khẩu mới phải có ít nhất 8 ký tự.");
        }

        String newHash = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(userId, newHash);
        if (!updated) {
            throw new Exception("Không thể đổi mật khẩu. Vui lòng thử lại.");
        }
    }
}


package services;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import util.ResendUtil;

import java.util.Map;
import java.util.Optional;
import java.util.List;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;
    private final OtpService otpService;

    public UserServiceImpl() {
        this.userDAO = new UserDAO();
        this.otpService = OtpService.getInstance();
    }

    private String getSender() {
        String domain = System.getProperty("RESEND_SEND_DOMAIN");
        if (domain == null || domain.trim().isEmpty()) {
            domain = System.getenv("RESEND_SEND_DOMAIN");
        }
        if (domain == null || domain.trim().isEmpty()) {
            domain = "email.tanmanh350.ovh";
        }
        return "IELTS Flow <noreply@" + domain.trim() + ">";
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
    public User registerUser(String fullName, String email, String password, String baseUrl) throws Exception {
        if (userDAO.emailExists(email)) {
            throw new Exception("Email đã được sử dụng!");
        }

        String hashedPassword = PasswordUtil.hashPassword(password);
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(userDAO.getCandidateRoleId()); // Candidate
        user.setStatus("Inactive"); // Requires email verification
        user.setAuthProvider("Local");

        if (userDAO.create(user) <= 0) {
            throw new Exception("Lỗi cơ sở dữ liệu. Không thể tạo tài khoản.");
        }

        // Gửi OTP xác thực
        String token = otpService.generateVerifyToken(email);
        String verifyLink = baseUrl + "/verify-email?token=" + token;
        ResendUtil.sendMail(getSender(), email, "Xác nhận tài khoản IELTS FLOW", 
            "Chào " + fullName + ",<br><br>Vui lòng click vào link bên dưới để xác thực tài khoản:<br>" +
            "<a href='" + verifyLink + "' style='background:#f97316;color:white;padding:10px 20px;text-decoration:none;border-radius:5px;'>XÁC NHẬN TÀI KHOẢN</a>");

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
        boolean sent = ResendUtil.sendMail(getSender(), email, "Mã OTP Quên Mật Khẩu - IELTS FLOW", 
                "Mã OTP 6 số của bạn là: <b>" + code + "</b>. Mã có hiệu lực 5 phút.");
        
        if (!sent) {
            throw new Exception("Lỗi hệ thống gửi mail, vui lòng thử lại sau.");
        }
    }

    @Override
    public String verifyOtp(String email, String otp) throws Exception {
        if (!otpService.validateOtp(email, otp)) {
            throw new Exception("Mã OTP không chính xác hoặc đã hết hạn!");
        }
        return otpService.generateResetToken(email);
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
    public void resendVerification(String email, String baseUrl) throws Exception {
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new Exception("Email khA'ng tA'n tAoi.");
        }
        User user = userOpt.get();
        if ("Active".equals(user.getStatus())) {
            throw new Exception("Tài khoản đã xác thực. Không cần gửi lại.");
        }
        
        String token = otpService.generateVerifyToken(email);
        String verifyLink = baseUrl + "/verify-email?token=" + token;
        ResendUtil.sendMail(getSender(), email, "Xác nhận tài khoản IELTS FLOW", 
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
    public void updateProfile(int userId, String fullName, String profilePic) throws Exception {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new Exception("Họ và tên không được để trống");
        }
        boolean updated = userDAO.updateProfile(userId, fullName.trim(), profilePic);
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

    // RoleID constants theo DB seed data
    public static final int ROLE_ADMIN     = 1;
    public static final int ROLE_MENTOR    = 2;
    public static final int ROLE_CANDIDATE = 3;

    @Override
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    @Override
    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email).orElse(null);
    }

    @Override
    public List<User> getMentors() {
        return userDAO.findByRole(ROLE_MENTOR);
    }

    @Override
    public void createUser(User user) {
        if (userDAO.emailExists(user.getEmail()))
            throw new IllegalArgumentException("Email đã tồn tại: " + user.getEmail());
        if (user.getRoleId() == 0) user.setRoleId(ROLE_CANDIDATE);
        userDAO.create(user);
    }

    @Override
    public void updateUser(int id, String fullName, String email, String status, int roleId) {
        User existing = userDAO.findById(id).orElse(null);
        if (existing == null) throw new IllegalArgumentException("User not found: " + id);
        
        // Prevent editing Admin role or changing a user to Admin
        if (existing.getRoleId() == ROLE_ADMIN) {
            roleId = ROLE_ADMIN; // Ignore any role change if they are already Admin
        } else if (roleId == ROLE_ADMIN) {
            throw new IllegalArgumentException("Cannot promote a user to Admin role.");
        }
        
        existing.setFullName(fullName);
        existing.setEmail(email);
        existing.setStatus(status);
        existing.setRoleId(roleId);
        userDAO.update(existing);
    }

    @Override
    public void lockUser(int id) {
        User user = userDAO.findById(id).orElse(null);
        if (user == null) throw new IllegalArgumentException("User not found: " + id);
        userDAO.updateStatus(id, "Inactive");
    }

    @Override
    public void updateUserStatus(int id, String status) {
        userDAO.updateStatus(id, status);
    }

    @Override
    public void assignMentorRole(int userId) {
        User user = userDAO.findById(userId).orElse(null);
        if (user == null) throw new IllegalArgumentException("User not found: " + userId);
        userDAO.setRole(userId, ROLE_MENTOR);
    }

    @Override
    public void revokeMentorRole(int userId) {
        User user = userDAO.findById(userId).orElse(null);
        if (user == null) throw new IllegalArgumentException("User not found: " + userId);
        userDAO.setRole(userId, ROLE_CANDIDATE);
    }

    @Override
    public void deleteUser(int id) {
        userDAO.softDelete(id);
    }
}


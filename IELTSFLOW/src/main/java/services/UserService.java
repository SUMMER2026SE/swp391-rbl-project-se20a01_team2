package services;

import model.User;
import java.util.Map;
import java.util.List;

public interface UserService {
    
    /**
     * Authenticate a user by email and password
     * @return User if successful
     * @throws Exception if authentication fails
     */
    User authenticateUser(String email, String password) throws Exception;
    
    /**
     * Register a new user
     * @return User if successful
     * @throws Exception if registration fails (e.g. email exists)
     */
    User registerUser(String fullName, String email, String password) throws Exception;
    
    /**
     * Authenticate or register a user via Google OAuth
     */
    User authenticateGoogleUser(String idTokenString) throws Exception;
    
    /**
     * Generate and send OTP for forgot password flow
     */
    void forgotPassword(String email) throws Exception;
    
    /**
     * Verify the OTP
     */
    void verifyOtp(String email, String otp) throws Exception;
    
    /**
     * Reset password using a valid reset token
     */
    void resetPassword(String resetToken, String newPassword) throws Exception;
    
    /**
     * Verify email during registration
     */
    void verifyEmail(String token) throws Exception;
    
    /**
     * Resend verification email
     */
    void resendVerification(String email) throws Exception;
    
    /**
     * Ban or unban a user
     */
    void toggleUserBan(int userId) throws Exception;
    
    /**
     * Get system statistics
     */
    Map<String, Object> getSystemStats() throws Exception;
    
    /**
     * Get user by ID
     */
    User getUserById(int userId) throws Exception;

    /**
     * Cập nhật hồ sơ cá nhân (fullName, profilePic)
     */
    void updateProfile(int userId, String fullName, String profilePic) throws Exception;

    /**
     * Đổi mật khẩu (yêu cầu nhập mật khẩu cũ)
     */
    void changePassword(int userId, String currentPassword, String newPassword) throws Exception;

    // ==========================================
    // Methods from branch "theirs"
    // ==========================================

    List<User> getAllUsers();

    User getUserByEmail(String email);

    List<User> getMentors();

    void createUser(User user);

    void updateUser(int id, String fullName, String email, String status, int roleId);

    void lockUser(int id);

    void updateUserStatus(int id, String status);

    void assignMentorRole(int userId);

    void revokeMentorRole(int userId);

    void deleteUser(int id);
}

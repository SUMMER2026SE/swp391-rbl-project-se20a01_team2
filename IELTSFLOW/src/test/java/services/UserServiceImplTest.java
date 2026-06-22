package services;

import dao.UserDAO;
import model.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;
import util.PasswordUtil;
import util.ResendUtil;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class UserServiceImplTest {

    private UserServiceImpl userService;
    private UserDAO userDAO;
    private OtpService otpService;
    private MockedStatic<PasswordUtil> mockedPasswordUtil;
    private MockedStatic<ResendUtil> mockedResendUtil;

    @BeforeEach
    void setUp() {
        userDAO = mock(UserDAO.class);
        otpService = mock(OtpService.class);
        userService = new UserServiceImpl(userDAO, otpService);

        mockedPasswordUtil = mockStatic(PasswordUtil.class);
        mockedResendUtil = mockStatic(ResendUtil.class);
    }

    @AfterEach
    void tearDown() {
        mockedPasswordUtil.close();
        mockedResendUtil.close();
    }

    // TC_REG_01: Register with valid data
    @Test
    void registerUser_ShouldReturnUserAndSendEmail_WhenDataIsValid() throws Exception {
        String fullName = "John Doe";
        String email = "john@example.com";
        String password = "Pass1234";
        String baseUrl = "http://localhost:8080";

        when(userDAO.emailExists(email)).thenReturn(false);
        mockedPasswordUtil.when(() -> PasswordUtil.hashPassword(password)).thenReturn("hashedPass");
        when(userDAO.getCandidateRoleId()).thenReturn(3);
        when(userDAO.create(any(User.class))).thenReturn(1);
        when(otpService.generateVerifyToken(email)).thenReturn("test-token");
        mockedResendUtil.when(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString())).thenReturn(true);

        User result = userService.registerUser(fullName, email, password, baseUrl);

        assertNotNull(result);
        assertEquals(fullName, result.getFullName());
        assertEquals(email, result.getEmail());
        assertEquals("Inactive", result.getStatus());
        assertEquals(3, result.getRoleId());
        
        verify(userDAO).create(any(User.class));
        mockedResendUtil.verify(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString()), times(1));
    }

    // Edge case / Validation fail: Email already exists
    @Test
    void registerUser_ShouldThrowException_WhenEmailAlreadyExists() {
        String email = "john@example.com";
        when(userDAO.emailExists(email)).thenReturn(true);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.registerUser("John Doe", email, "Pass1234", "http://localhost:8080");
        });
        assertEquals("Email đã được sử dụng!", exception.getMessage());
    }

    // TC_LOG_01: Login with valid Candidate account
    @Test
    void authenticateUser_ShouldReturnUser_WhenCredentialsAreValid() throws Exception {
        String email = "candidate@example.com";
        String password = "Pass1234";
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hashedPass");
        user.setStatus("Active");
        user.setRoleId(3);
        user.setAuthProvider("Local");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(password, "hashedPass")).thenReturn(true);

        User result = userService.authenticateUser(email, password);

        assertNotNull(result);
        assertEquals(email, result.getEmail());
    }

    // TC_LOG_03: Login with incorrect password
    @Test
    void authenticateUser_ShouldThrowException_WhenPasswordIsIncorrect() {
        String email = "candidate@example.com";
        String password = "WrongPass1";
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hashedPass");
        user.setStatus("Active");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(password, "hashedPass")).thenReturn(false);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.authenticateUser(email, password);
        });
        assertEquals("Mật khẩu không đúng.", exception.getMessage());
    }

    // TC_LOG_04: Login with non-existent email
    @Test
    void authenticateUser_ShouldThrowException_WhenEmailDoesNotExist() {
        String email = "notexist@example.com";
        when(userDAO.findByEmail(email)).thenReturn(Optional.empty());

        Exception exception = assertThrows(Exception.class, () -> {
            userService.authenticateUser(email, "Pass1234");
        });
        assertEquals("Email không tồn tại.", exception.getMessage());
    }

    // TC_LOG_05: Login with Banned account
    @Test
    void authenticateUser_ShouldThrowException_WhenAccountIsBanned() {
        String email = "banned@example.com";
        String password = "Pass1234";
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hashedPass");
        user.setStatus("Banned");
        user.setAuthProvider("Local");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(password, "hashedPass")).thenReturn(true);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.authenticateUser(email, password);
        });
        assertEquals("Tài khoản của bạn đã bị khóa vi phạm chính sách.", exception.getMessage());
    }

    // TC_LOG_06: Login with Inactive account
    @Test
    void authenticateUser_ShouldThrowException_WhenAccountIsInactive() {
        String email = "inactive@example.com";
        String password = "Pass1234";
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hashedPass");
        user.setStatus("Inactive");
        user.setAuthProvider("Local");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(password, "hashedPass")).thenReturn(true);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.authenticateUser(email, password);
        });
        assertEquals("Tài khoản chưa được xác thực email. INACTIVE_USER", exception.getMessage());
    }

    // TC_CP_01: Change Password successfully
    @Test
    void changePassword_ShouldUpdatePassword_WhenDataIsValid() throws Exception {
        int userId = 1;
        String currentPassword = "OldPass1";
        String newPassword = "NewPass1";
        User user = new User();
        user.setUserId(userId);
        user.setPasswordHash("oldHashedPass");
        user.setAuthProvider("Local");

        when(userDAO.findById(userId)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(currentPassword, "oldHashedPass")).thenReturn(true);
        mockedPasswordUtil.when(() -> PasswordUtil.hashPassword(newPassword)).thenReturn("newHashedPass");
        when(userDAO.updatePassword(userId, "newHashedPass")).thenReturn(true);

        assertDoesNotThrow(() -> userService.changePassword(userId, currentPassword, newPassword));
        verify(userDAO).updatePassword(userId, "newHashedPass");
    }

    // TC_CP_02/Edge case: Change Password with invalid new password length
    @Test
    void changePassword_ShouldThrowException_WhenNewPasswordIsTooShort() {
        int userId = 1;
        String currentPassword = "OldPass1";
        String newPassword = "Short"; // < 8 characters
        User user = new User();
        user.setUserId(userId);
        user.setPasswordHash("oldHashedPass");
        user.setAuthProvider("Local");

        when(userDAO.findById(userId)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(currentPassword, "oldHashedPass")).thenReturn(true);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.changePassword(userId, currentPassword, newPassword);
        });
        assertEquals("Mật khẩu mới phải có ít nhất 8 ký tự.", exception.getMessage());
    }

    // TC_FP_01: Forgot Password request OTP
    @Test
    void forgotPassword_ShouldSendOtpEmail_WhenEmailExists() throws Exception {
        String email = "valid@example.com";
        User user = new User();
        user.setEmail(email);
        
        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        when(otpService.generateOtp(email)).thenReturn("123456");
        mockedResendUtil.when(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString())).thenReturn(true);

        assertDoesNotThrow(() -> userService.forgotPassword(email));
        mockedResendUtil.verify(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString()), times(1));
    }

    // TC_FP_04: Forgot Password with non-existent email
    @Test
    void forgotPassword_ShouldThrowException_WhenEmailDoesNotExist() {
        String email = "nonexist@example.com";
        when(userDAO.findByEmail(email)).thenReturn(Optional.empty());

        Exception exception = assertThrows(Exception.class, () -> {
            userService.forgotPassword(email);
        });
        assertEquals("Email không tồn tại trong hệ thống!", exception.getMessage());
    }

    // TC_VE_01: Verify Email successfully
    @Test
    void verifyEmail_ShouldUpdateStatusToActive_WhenTokenIsValid() throws Exception {
        String token = "valid-token";
        String email = "user@example.com";
        User user = new User();
        user.setUserId(1);
        user.setEmail(email);
        user.setStatus("Inactive");

        when(otpService.consumeVerifyToken(token)).thenReturn(email);
        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        when(userDAO.updateStatus(1, "Active")).thenReturn(true);

        assertDoesNotThrow(() -> userService.verifyEmail(token));
        verify(userDAO).updateStatus(1, "Active");
    }

    // TC_VE_03: Verify Email with invalid/expired token
    @Test
    void verifyEmail_ShouldThrowException_WhenTokenIsInvalid() throws Exception {
        String token = "invalid-token";
        when(otpService.consumeVerifyToken(token)).thenReturn(null);

        Exception exception = assertThrows(Exception.class, () -> {
            userService.verifyEmail(token);
        });
        assertEquals("Link xác thực không hợp lệ hoặc đã hết hạn.", exception.getMessage());
    }

    // TC_ACC_01: Update Profile successfully
    @Test
    void updateProfile_ShouldUpdate_WhenDataIsValid() throws Exception {
        int userId = 1;
        String fullName = "Jane Doe";
        String profilePic = "https://url.to/pic.jpg";

        when(userDAO.updateProfile(userId, fullName, profilePic)).thenReturn(true);

        assertDoesNotThrow(() -> userService.updateProfile(userId, fullName, profilePic));
        verify(userDAO).updateProfile(userId, fullName, profilePic);
    }

    // TC_ACC_02: Update Profile with empty Name
    @Test
    void updateProfile_ShouldThrowException_WhenNameIsEmpty() {
        int userId = 1;
        String fullName = "";
        String profilePic = "https://url.to/pic.jpg";

        Exception exception = assertThrows(Exception.class, () -> {
            userService.updateProfile(userId, fullName, profilePic);
        });
        assertEquals("Họ và tên không được để trống", exception.getMessage());
    }

    // TC_UM_01: Admin bans a user
    @Test
    void toggleUserBan_ShouldToggleStatus_WhenUserIsNotAdmin() throws Exception {
        int userId = 10;
        User user = new User();
        user.setUserId(userId);
        user.setRoleId(3); // Candidate
        user.setStatus("Active");

        when(userDAO.findById(userId)).thenReturn(Optional.of(user));
        when(userDAO.updateStatus(userId, "Banned")).thenReturn(true);

        assertDoesNotThrow(() -> userService.toggleUserBan(userId));
        verify(userDAO).updateStatus(userId, "Banned");
    }

    // Edge case: Admin tries to ban another Admin
    @Test
    void toggleUserBan_ShouldThrowException_WhenUserIsAdmin() {
        int userId = 1;
        User user = new User();
        user.setUserId(userId);
        user.setRoleId(1); // Admin
        user.setStatus("Active");

        when(userDAO.findById(userId)).thenReturn(Optional.of(user));

        Exception exception = assertThrows(Exception.class, () -> {
            userService.toggleUserBan(userId);
        });
        assertEquals("Không thể khóa tài khoản Admin!", exception.getMessage());
    }

    // TC_LOG_02: Login with valid Admin/Mentor account
    @Test
    void authenticateUser_ShouldReturnUser_WhenAdminAccountIsValid() throws Exception {
        String email = "admin@example.com";
        String password = "AdminPass1";
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hashedPass");
        user.setStatus("Active");
        user.setRoleId(1);
        user.setAuthProvider("Local");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.checkPassword(password, "hashedPass")).thenReturn(true);

        User result = userService.authenticateUser(email, password);
        assertEquals(1, result.getRoleId());
    }

    // TC_FP_03: Reset Password length < 8
    @Test
    void resetPassword_ShouldThrowException_WhenNewPasswordIsTooShort() {
        String token = "valid-token";
        String newPassword = "Short";

        Exception exception = assertThrows(Exception.class, () -> {
            userService.resetPassword(token, newPassword);
        });
        assertEquals("Mật khẩu phải có ít nhất 8 ký tự.", exception.getMessage());
    }

    // TC_ACC_03: Update Profile with valid fullName and empty profilePic
    @Test
    void updateProfile_ShouldUpdate_WhenProfilePicIsEmpty() throws Exception {
        int userId = 1;
        String fullName = "Jane Doe";
        String profilePic = "";

        when(userDAO.updateProfile(userId, fullName, profilePic)).thenReturn(true);

        assertDoesNotThrow(() -> userService.updateProfile(userId, fullName, profilePic));
        verify(userDAO).updateProfile(userId, fullName, profilePic);
    }

    // TC_UM_02: Admin creates a new user with valid data
    @Test
    void createUser_ShouldCreateUser_WhenDataIsValid() {
        User newUser = new User();
        newUser.setFullName("New User");
        newUser.setEmail("new@ex.com");
        newUser.setRoleId(3);
        newUser.setStatus("Active");

        when(userDAO.emailExists(newUser.getEmail())).thenReturn(false);

        assertDoesNotThrow(() -> userService.createUser(newUser));
        verify(userDAO).create(newUser);
    }

    // TC_UM_03: Admin creates a new user with empty name
    @Test
    void createUser_ShouldThrowException_WhenNameIsEmpty() {
        User newUser = new User();
        newUser.setFullName(""); // empty
        newUser.setEmail("new@ex.com");
        newUser.setRoleId(3);
        newUser.setStatus("Active");

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.createUser(newUser);
        });
        assertEquals("Họ và tên không được để trống", exception.getMessage());
    }

    // TC_UM_04: Admin creates a new user with invalid email
    @Test
    void createUser_ShouldThrowException_WhenEmailIsInvalid() {
        User newUser = new User();
        newUser.setFullName("New User");
        newUser.setEmail("invalid-email"); // invalid
        newUser.setRoleId(3);
        newUser.setStatus("Active");

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.createUser(newUser);
        });
        assertEquals("Email không hợp lệ", exception.getMessage());
    }

    // TC_UM_05: Admin creates a new user missing role or status
    @Test
    void createUser_ShouldThrowException_WhenStatusIsNull() {
        User newUser = new User();
        newUser.setFullName("New User");
        newUser.setEmail("new@ex.com");
        newUser.setRoleId(3);
        newUser.setStatus(null); // null

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.createUser(newUser);
        });
        assertEquals("Trạng thái không được để trống", exception.getMessage());
    }

    // TC_UM_06: Admin assigns Mentor role
    @Test
    void assignMentorRole_ShouldUpdateRole_WhenUserExists() {
        int userId = 10;
        User user = new User();
        user.setUserId(userId);
        
        when(userDAO.findById(userId)).thenReturn(Optional.of(user));

        assertDoesNotThrow(() -> userService.assignMentorRole(userId));
        verify(userDAO).setRole(userId, UserServiceImpl.ROLE_MENTOR);
    }

    // TC_UM_07: Admin deletes a user (Soft Delete)
    @Test
    void deleteUser_ShouldSoftDelete_WhenCalled() {
        int userId = 10;

        assertDoesNotThrow(() -> userService.deleteUser(userId));
        verify(userDAO).softDelete(userId);
    }

    // --- MỚI: Tăng coverage cho các hàm chưa được test ---

    @Test
    void verifyOtp_ShouldReturnResetToken_WhenOtpIsValid() throws Exception {
        String email = "test@example.com";
        String otp = "123456";
        when(otpService.validateOtp(email, otp)).thenReturn(true);
        when(otpService.generateResetToken(email)).thenReturn("reset-token");

        String token = userService.verifyOtp(email, otp);
        assertEquals("reset-token", token);
    }

    @Test
    void resendVerification_ShouldSendEmail_WhenUserIsInactive() throws Exception {
        String email = "test@example.com";
        User user = new User();
        user.setEmail(email);
        user.setStatus("Inactive");

        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        when(otpService.generateVerifyToken(email)).thenReturn("verify-token");
        mockedResendUtil.when(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString())).thenReturn(true);

        assertDoesNotThrow(() -> userService.resendVerification(email, "http://localhost"));
        verify(otpService).generateVerifyToken(email);
        mockedResendUtil.verify(() -> ResendUtil.sendMail(anyString(), eq(email), anyString(), anyString()), times(1));
    }

    @Test
    void resetPassword_ShouldUpdatePassword_WhenTokenIsValid() throws Exception {
        String resetToken = "valid-token";
        String newPassword = "NewPassword123";
        String email = "test@example.com";
        User user = new User();
        user.setUserId(1);

        when(otpService.consumeResetToken(resetToken)).thenReturn(email);
        when(userDAO.findByEmail(email)).thenReturn(Optional.of(user));
        mockedPasswordUtil.when(() -> PasswordUtil.hashPassword(newPassword)).thenReturn("new-hash");

        assertDoesNotThrow(() -> userService.resetPassword(resetToken, newPassword));
        verify(userDAO).updatePassword(1, "new-hash");
    }

    @Test
    void updateUser_ShouldUpdateUser_WhenDataIsValid() {
        int id = 1;
        User existing = new User();
        existing.setUserId(id);
        existing.setRoleId(3);

        when(userDAO.findById(id)).thenReturn(Optional.of(existing));

        assertDoesNotThrow(() -> userService.updateUser(id, "Updated Name", "update@example.com", "Active", 2));
        verify(userDAO).update(existing);
        assertEquals("Updated Name", existing.getFullName());
        assertEquals(2, existing.getRoleId());
    }

    @Test
    void authenticateGoogleUser_ShouldThrowUnsupportedException() {
        assertThrows(UnsupportedOperationException.class, () -> {
            userService.authenticateGoogleUser("some-token");
        });
    }

    @Test
    void getSystemStats_ShouldReturnStats() throws Exception {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        when(userDAO.getStats()).thenReturn(stats);

        assertEquals(stats, userService.getSystemStats());
    }

    @Test
    void getUserById_ShouldReturnUser_WhenExists() throws Exception {
        User user = new User();
        when(userDAO.findById(1)).thenReturn(Optional.of(user));

        assertEquals(user, userService.getUserById(1));
    }

    @Test
    void getAllUsers_ShouldReturnList() {
        java.util.List<User> users = new java.util.ArrayList<>();
        when(userDAO.findAll()).thenReturn(users);

        assertEquals(users, userService.getAllUsers());
    }

    @Test
    void getUserByEmail_ShouldReturnUser_WhenExists() {
        User user = new User();
        when(userDAO.findByEmail("test@example.com")).thenReturn(Optional.of(user));

        assertEquals(user, userService.getUserByEmail("test@example.com"));
    }

    @Test
    void getMentors_ShouldReturnList() {
        java.util.List<User> mentors = new java.util.ArrayList<>();
        when(userDAO.findByRole(UserServiceImpl.ROLE_MENTOR)).thenReturn(mentors);

        assertEquals(mentors, userService.getMentors());
    }

    @Test
    void lockUser_ShouldUpdateStatusToInactive() {
        User user = new User();
        when(userDAO.findById(1)).thenReturn(Optional.of(user));

        assertDoesNotThrow(() -> userService.lockUser(1));
        verify(userDAO).updateStatus(1, "Inactive");
    }

    @Test
    void updateUserStatus_ShouldUpdateStatus() {
        assertDoesNotThrow(() -> userService.updateUserStatus(1, "Banned"));
        verify(userDAO).updateStatus(1, "Banned");
    }

    @Test
    void revokeMentorRole_ShouldUpdateRoleToCandidate() {
        User user = new User();
        when(userDAO.findById(1)).thenReturn(Optional.of(user));

        assertDoesNotThrow(() -> userService.revokeMentorRole(1));
        verify(userDAO).setRole(1, UserServiceImpl.ROLE_CANDIDATE);
    }
}

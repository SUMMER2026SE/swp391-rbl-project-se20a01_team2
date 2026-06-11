package services;

import java.time.LocalDateTime;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Random;

/**
 * Dịch vụ xử lý OTP và Token trong bộ nhớ (In-memory).
 * Quản lý mã OTP 6 số (Reset Password) và UUID token (Xác thực Email).
 */
public class OtpService {
    
    private static final OtpService INSTANCE = new OtpService();
    private final Random random = new Random();

    // Lưu trữ OTP: Key = email, Value = OtpEntry
    private final ConcurrentHashMap<String, OtpEntry> otpMap = new ConcurrentHashMap<>();
    
    // Lưu trữ Token: Key = token, Value = TokenEntry
    private final ConcurrentHashMap<String, TokenEntry> tokenMap = new ConcurrentHashMap<>();

    private OtpService() {}

    public static OtpService getInstance() {
        return INSTANCE;
    }

    /**
     * Tạo mã OTP 6 số ngẫu nhiên cho email (hiệu lực 5 phút)
     */
    public String generateOtp(String email) {
        String code = String.format("%06d", random.nextInt(1000000));
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(5);
        otpMap.put(email, new OtpEntry(code, expiresAt));
        return code;
    }

    /**
     * Xác thực mã OTP của email
     */
    public boolean validateOtp(String email, String code) {
        OtpEntry entry = otpMap.get(email);
        if (entry != null && entry.code.equals(code) && LocalDateTime.now().isBefore(entry.expiresAt)) {
            otpMap.remove(email); // Xóa sau khi dùng thành công
            return true;
        }
        return false;
    }

    /**
     * Tạo mã token (UUID) để đặt lại mật khẩu (hiệu lực 15 phút)
     */
    public String generateResetToken(String email) {
        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(15);
        tokenMap.put(token, new TokenEntry(email, "RESET_PASSWORD", expiresAt));
        return token;
    }

    /**
     * Xác thực và sử dụng token đặt lại mật khẩu
     */
    public String consumeResetToken(String token) {
        TokenEntry entry = tokenMap.get(token);
        if (entry != null && entry.type.equals("RESET_PASSWORD") 
                && LocalDateTime.now().isBefore(entry.expiresAt)) {
            tokenMap.remove(token);
            return entry.email;
        }
        return null;
    }

    /**
     * Tạo mã token (UUID) để xác thực email (hiệu lực 24 giờ)
     */
    public String generateVerifyToken(String email) {
        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusHours(24);
        tokenMap.put(token, new TokenEntry(email, "VERIFY_EMAIL", expiresAt));
        return token;
    }

    /**
     * Xác thực token xác nhận email và trả về email tương ứng
     * @return Email nếu token hợp lệ, null nếu không hợp lệ
     */
    public String consumeVerifyToken(String token) {
        TokenEntry entry = tokenMap.get(token);
        if (entry != null && entry.type.equals("VERIFY_EMAIL") && LocalDateTime.now().isBefore(entry.expiresAt)) {
            tokenMap.remove(token);
            return entry.email;
        }
        return null;
    }

    // --- Các lớp trợ giúp (Helper classes) ---

    private static class OtpEntry {
        String code;
        LocalDateTime expiresAt;

        OtpEntry(String code, LocalDateTime expiresAt) {
            this.code = code;
            this.expiresAt = expiresAt;
        }
    }

    private static class TokenEntry {
        String email;
        String type;
        LocalDateTime expiresAt;

        TokenEntry(String email, String type, LocalDateTime expiresAt) {
            this.email = email;
            this.type = type;
            this.expiresAt = expiresAt;
        }
    }
}

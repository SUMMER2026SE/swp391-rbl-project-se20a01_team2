package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Tiện ích xử lý mật khẩu bằng BCrypt
 */
public class PasswordUtil {
    
    // Hệ số độ khó của thuật toán băm mật khẩu (work factor)
    private static final int WORK_FACTOR = 12;

    private PasswordUtil() {
        // Ẩn constructor
    }

    /**
     * Băm mật khẩu (Hash password)
     * @param plainPassword Mật khẩu gốc (chưa mã hóa)
     * @return Mật khẩu đã băm (chuỗi BCrypt)
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Kiểm tra mật khẩu có khớp với hash không
     * @param plainPassword Mật khẩu nhập vào
     * @param hashedPassword Hash mật khẩu trong cơ sở dữ liệu
     * @return true nếu khớp, ngược lại false
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || hashedPassword.isEmpty() || plainPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Kiểm tra độ mạnh của mật khẩu (Tối thiểu 8 ký tự, có chứa ít nhất 1 chữ số và 1 chữ cái)
     * @param password Mật khẩu cần kiểm tra
     * @return true nếu mật khẩu mạnh
     */
    public static boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        boolean hasDigit = false;
        boolean hasLetter = false;

        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) hasDigit = true;
            if (Character.isLetter(c)) hasLetter = true;
            if (hasDigit && hasLetter) return true;
        }
        return false;
    }
}

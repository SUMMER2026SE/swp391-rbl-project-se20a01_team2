package util;

/**
 * Quản lý ThreadLocal để lưu trữ thông tin User đang thao tác trong request hiện tại.
 * Giúp các tầng thấp hơn (như JPA Listener) có thể truy cập được ID của User 
 * mà không cần truyền parameter liên tục.
 */
public class UserContext {
    private static final ThreadLocal<Integer> currentUserId = new ThreadLocal<>();

    public static void setCurrentUserId(Integer userId) {
        currentUserId.set(userId);
    }

    public static Integer getCurrentUserId() {
        return currentUserId.get();
    }

    public static void clear() {
        currentUserId.remove();
    }
}

package services;

import dao.NotificationDAO;
import dao.UserDAO;
import model.Notification;
import model.User;

import java.util.List;

/**
 * Service xử lý business logic cho thông báo (Notification)
 */
public class NotificationService {

    private final NotificationDAO notificationDAO;
    private final UserDAO userDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
        this.userDAO = new UserDAO();
    }

    /**
     * Lấy danh sách tất cả thông báo của user
     */
    public List<Notification> getNotifications(int userId) {
        return notificationDAO.findByUserId(userId);
    }

    /**
     * Đếm số thông báo chưa đọc
     */
    public long countUnread(int userId) {
        return notificationDAO.countUnread(userId);
    }

    /**
     * Đánh dấu một thông báo đã đọc
     */
    public void markAsRead(int notificationId, int userId) throws Exception {
        Notification n = notificationDAO.findById(notificationId)
            .orElseThrow(() -> new Exception("Không tìm thấy thông báo"));

        // Kiểm tra quyền: chỉ chủ sở hữu mới được đọc
        if (n.getUser().getUserId() != userId) {
            throw new Exception("Không có quyền truy cập thông báo này");
        }

        notificationDAO.markAsRead(notificationId);
    }

    /**
     * Đánh dấu tất cả thông báo của user là đã đọc
     */
    public void markAllAsRead(int userId) {
        notificationDAO.markAllAsRead(userId);
    }

    /**
     * Tạo thông báo nhắc học (dùng cho Scheduler hoặc Admin)
     */
    public Notification createReminder(int userId, String title, String message) throws Exception {
        User user = userDAO.findById(userId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));

        Notification n = new Notification(user, title, message, "REMINDER");
        notificationDAO.create(n);
        return n;
    }

    /**
     * Tạo thông báo hệ thống cho tất cả user (Admin broadcast)
     */
    public void broadcastSystemNotification(String title, String message) {
        // Lấy toàn bộ user và tạo notification cho từng người
        userDAO.findAll().forEach(user -> {
            Notification n = new Notification(user, title, message, "SYSTEM");
            notificationDAO.create(n);
        });
    }
}

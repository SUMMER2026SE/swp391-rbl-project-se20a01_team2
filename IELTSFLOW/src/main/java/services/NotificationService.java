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

        // Kiểm tra quyền: chỉ chủ sở hữu mới được đánh dấu
        if (n.getUser().getUserId() != userId) {
            throw new Exception("Không có quyền truy cập thông báo này");
        }

        notificationDAO.markAsRead(notificationId);
    }

    /**
     * Tạo một thông báo mới
     */
    public void createNotification(int userId, String title, String content, String type) {
        try {
            User user = userDAO.findById(userId).orElse(null);
            if (user != null) {
                Notification n = new Notification();
                n.setUser(user);
                n.setTitle(title);
                n.setContent(content);
                n.setType(type);
                n.setCreatedAt(java.time.LocalDateTime.now());
                n.setRead(false);
                notificationDAO.create(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendWelcomeNotifications(int userId) {
        createNotification(userId, "Chào mừng đến với IELTSFlow!", "Hãy bắt đầu bằng việc thiết lập Mục tiêu Band điểm của bạn nhé.", "System");
        createNotification(userId, "Bài kiểm tra đầu vào", "Vui lòng làm bài kiểm tra đầu vào (Placement Test) để hệ thống đánh giá trình độ hiện tại của bạn.", "System");
    }

    public void sendReadyToGeneratePlanNotification(int userId) {
        createNotification(userId, "Bạn đã đủ điều kiện!", "Hãy vào mục Kế hoạch tuần (Weekly Plan) để tạo lộ trình học cá nhân hóa ngay.", "System");
    }

    public void sendPlanGeneratedNotification(int userId) {
        createNotification(userId, "Lộ trình học đã sẵn sàng!", "Lộ trình học AI của bạn đã được tạo thành công. Hãy vào mục Kế hoạch tuần để xem nhé.", "System");
    }

    public void sendTargetChangedNotification(int userId) {
        createNotification(userId, "Mục tiêu đã thay đổi", "Mục tiêu của bạn đã thay đổi. Vui lòng cập nhật Lộ trình học (Weekly Plan) để hệ thống điều chỉnh theo mục tiêu mới.", "Reminder");
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
    public Notification createReminder(int userId, String title, String content) throws Exception {
        User user = userDAO.findById(userId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));

        Notification n = new Notification(user, title, content, "Reminder");
        notificationDAO.create(n);
        return n;
    }

    /**
     * Tạo thông báo hệ thống cho tất cả user (Admin broadcast)
     */
    public void broadcastSystemNotification(String title, String content) {
        // Lấy toàn bộ user và tạo notification cho từng người
        userDAO.findAll().forEach(user -> {
            Notification n = new Notification(user, title, content, "System");
            notificationDAO.create(n);
        });
    }
}

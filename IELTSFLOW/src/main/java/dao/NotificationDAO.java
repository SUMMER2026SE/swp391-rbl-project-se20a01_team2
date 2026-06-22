package dao;

import model.Notification;
import util.JpaHelper;

import java.util.List;
import java.util.Optional;

/**
 * DAO xử lý truy vấn thông báo (Notification)
 */
public class NotificationDAO {

    /**
     * Lấy tất cả thông báo của một user, mới nhất trước
     */
    public List<Notification> findByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT n FROM Notification n WHERE n.user.userId = :userId ORDER BY n.createdAt DESC",
                Notification.class)
              .setParameter("userId", userId)
              .getResultList()
        );
    }

    /**
     * Đếm số thông báo chưa đọc của user
     */
    public long countUnread(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT COUNT(n) FROM Notification n WHERE n.user.userId = :userId AND n.isRead = false",
                Long.class)
              .setParameter("userId", userId)
              .getSingleResult()
        );
    }

    /**
     * Tìm thông báo theo ID
     */
    public Optional<Notification> findById(int notificationId) {
        return JpaHelper.query(em ->
            Optional.ofNullable(em.find(Notification.class, notificationId))
        );
    }

    /**
     * Tạo thông báo mới
     */
    public int create(Notification notification) {
        JpaHelper.execute(em -> em.persist(notification));
        return notification.getNotificationId();
    }

    /**
     * Đánh dấu một thông báo là đã đọc
     */
    public boolean markAsRead(int notificationId) {
        try {
            JpaHelper.execute(em -> {
                Notification n = em.find(Notification.class, notificationId);
                if (n != null) n.setRead(true);
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đánh dấu tất cả thông báo của user là đã đọc
     */
    public void markAllAsRead(int userId) {
        JpaHelper.execute(em ->
            em.createQuery(
                "UPDATE Notification n SET n.isRead = true WHERE n.user.userId = :userId AND n.isRead = false")
              .setParameter("userId", userId)
              .executeUpdate()
        );
    }
}

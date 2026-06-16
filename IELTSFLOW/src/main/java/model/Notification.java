package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho thông báo nhắc học (Notification)
 */
@Entity
@Table(name = "Notifications")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "NotificationID")
    private int notificationId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserID", nullable = false)
    private User user;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Content", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String content;

    /**
     * Loại thông báo: "REMINDER" (nhắc học), "SYSTEM" (hệ thống), "PROMOTION" (khuyến mãi)
     */
    @Column(name = "Type")
    private String type = "System";

    @Column(name = "IsRead")
    private boolean isRead = false;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    public Notification() {
    }

    public Notification(User user, String title, String content, String type) {
        this.user = user;
        this.title = title;
        this.content = content;
        this.type = type;
        this.isRead = false;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Getters and Setters

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

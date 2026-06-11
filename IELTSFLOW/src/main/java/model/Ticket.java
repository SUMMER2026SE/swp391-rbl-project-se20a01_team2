package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho ticket hỗ trợ (Support Ticket)
 * Học viên gửi thắc mắc, Mentor phản hồi.
 */
@Entity
@Table(name = "Tickets")
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TicketID")
    private int ticketId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserID", nullable = false)
    private User user;

    @Column(name = "Subject", nullable = false)
    private String subject;

    @Column(name = "Content", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String content;

    /**
     * Trạng thái ticket: "Open", "InProgress", "Resolved", "Closed"
     */
    @Column(name = "Status", nullable = false)
    private String status = "Open";

    @Column(name = "AdminReply", columnDefinition = "NVARCHAR(MAX)")
    private String adminReply;

    @Column(name = "RepliedAt")
    private LocalDateTime repliedAt;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    @Column(name = "UpdatedAt")
    private LocalDateTime updatedAt;

    public Ticket() {
    }

    public Ticket(User user, String subject, String content) {
        this.user = user;
        this.subject = subject;
        this.content = content;
        this.status = "Open";
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Getters and Setters

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }

    public LocalDateTime getRepliedAt() { return repliedAt; }
    public void setRepliedAt(LocalDateTime repliedAt) { this.repliedAt = repliedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}

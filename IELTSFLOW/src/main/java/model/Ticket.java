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

    /**
     * Trạng thái ticket: "Open", "InProgress", "Resolved", "Closed"
     */
    @Column(name = "Status", nullable = false)
    private String status = "Open";

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "ticket", cascade = CascadeType.ALL, orphanRemoval = true)
    private java.util.List<TicketReply> replies = new java.util.ArrayList<>();

    public Ticket() {
    }

    public Ticket(User user, String subject) {
        this.user = user;
        this.subject = subject;
        this.status = "Open";
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    // Getters and Setters

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public java.util.List<TicketReply> getReplies() { return replies; }
    public void setReplies(java.util.List<TicketReply> replies) { this.replies = replies; }

    public String getLastMessage() {
        if (replies != null && !replies.isEmpty()) {
            return replies.get(replies.size() - 1).getMessage();
        }
        return "";
    }
}

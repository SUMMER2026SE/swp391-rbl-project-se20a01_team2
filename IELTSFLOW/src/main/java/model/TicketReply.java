package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "TicketReplies")
public class TicketReply {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ReplyID")
    private int replyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TicketID", nullable = false)
    private Ticket ticket;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SenderID", nullable = false)
    private User sender;

    @Column(name = "Message", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String message;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    public TicketReply() {
    }

    public TicketReply(Ticket ticket, User sender, String message) {
        this.ticket = ticket;
        this.sender = sender;
        this.message = message;
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    // Getters and Setters
    public int getReplyId() { return replyId; }
    public void setReplyId(int replyId) { this.replyId = replyId; }

    public Ticket getTicket() { return ticket; }
    public void setTicket(Ticket ticket) { this.ticket = ticket; }

    public User getSender() { return sender; }
    public void setSender(User sender) { this.sender = sender; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

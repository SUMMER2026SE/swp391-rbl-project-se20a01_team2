package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "UserQuestionBookmarks")
public class UserQuestionBookmark {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BookmarkID")
    private int bookmarkId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @Column(name = "QuestionID", nullable = false)
    private int questionId;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    public UserQuestionBookmark() {}

    public int getBookmarkId() { return bookmarkId; }
    public void setBookmarkId(int bookmarkId) { this.bookmarkId = bookmarkId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

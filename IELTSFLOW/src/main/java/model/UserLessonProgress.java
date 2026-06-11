package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "UserLessonProgress")
public class UserLessonProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ProgressID")
    private int progressId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @Column(name = "LessonID", nullable = false)
    private int lessonId;

    @Column(name = "IsCompleted")
    private boolean isCompleted = false;

    @Column(name = "IsBookmarked")
    private boolean isBookmarked = false;

    @Column(name = "LastAccessed")
    private LocalDateTime lastAccessed;

    public UserLessonProgress() {}

    public int getProgressId() { return progressId; }
    public void setProgressId(int progressId) { this.progressId = progressId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getLessonId() { return lessonId; }
    public void setLessonId(int lessonId) { this.lessonId = lessonId; }
    public boolean isCompleted() { return isCompleted; }
    public void setCompleted(boolean completed) { isCompleted = completed; }
    public boolean isBookmarked() { return isBookmarked; }
    public void setBookmarked(boolean bookmarked) { isBookmarked = bookmarked; }
    public LocalDateTime getLastAccessed() { return lastAccessed; }
    public void setLastAccessed(LocalDateTime lastAccessed) { this.lastAccessed = lastAccessed; }
}

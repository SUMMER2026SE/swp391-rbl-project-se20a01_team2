package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Exams")
@jakarta.persistence.EntityListeners(listener.AuditEntityListener.class)
public class Exam {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ExamID")
    private int examId;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Type", nullable = false)
    private String type; // Mock Test, Placement Test, Practice

    @Column(name = "SkillFocus")
    private String skillFocus = "All"; // Reading, Listening, Writing, Speaking, All

    @Column(name = "Duration", nullable = false)
    private int duration;

    @Column(name = "MentorID")
    private Integer mentorId;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    @Column(name = "Deleted")
    private boolean deleted = false;

    public Exam() {}

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getSkillFocus() { return skillFocus; }
    public void setSkillFocus(String skillFocus) { this.skillFocus = skillFocus; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public Integer getMentorId() { return mentorId; }
    public void setMentorId(Integer mentorId) { this.mentorId = mentorId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public boolean isDeleted() { return deleted; }
    public void setDeleted(boolean deleted) { this.deleted = deleted; }
}

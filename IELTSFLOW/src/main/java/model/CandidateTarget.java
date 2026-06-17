package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "CandidateTargets")
public class CandidateTarget {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TargetID")
    private int targetId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @Column(name = "TargetBand", nullable = false, precision = 3, scale = 1)
    private BigDecimal targetBand;

    @Column(name = "CurrentBand", precision = 3, scale = 1)
    private BigDecimal currentBand;

    @Column(name = "ExamDate")
    private LocalDate examDate;

    @Column(name = "IsActive")
    private boolean isActive = true;

    public CandidateTarget() {}

    public CandidateTarget(int userId, BigDecimal targetBand, BigDecimal currentBand, LocalDate examDate) {
        this.userId = userId;
        this.targetBand = targetBand;
        this.currentBand = currentBand;
        this.examDate = examDate;
        this.isActive = true;
    }

    public int getTargetId() { return targetId; }
    public void setTargetId(int targetId) { this.targetId = targetId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public BigDecimal getTargetBand() { return targetBand; }
    public void setTargetBand(BigDecimal targetBand) { this.targetBand = targetBand; }

    public BigDecimal getCurrentBand() { return currentBand; }
    public void setCurrentBand(BigDecimal currentBand) { this.currentBand = currentBand; }

    public LocalDate getExamDate() { return examDate; }
    public void setExamDate(LocalDate examDate) { this.examDate = examDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}

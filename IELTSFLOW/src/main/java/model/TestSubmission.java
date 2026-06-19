package model;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * DTO: Kết quả từ bảng TestSubmissions JOIN Exams.
 * Dùng để hiển thị lịch sử bài thi + biểu đồ tiến độ Band Score.
 */
public class TestSubmission {

    private int submissionId;
    private int userId;
    private int examId;
    private String examTitle;   // JOIN từ Exams.Title
    private String examType;    // JOIN từ Exams.Type (Mock Test, Practice, ...)

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private Double listeningBand;
    private Double readingBand;
    private Double writingBand;
    private Double speakingBand;
    private Double overallBand;
    private Double totalScore;

    private int violationCount;
    private boolean isCheated;
    private String status; // InProgress, Completed, Abandoned

    public TestSubmission() {}

    // --- Getters & Setters ---

    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public String getExamTitle() { return examTitle; }
    public void setExamTitle(String examTitle) { this.examTitle = examTitle; }

    public String getExamType() { return examType; }
    public void setExamType(String examType) { this.examType = examType; }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public Double getListeningBand() { return listeningBand; }
    public void setListeningBand(Double listeningBand) { this.listeningBand = listeningBand; }

    public Double getReadingBand() { return readingBand; }
    public void setReadingBand(Double readingBand) { this.readingBand = readingBand; }

    public Double getWritingBand() { return writingBand; }
    public void setWritingBand(Double writingBand) { this.writingBand = writingBand; }

    public Double getSpeakingBand() { return speakingBand; }
    public void setSpeakingBand(Double speakingBand) { this.speakingBand = speakingBand; }

    public Double getOverallBand() { return overallBand; }
    public void setOverallBand(Double overallBand) { this.overallBand = overallBand; }

    public Double getTotalScore() { return totalScore; }
    public void setTotalScore(Double totalScore) { this.totalScore = totalScore; }

    public int getViolationCount() { return violationCount; }
    public void setViolationCount(int violationCount) { this.violationCount = violationCount; }

    public boolean isCheated() { return isCheated; }
    public void setCheated(boolean cheated) { isCheated = cheated; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    /**
     * Tiện ích: chuyển startTime sang java.util.Date để dùng trong JSTL fmt:formatDate
     */
    public Date getStartTimeAsDate() {
        if (startTime == null) return null;
        return java.util.Date.from(startTime.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }
}

package model;

import java.time.LocalDateTime;

public class AIEvaluation {
    private int evaluationId;
    private int detailId;
    private String feedbackJson;
    private LocalDateTime createdAt;

    public AIEvaluation() {
    }

    public AIEvaluation(int evaluationId, int detailId, String feedbackJson, LocalDateTime createdAt) {
        this.evaluationId = evaluationId;
        this.detailId = detailId;
        this.feedbackJson = feedbackJson;
        this.createdAt = createdAt;
    }

    public int getEvaluationId() {
        return evaluationId;
    }

    public void setEvaluationId(int evaluationId) {
        this.evaluationId = evaluationId;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public String getFeedbackJson() {
        return feedbackJson;
    }

    public void setFeedbackJson(String feedbackJson) {
        this.feedbackJson = feedbackJson;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

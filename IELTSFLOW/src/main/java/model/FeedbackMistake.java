package model;

public class FeedbackMistake {
    private String mistake;
    private String reason;
    private String correction;

    public FeedbackMistake() {}

    public FeedbackMistake(String mistake, String reason, String correction) {
        this.mistake = mistake;
        this.reason = reason;
        this.correction = correction;
    }

    public String getMistake() { return mistake; }
    public void setMistake(String mistake) { this.mistake = mistake; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getCorrection() { return correction; }
    public void setCorrection(String correction) { this.correction = correction; }
}

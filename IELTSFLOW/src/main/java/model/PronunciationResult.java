package model;

import com.fasterxml.jackson.databind.JsonNode;

public class PronunciationResult {
    private boolean success;
    private double accuracyScore;
    private double fluencyScore;
    private double completenessScore;
    private double prosodyScore;
    private double pronunciationScore;
    private String recognizedText;
    private JsonNode detailedJson;
    private String errorMessage;

    public PronunciationResult() {
    }

    // Success response
    public PronunciationResult(double accuracyScore, double fluencyScore, double completenessScore, 
                               double prosodyScore, double pronunciationScore, String recognizedText, JsonNode detailedJson) {
        this.success = true;
        this.accuracyScore = accuracyScore;
        this.fluencyScore = fluencyScore;
        this.completenessScore = completenessScore;
        this.prosodyScore = prosodyScore;
        this.pronunciationScore = pronunciationScore;
        this.recognizedText = recognizedText;
        this.detailedJson = detailedJson;
    }

    // Error response
    public static PronunciationResult error(String message) {
        PronunciationResult result = new PronunciationResult();
        result.setSuccess(false);
        result.setErrorMessage(message);
        return result;
    }

    // Getters and Setters

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public double getAccuracyScore() {
        return accuracyScore;
    }

    public void setAccuracyScore(double accuracyScore) {
        this.accuracyScore = accuracyScore;
    }

    public double getFluencyScore() {
        return fluencyScore;
    }

    public void setFluencyScore(double fluencyScore) {
        this.fluencyScore = fluencyScore;
    }

    public double getCompletenessScore() {
        return completenessScore;
    }

    public void setCompletenessScore(double completenessScore) {
        this.completenessScore = completenessScore;
    }

    public double getProsodyScore() {
        return prosodyScore;
    }

    public void setProsodyScore(double prosodyScore) {
        this.prosodyScore = prosodyScore;
    }

    public double getPronunciationScore() {
        return pronunciationScore;
    }

    public void setPronunciationScore(double pronunciationScore) {
        this.pronunciationScore = pronunciationScore;
    }

    public String getRecognizedText() {
        return recognizedText;
    }

    public void setRecognizedText(String recognizedText) {
        this.recognizedText = recognizedText;
    }

    public JsonNode getDetailedJson() {
        return detailedJson;
    }

    public void setDetailedJson(JsonNode detailedJson) {
        this.detailedJson = detailedJson;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}

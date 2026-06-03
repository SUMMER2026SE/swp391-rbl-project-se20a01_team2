package model;

import java.util.List;

public class FeedbackWriting {
    private double taskResponse;
    private double coherenceAndCohesion;
    private double lexicalResource;
    private double grammaticalRangeAndAccuracy;
    private double overallBand;
    private String overallFeedback;
    private List<FeedbackMistake> mistakes;

    public FeedbackWriting() {}

    // Getters and setters
    public double getTaskResponse() { return taskResponse; }
    public void setTaskResponse(double taskResponse) { this.taskResponse = taskResponse; }

    public double getCoherenceAndCohesion() { return coherenceAndCohesion; }
    public void setCoherenceAndCohesion(double coherenceAndCohesion) { this.coherenceAndCohesion = coherenceAndCohesion; }

    public double getLexicalResource() { return lexicalResource; }
    public void setLexicalResource(double lexicalResource) { this.lexicalResource = lexicalResource; }

    public double getGrammaticalRangeAndAccuracy() { return grammaticalRangeAndAccuracy; }
    public void setGrammaticalRangeAndAccuracy(double grammaticalRangeAndAccuracy) { this.grammaticalRangeAndAccuracy = grammaticalRangeAndAccuracy; }

    public double getOverallBand() { return overallBand; }
    public void setOverallBand(double overallBand) { this.overallBand = overallBand; }

    public String getOverallFeedback() { return overallFeedback; }
    public void setOverallFeedback(String overallFeedback) { this.overallFeedback = overallFeedback; }

    public List<FeedbackMistake> getMistakes() { return mistakes; }
    public void setMistakes(List<FeedbackMistake> mistakes) { this.mistakes = mistakes; }
}

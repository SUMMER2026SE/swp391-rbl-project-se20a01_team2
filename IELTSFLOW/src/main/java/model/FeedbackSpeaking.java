package model;

import java.util.List;

public class FeedbackSpeaking {
    private double fluencyAndCoherence;
    private double lexicalResource;
    private double grammaticalRangeAndAccuracy;
    private double pronunciation;
    private double overallBand;
    private String overallFeedback;
    private List<FeedbackMistake> mistakes;

    public FeedbackSpeaking() {}

    // Getters and setters
    public double getFluencyAndCoherence() { return fluencyAndCoherence; }
    public void setFluencyAndCoherence(double fluencyAndCoherence) { this.fluencyAndCoherence = fluencyAndCoherence; }

    public double getLexicalResource() { return lexicalResource; }
    public void setLexicalResource(double lexicalResource) { this.lexicalResource = lexicalResource; }

    public double getGrammaticalRangeAndAccuracy() { return grammaticalRangeAndAccuracy; }
    public void setGrammaticalRangeAndAccuracy(double grammaticalRangeAndAccuracy) { this.grammaticalRangeAndAccuracy = grammaticalRangeAndAccuracy; }

    public double getPronunciation() { return pronunciation; }
    public void setPronunciation(double pronunciation) { this.pronunciation = pronunciation; }

    public double getOverallBand() { return overallBand; }
    public void setOverallBand(double overallBand) { this.overallBand = overallBand; }

    public String getOverallFeedback() { return overallFeedback; }
    public void setOverallFeedback(String overallFeedback) { this.overallFeedback = overallFeedback; }

    public List<FeedbackMistake> getMistakes() { return mistakes; }
    public void setMistakes(List<FeedbackMistake> mistakes) { this.mistakes = mistakes; }
}

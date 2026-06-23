package model;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class MentorSkillStat {
    private String skill;               // "Writing" or "Speaking"
    private int submissionCount;        // how many AI-graded submissions
    private double avgBand;             // average overallBand
    private int totalMistakes;          // total mistake entries across all submissions
    // bucket → count, e.g. "Grammar" → 42
    private Map<String, Integer> mistakesByCategory = new LinkedHashMap<>();

    public String getSkill() {
        return skill;
    }

    public void setSkill(String skill) {
        this.skill = skill;
    }

    public int getSubmissionCount() {
        return submissionCount;
    }

    public void setSubmissionCount(int submissionCount) {
        this.submissionCount = submissionCount;
    }

    public double getAvgBand() {
        return avgBand;
    }

    public void setAvgBand(double avgBand) {
        this.avgBand = avgBand;
    }

    public int getTotalMistakes() {
        return totalMistakes;
    }

    public void setTotalMistakes(int totalMistakes) {
        this.totalMistakes = totalMistakes;
    }

    public Map<String, Integer> getMistakesByCategory() {
        return mistakesByCategory;
    }

    public void setMistakesByCategory(Map<String, Integer> mistakesByCategory) {
        this.mistakesByCategory = mistakesByCategory;
    }
}

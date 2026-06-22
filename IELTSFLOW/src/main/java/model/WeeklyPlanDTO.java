package model;

import java.util.List;

/**
 * DTO to map the structured JSON response from Gemini API for AI Pathway Generation.
 */
public class WeeklyPlanDTO {
    private int weekNumber;
    private String skillsFocus;
    private String objectives;
    private List<String> activities;

    public WeeklyPlanDTO() {}

    public int getWeekNumber() {
        return weekNumber;
    }

    public void setWeekNumber(int weekNumber) {
        this.weekNumber = weekNumber;
    }

    public String getSkillsFocus() {
        return skillsFocus;
    }

    public void setSkillsFocus(String skillsFocus) {
        this.skillsFocus = skillsFocus;
    }

    public String getObjectives() {
        return objectives;
    }

    public void setObjectives(String objectives) {
        this.objectives = objectives;
    }

    public List<String> getActivities() {
        return activities;
    }

    public void setActivities(List<String> activities) {
        this.activities = activities;
    }
}

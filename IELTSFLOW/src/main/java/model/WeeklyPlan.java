package model;

import jakarta.persistence.*;

@Entity
@Table(name = "WeeklyPlans")
public class WeeklyPlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PlanID")
    private int planId;

    @Column(name = "PathwayID", nullable = false)
    private int pathwayId;

    @Column(name = "WeekNumber", nullable = false)
    private int weekNumber;

    @Column(name = "PlanContent", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String planContent; // JSON string theo DB constraint

    @Column(name = "IsCompleted")
    private boolean isCompleted = false;

    public WeeklyPlan() {}

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }
    public int getPathwayId() { return pathwayId; }
    public void setPathwayId(int pathwayId) { this.pathwayId = pathwayId; }
    public int getWeekNumber() { return weekNumber; }
    public void setWeekNumber(int weekNumber) { this.weekNumber = weekNumber; }
    public String getPlanContent() { return planContent; }
    public void setPlanContent(String planContent) { this.planContent = planContent; }
    public boolean isCompleted() { return isCompleted; }
    public void setCompleted(boolean completed) { isCompleted = completed; }
}

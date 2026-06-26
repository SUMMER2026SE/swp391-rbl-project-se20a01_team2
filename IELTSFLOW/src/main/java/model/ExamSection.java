package model;

import jakarta.persistence.*;

@Entity
@Table(name = "ExamSections")
public class ExamSection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SectionID")
    private int sectionId;

    @Column(name = "ExamID", nullable = false)
    private int examId;

    @Column(name = "Skill", nullable = false)
    private String skill = "Listening";

    @Column(name = "SectionName", nullable = false)
    private String sectionName;

    @Column(name = "ResourceID")
    private Integer resourceId;

    @Column(name = "OrderIndex", nullable = false)
    private int orderIndex;

    @Transient
    private java.util.List<ExamQuestion> examQuestions = new java.util.ArrayList<>();

    public ExamSection() {}

    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getSkill() { return skill; }
    public void setSkill(String skill) { this.skill = skill; }
    public String getSectionName() { return sectionName; }
    public void setSectionName(String sectionName) { this.sectionName = sectionName; }
    public Integer getResourceId() { return resourceId; }
    public void setResourceId(Integer resourceId) { this.resourceId = resourceId; }
    public int getOrderIndex() { return orderIndex; }
    public void setOrderIndex(int orderIndex) { this.orderIndex = orderIndex; }
    public java.util.List<ExamQuestion> getExamQuestions() { return examQuestions; }
    public void setExamQuestions(java.util.List<ExamQuestion> examQuestions) { this.examQuestions = examQuestions; }
}

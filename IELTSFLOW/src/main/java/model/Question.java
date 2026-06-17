package model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Questions")
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "QuestionID")
    private int questionId;

    @Column(name = "ResourceID")
    private Integer resourceId;

    @Column(name = "Content", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "QuestionType", nullable = false)
    private String questionType; // MultipleChoice, Matching, FillInBlanks

    @Column(name = "Skill", nullable = false)
    private String skill; // Listening, Reading, Writing, Speaking

    @Column(name = "Difficulty")
    private String difficulty; // Easy, Medium, Hard

    @Column(name = "Explanation", columnDefinition = "NVARCHAR(MAX)")
    private String explanation;

    @Column(name = "OrderInResource")
    private Integer orderInResource;

    @Column(name = "contentJSON", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String contentJson;

    @Column(name = "CreatedBy")
    private Integer createdBy;

    @Column(name = "Deleted")
    private boolean deleted = false;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    @JoinColumn(name = "QuestionID")
    private List<Answer> answers = new ArrayList<>();

    public Question() {}

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public Integer getResourceId() { return resourceId; }
    public void setResourceId(Integer resourceId) { this.resourceId = resourceId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getSkill() { return skill; }
    public void setSkill(String skill) { this.skill = skill; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }
    public Integer getOrderInResource() { return orderInResource; }
    public void setOrderInResource(Integer orderInResource) { this.orderInResource = orderInResource; }
    public String getContentJson() { return contentJson; }
    public void setContentJson(String contentJson) { this.contentJson = contentJson; }
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public boolean isDeleted() { return deleted; }
    public void setDeleted(boolean deleted) { this.deleted = deleted; }
    public List<Answer> getAnswers() { return answers; }
    public void setAnswers(List<Answer> answers) { this.answers = answers; }
}

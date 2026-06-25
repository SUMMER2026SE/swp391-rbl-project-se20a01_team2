package model;

import jakarta.persistence.*;

@Entity
@Table(name = "ExamQuestions")
@IdClass(ExamQuestionId.class)
public class ExamQuestion {

    @Id
    @Column(name = "SectionID")
    private int sectionId;

    @Id
    @Column(name = "QuestionID")
    private int questionId;

    @Column(name = "OrderIndex", nullable = false)
    private int orderIndex;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "QuestionID", insertable = false, updatable = false)
    private Question question;

    public ExamQuestion() {}

    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public int getOrderIndex() { return orderIndex; }
    public void setOrderIndex(int orderIndex) { this.orderIndex = orderIndex; }
    public Question getQuestion() { return question; }
    public void setQuestion(Question question) { this.question = question; }
}

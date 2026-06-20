package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Answers")
public class Answer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AnswerID")
    private int answerId;

    @Column(name = "Content", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "ContentJson", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String contentJson;

    @Column(name = "IsCorrect", nullable = false)
    private boolean correct = false;

    public Answer() {}

    public int getAnswerId() { return answerId; }
    public void setAnswerId(int answerId) { this.answerId = answerId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getContentJson() { return contentJson; }
    public void setContentJson(String contentJson) { this.contentJson = contentJson; }
    public boolean isCorrect() { return correct; }
    public void setCorrect(boolean correct) { this.correct = correct; }
}

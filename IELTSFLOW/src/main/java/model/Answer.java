package model;

/**
 * DTO: Đáp án của một câu hỏi (bảng Answers).
 */
public class Answer {
    private int answerId;
    private int questionId;
    private String content;
    private boolean isCorrect;

    public Answer() {}

    public Answer(int answerId, int questionId, String content, boolean isCorrect) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.content = content;
        this.isCorrect = isCorrect;
    }

    public int getAnswerId()             { return answerId; }
    public void setAnswerId(int v)       { this.answerId = v; }

    public int getQuestionId()           { return questionId; }
    public void setQuestionId(int v)     { this.questionId = v; }

    public String getContent()           { return content; }
    public void setContent(String v)     { this.content = v; }

    public boolean isCorrect()           { return isCorrect; }
    public void setCorrect(boolean v)    { this.isCorrect = v; }
}

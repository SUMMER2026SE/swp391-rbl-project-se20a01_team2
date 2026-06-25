package model;

import java.util.List;

/**
 * DTO chứa thông tin đánh giá từng câu hỏi của bài thi (Reading/Listening).
 * Dùng để hiển thị trang kết quả cho học viên biết câu nào đúng/sai.
 */
public class AnswerReviewItem {

    private int questionId;
    private String questionContent;   // Nội dung câu hỏi
    private String skill;             // Reading | Listening
    private String questionType;      // Multiple_Choice | FillInBlanks
    private String candidateAnswer;   // Đáp án thí sinh chọn
    private String correctAnswer;     // Đáp án đúng
    private boolean correct;          // Đúng hay sai
    private String explanation;       // Giải thích (nếu có)
    private List<String> options;     // Các lựa chọn (Multiple Choice)

    public AnswerReviewItem() {}

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public String getQuestionContent() { return questionContent; }
    public void setQuestionContent(String questionContent) { this.questionContent = questionContent; }

    public String getSkill() { return skill; }
    public void setSkill(String skill) { this.skill = skill; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public String getCandidateAnswer() { return candidateAnswer; }
    public void setCandidateAnswer(String candidateAnswer) { this.candidateAnswer = candidateAnswer; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public boolean isCorrect() { return correct; }
    public void setCorrect(boolean correct) { this.correct = correct; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
}

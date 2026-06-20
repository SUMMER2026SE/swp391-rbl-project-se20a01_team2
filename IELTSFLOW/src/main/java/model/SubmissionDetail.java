package model;

/**
 * DTO: Chi tiết câu trả lời của thí sinh trong một bài thi (bảng SubmissionDetails).
 */
public class SubmissionDetail {
    private int detailId;
    private int submissionId;
    private int questionId;
    private String candidateAnswer;
    private String speakingUrl;
    private String candidateTranscript;
    private Boolean isCorrect;
    private Double score;
    private String gradingStatus; // Pending_AI, Processing, Graded, Failed

    // Transient: thông tin câu hỏi (JOIN để hiển thị kết quả)
    private String questionContent;
    private String questionType;
    private String skill;
    private String correctAnswerContent;
    private String explanation;
    private String aiFeedbackJson;

    public SubmissionDetail() {}

    public int getDetailId()                        { return detailId; }
    public void setDetailId(int v)                  { this.detailId = v; }

    public int getSubmissionId()                    { return submissionId; }
    public void setSubmissionId(int v)              { this.submissionId = v; }

    public int getQuestionId()                      { return questionId; }
    public void setQuestionId(int v)                { this.questionId = v; }

    public String getCandidateAnswer()              { return candidateAnswer; }
    public void setCandidateAnswer(String v)        { this.candidateAnswer = v; }

    public String getSpeakingUrl()                  { return speakingUrl; }
    public void setSpeakingUrl(String v)            { this.speakingUrl = v; }

    public String getCandidateTranscript()          { return candidateTranscript; }
    public void setCandidateTranscript(String v)    { this.candidateTranscript = v; }

    public Boolean getIsCorrect()                   { return isCorrect; }
    public void setIsCorrect(Boolean v)             { this.isCorrect = v; }

    public Double getScore()                        { return score; }
    public void setScore(Double v)                  { this.score = v; }

    public String getGradingStatus()                { return gradingStatus; }
    public void setGradingStatus(String v)          { this.gradingStatus = v; }

    public String getQuestionContent()              { return questionContent; }
    public void setQuestionContent(String v)        { this.questionContent = v; }

    public String getQuestionType()                 { return questionType; }
    public void setQuestionType(String v)           { this.questionType = v; }

    public String getSkill()                        { return skill; }
    public void setSkill(String v)                  { this.skill = v; }

    public String getCorrectAnswerContent()         { return correctAnswerContent; }
    public void setCorrectAnswerContent(String v)   { this.correctAnswerContent = v; }

    public String getExplanation()                  { return explanation; }
    public void setExplanation(String v)            { this.explanation = v; }

    public String getAiFeedbackJson()               { return aiFeedbackJson; }
    public void setAiFeedbackJson(String v)         { this.aiFeedbackJson = v; }
}

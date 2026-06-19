package model;

import java.util.ArrayList;
import java.util.List;

/**
 * DTO: Câu hỏi trong đề thi (Questions JOIN Answers + QuestionResource).
 * Dùng cho Mock Test, Placement Test, Practice.
 */
public class Question {
    private int questionId;
    private Integer resourceId;
    private String content;
    private String questionType; // Multiple_Choice, Essay, Speaking, FillBlank
    private String skill;        // Listening, Reading, Writing, Speaking
    private String difficulty;   // Easy, Medium, Hard
    private String explanation;
    private Integer orderInResource;
    private String metadataJSON;
    private Integer createdBy;

    // Transient: danh sách đáp án
    private List<Answer> answers = new ArrayList<>();

    // Transient: tài nguyên đính kèm (bài đọc / audio)
    private String resourceText;
    private String resourceAudioUrl;

    public Question() {}

    public int getQuestionId()               { return questionId; }
    public void setQuestionId(int v)         { this.questionId = v; }

    public Integer getResourceId()           { return resourceId; }
    public void setResourceId(Integer v)     { this.resourceId = v; }

    public String getContent()               { return content; }
    public void setContent(String v)         { this.content = v; }

    public String getQuestionType()          { return questionType; }
    public void setQuestionType(String v)    { this.questionType = v; }

    public String getSkill()                 { return skill; }
    public void setSkill(String v)           { this.skill = v; }

    public String getDifficulty()            { return difficulty; }
    public void setDifficulty(String v)      { this.difficulty = v; }

    public String getExplanation()           { return explanation; }
    public void setExplanation(String v)     { this.explanation = v; }

    public Integer getOrderInResource()      { return orderInResource; }
    public void setOrderInResource(Integer v){ this.orderInResource = v; }

    public String getMetadataJSON()          { return metadataJSON; }
    public void setMetadataJSON(String v)    { this.metadataJSON = v; }

    public Integer getCreatedBy()            { return createdBy; }
    public void setCreatedBy(Integer v)      { this.createdBy = v; }

    public List<Answer> getAnswers()         { return answers; }
    public void setAnswers(List<Answer> v)   { this.answers = v; }

    public String getResourceText()          { return resourceText; }
    public void setResourceText(String v)    { this.resourceText = v; }

    public String getResourceAudioUrl()      { return resourceAudioUrl; }
    public void setResourceAudioUrl(String v){ this.resourceAudioUrl = v; }
}

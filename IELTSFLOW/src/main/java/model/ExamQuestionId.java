package model;

import java.io.Serializable;
import java.util.Objects;

public class ExamQuestionId implements Serializable {
    private int sectionId;
    private int questionId;

    public ExamQuestionId() {}
    public ExamQuestionId(int sectionId, int questionId) {
        this.sectionId = sectionId;
        this.questionId = questionId;
    }

    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ExamQuestionId that = (ExamQuestionId) o;
        return sectionId == that.sectionId && questionId == that.questionId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(sectionId, questionId);
    }
}

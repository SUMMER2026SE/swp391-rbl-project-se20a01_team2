package dao;

import model.Answer;
import model.Exam;
import model.Question;
import util.JpaHelper;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * DAO dùng JPA Native Query để xử lý Mock Test:
 * - Lấy đề thi ngẫu nhiên loại Mock Test
 * - Lấy câu hỏi + đáp án của đề thi (với shuffle ngẫu nhiên)
 */
public class MockExamDAO {

    /**
     * Lấy ngẫu nhiên 1 đề thi loại 'Mock Test'.
     */
    public Exam getRandomMockTest() {
        return JpaHelper.query(em -> {
            String sql = "SELECT TOP 1 ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt " +
                         "FROM Exams WHERE Type = 'Mock Test' AND (Deleted = 0 OR Deleted IS NULL) ORDER BY NEWID()";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql).getResultList();

            if (rows.isEmpty()) return null;
            return mapExam(rows.get(0));
        });
    }

    /**
     * Lấy ngẫu nhiên 1 đề thi loại 'Placement Test'.
     */
    public Exam getRandomPlacementTest() {
        return JpaHelper.query(em -> {
            String sql = "SELECT TOP 1 ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt " +
                         "FROM Exams WHERE Type = 'Placement Test' AND (Deleted = 0 OR Deleted IS NULL) ORDER BY NEWID()";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql).getResultList();

            if (rows.isEmpty()) return null;
            return mapExam(rows.get(0));
        });
    }

    /**
     * Lấy toàn bộ đề thi loại 'Mock Test'.
     */
    public List<Exam> getAllMockTests() {
        return JpaHelper.query(em -> {
            String sql = "SELECT ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt " +
                         "FROM Exams WHERE Type = 'Mock Test' AND (Deleted = 0 OR Deleted IS NULL) ORDER BY CreatedAt DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql).getResultList();

            List<Exam> exams = new ArrayList<>();
            for (Object[] row : rows) {
                exams.add(mapExam(row));
            }
            return exams;
        });
    }

    /**
     * Lấy đề thi theo ID.
     */
    public Exam getMockTestById(int examId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt " +
                         "FROM Exams WHERE ExamID = :examId AND (Deleted = 0 OR Deleted IS NULL)";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("examId", examId)
                    .getResultList();

            if (rows.isEmpty()) return null;
            return mapExam(rows.get(0));
        });
    }

    /**
     * Lấy toàn bộ câu hỏi (kèm đáp án) của một đề thi. (Không shuffle để giữ thứ tự section)
     */
    public List<Question> getQuestionsForExam(int examId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT q.QuestionID, q.ResourceID, q.Content, q.QuestionType, q.Skill, " +
                         "       q.Difficulty, q.Explanation, q.OrderInResource, q.contentJSON, " +
                         "       r.ResourceText, r.ResourceAudioURL " +
                         "FROM ExamSections es " +
                         "JOIN ExamQuestions eq ON es.SectionID = eq.SectionID " +
                         "JOIN Questions q ON eq.QuestionID = q.QuestionID " +
                         "LEFT JOIN QuestionResource r ON q.ResourceID = r.ResourceID " +
                         "WHERE es.ExamID = :examId ORDER BY es.OrderIndex, eq.OrderIndex";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("examId", examId)
                    .getResultList();

            List<Question> questions = new ArrayList<>();
            for (Object[] row : rows) {
                Question q = mapQuestion(row);
                q.setAnswers(getAnswersForQuestion(em, q.getQuestionId()));
                questions.add(q);
            }
            return questions;
        });
    }

    /**
     * Lấy toàn bộ Section của một đề thi, trong mỗi Section chứa danh sách câu hỏi.
     */
    public List<model.ExamSection> getSectionsWithQuestionsForExam(int examId) {
        return JpaHelper.query(em -> {
            // 1. Lấy danh sách sections (kèm resource)
            String sqlSec = "SELECT s.SectionID, s.ExamID, s.Skill, s.SectionName, s.ResourceID, s.OrderIndex, " +
                         "r.ResourceText, r.ResourceAudioUrl " +
                         "FROM ExamSections s " +
                         "LEFT JOIN QuestionResource r ON s.ResourceID = r.ResourceID " +
                         "WHERE s.ExamID = :examId ORDER BY s.OrderIndex";
            @SuppressWarnings("unchecked")
            List<Object[]> rowsSec = em.createNativeQuery(sqlSec)
                    .setParameter("examId", examId)
                    .getResultList();

            List<model.ExamSection> sections = new ArrayList<>();
            for (Object[] row : rowsSec) {
                model.ExamSection sec = new model.ExamSection();
                sec.setSectionId(((Number) row[0]).intValue());
                sec.setExamId(((Number) row[1]).intValue());
                sec.setSkill(row[2] != null ? row[2].toString() : "");
                sec.setSectionName(row[3] != null ? row[3].toString() : "");
                if (row[4] != null) sec.setResourceId(((Number) row[4]).intValue());
                sec.setOrderIndex(((Number) row[5]).intValue());
                if (row[6] != null) sec.setResourceText(row[6].toString());
                if (row[7] != null) sec.setResourceAudioUrl(row[7].toString());
                sections.add(sec);
            }

            // 2. Lấy câu hỏi cho từng section
            for (model.ExamSection sec : sections) {
                String sqlQ = "SELECT q.QuestionID, q.ResourceID, q.Content, q.QuestionType, q.Skill, " +
                              "       q.Difficulty, q.Explanation, q.OrderInResource, q.contentJSON, " +
                              "       r.ResourceText, r.ResourceAudioURL " +
                              "FROM ExamQuestions eq " +
                              "JOIN Questions q ON eq.QuestionID = q.QuestionID " +
                              "LEFT JOIN QuestionResource r ON q.ResourceID = r.ResourceID " +
                              "WHERE eq.SectionID = :sectionId ORDER BY eq.OrderIndex";
                @SuppressWarnings("unchecked")
                List<Object[]> rowsQ = em.createNativeQuery(sqlQ)
                        .setParameter("sectionId", sec.getSectionId())
                        .getResultList();

                List<model.ExamQuestion> examQuestions = new ArrayList<>();
                for (Object[] row : rowsQ) {
                    Question q = mapQuestion(row);
                    q.setAnswers(getAnswersForQuestion(em, q.getQuestionId()));
                    model.ExamQuestion eq = new model.ExamQuestion();
                    eq.setSectionId(sec.getSectionId());
                    eq.setQuestionId(q.getQuestionId());
                    eq.setQuestion(q);
                    examQuestions.add(eq);
                }
                sec.setExamQuestions(examQuestions);
            }
            return sections;
        });
    }

    @SuppressWarnings("unchecked")
    private List<Answer> getAnswersForQuestion(jakarta.persistence.EntityManager em, int questionId) {
        String sql = "SELECT AnswerID, QuestionID, Content, IsCorrect, ContentJson " +
                     "FROM Answers WHERE QuestionID = :questionId";
        List<Object[]> rows = em.createNativeQuery(sql)
                .setParameter("questionId", questionId)
                .getResultList();

        List<Answer> answers = new ArrayList<>();
        for (Object[] row : rows) {
            Answer a = new Answer();
            a.setAnswerId(toInt(row[0]));
            a.setQuestionId(toInt(row[1]));
            a.setContent(row[2] != null ? row[2].toString() : "");
            // SQL Server: IsCorrect là BIT → có thể là Boolean hoặc Boolean
            a.setCorrect(Boolean.TRUE.equals(row[3]) || Integer.valueOf(1).equals(row[3])
                    || (row[3] instanceof Number && ((Number) row[3]).intValue() == 1));
            a.setContentJson(row[4] != null ? row[4].toString() : null);
            answers.add(a);
        }
        return answers;
    }

    // ──── Mapper helpers ────────────────────────────────────────────────

    private Exam mapExam(Object[] row) {
        Exam e = new Exam();
        e.setExamId(toInt(row[0]));
        e.setTitle(row[1] != null ? row[1].toString() : "");
        e.setType(row[2] != null ? row[2].toString() : "");
        e.setSkillFocus(row[3] != null ? row[3].toString() : "All");
        e.setDuration(toInt(row[4]));
        if (row[5] != null) e.setMentorId(toInt(row[5]));
        if (row[6] instanceof Timestamp) e.setCreatedAt(((Timestamp) row[6]).toLocalDateTime());
        return e;
    }

    private Question mapQuestion(Object[] row) {
        Question q = new Question();
        q.setQuestionId(toInt(row[0]));
        if (row[1] != null) q.setResourceId(toInt(row[1]));
        q.setContent(row[2] != null ? row[2].toString() : "");
        q.setQuestionType(row[3] != null ? row[3].toString() : "");
        q.setSkill(row[4] != null ? row[4].toString() : "");
        q.setDifficulty(row[5] != null ? row[5].toString() : "");
        q.setExplanation(row[6] != null ? row[6].toString() : null);
        if (row[7] != null) q.setOrderInResource(toInt(row[7]));
        q.setMetadataJSON(row[8] != null ? row[8].toString() : null);
        q.setResourceText(row[9] != null ? row[9].toString() : null);
        q.setResourceAudioUrl(row[10] != null ? row[10].toString() : null);
        return q;
    }

    private int toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof BigDecimal) return ((BigDecimal) o).intValue();
        return ((Number) o).intValue();
    }
}

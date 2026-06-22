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
     * Lấy toàn bộ câu hỏi (kèm đáp án) của một đề thi, sau đó shuffle ngẫu nhiên.
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
                         "WHERE es.ExamID = :examId";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("examId", examId)
                    .getResultList();

            List<Question> questions = new ArrayList<>();
            for (Object[] row : rows) {
                Question q = mapQuestion(row);
                // Load đáp án cho từng câu hỏi
                q.setAnswers(getAnswersForQuestion(em, q.getQuestionId()));
                questions.add(q);
            }
            Collections.shuffle(questions);
            return questions;
        });
    }

    @SuppressWarnings("unchecked")
    private List<Answer> getAnswersForQuestion(jakarta.persistence.EntityManager em, int questionId) {
        String sql = "SELECT AnswerID, QuestionID, Content, IsCorrect " +
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

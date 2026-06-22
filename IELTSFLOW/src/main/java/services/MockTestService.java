package services;

import dao.MockExamDAO;
import dao.MockSubmissionDAO;
import model.Exam;
import model.Question;
import model.SubmissionDetail;
import model.TestSubmission;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

/**
 * Service cho Mock Test — chống gian lận, speech-to-text, chấm điểm AI.
 * Tách riêng để không xung đột với ExamService hiện tại của dự án.
 */
public class MockTestService {

    private static final int MAX_VIOLATIONS = 3;

    private final MockExamDAO examDAO = new MockExamDAO();
    private final MockSubmissionDAO submissionDAO = new MockSubmissionDAO();
    private final Random random = new Random();

    // ──── Exam retrieval ──────────────────────────────────────────────

    /** Lấy ngẫu nhiên 1 đề Mock Test. */
    public Exam getRandomMockTest() {
        return examDAO.getRandomMockTest();
    }

    /** Lấy ngẫu nhiên 1 đề Placement Test. */
    public Exam getRandomPlacementTest() {
        return examDAO.getRandomPlacementTest();
    }

    /** Lấy toàn bộ câu hỏi (đã shuffle) của một đề thi. */
    public List<Question> getQuestionsForExam(int examId) {
        return examDAO.getQuestionsForExam(examId);
    }

    // ──── Submission lifecycle ────────────────────────────────────────

    /** Tạo bài làm mới (bắt đầu thi). Trả về submissionId. */
    public int createSubmission(int userId, int examId) {
        TestSubmission sub = new TestSubmission();
        sub.setUserId(userId);
        sub.setExamId(examId);
        sub.setStartTime(LocalDateTime.now());
        return submissionDAO.createSubmission(sub);
    }

    /** Lưu một câu trả lời. Trả về detailId. */
    public int saveDetail(SubmissionDetail detail) {
        return submissionDAO.saveDetail(detail);
    }

    /** Hoàn tất bài làm với điểm band score. */
    public void finaliseSubmission(TestSubmission sub) {
        submissionDAO.finaliseSubmission(sub);
    }

    /** Tăng vi phạm chống gian lận. Trả về số vi phạm mới. */
    public int incrementViolation(int submissionId) {
        return submissionDAO.incrementViolation(submissionId, MAX_VIOLATIONS);
    }

    /** Lấy bài làm theo ID. */
    public TestSubmission getSubmissionById(int submissionId) {
        return submissionDAO.getSubmissionById(submissionId);
    }

    public int getMaxViolations() {
        return MAX_VIOLATIONS;
    }

    /** Lấy tất cả bài làm của user. */
    public List<TestSubmission> getSubmissionsByUser(int userId) {
        return submissionDAO.getSubmissionsByUser(userId);
    }

    // ──── Grading logic ───────────────────────────────────────────────

    /**
     * Kiểm tra đáp án trắc nghiệm/điền vào chỗ trống.
     */
    public boolean isAnswerCorrect(Question q, String candidateAnswer) {
        if (candidateAnswer == null || candidateAnswer.isBlank()) return false;
        for (model.Answer a : q.getAnswers()) {
            if (a.isCorrect() && candidateAnswer.equalsIgnoreCase(a.getContent().trim())) return true;
            try {
                if (a.isCorrect() && a.getAnswerId() == Integer.parseInt(candidateAnswer.trim())) return true;
            } catch (NumberFormatException ignored) {}
        }
        return false;
    }

    /**
     * Chấm điểm AI giả lập cho Writing/Speaking.
     * Lưu điểm vào SubmissionDetails + tạo bản ghi AIEvaluations.
     */
    public double gradeSubjectiveAnswer(int detailId, String skill, String answerContent) {
        double[] possibleBands = {5.5, 6.0, 6.5, 7.0, 7.5, 8.0};
        double score = possibleBands[random.nextInt(possibleBands.length)];

        String feedbackJson = "Writing".equals(skill)
                ? "{\"TaskResponse\":\"Good effort.\",\"Coherence\":\"Logical.\",\"EstimatedBand\":" + score + "}"
                : "{\"Fluency\":\"Generally fluent.\",\"Grammar\":\"Good.\",\"EstimatedBand\":" + score + "}";

        // Lưu điểm và AI Feedback vào DB qua JPA native query
        try {
            util.JpaHelper.execute(em -> {
                em.createNativeQuery(
                        "UPDATE SubmissionDetails SET Score=:score, GradingStatus='Graded' WHERE DetailID=:id")
                        .setParameter("score", score)
                        .setParameter("id", detailId)
                        .executeUpdate();

                em.createNativeQuery(
                        "INSERT INTO AIEvaluations (DetailID, FeedbackJSON) VALUES (:id, :feedback)")
                        .setParameter("id", detailId)
                        .setParameter("feedback", feedbackJson)
                        .executeUpdate();
            });
        } catch (Exception e) {
            System.err.println("[MockTestService] Lỗi khi lưu AI evaluation: " + e.getMessage());
        }

        return score;
    }

    // ──── Band score calculation ──────────────────────────────────────

    /** Chuyển % đúng sang thang band IELTS. */
    public double rawToBand(int correct, int total) {
        if (total == 0) return 0;
        double pct = (double) correct / total;
        if (pct >= 0.97) return 9.0; if (pct >= 0.93) return 8.5;
        if (pct >= 0.87) return 8.0; if (pct >= 0.80) return 7.5;
        if (pct >= 0.73) return 7.0; if (pct >= 0.67) return 6.5;
        if (pct >= 0.60) return 6.0; if (pct >= 0.53) return 5.5;
        if (pct >= 0.47) return 5.0; if (pct >= 0.40) return 4.5;
        if (pct >= 0.33) return 4.0; if (pct >= 0.27) return 3.5;
        if (pct >= 0.20) return 3.0; return 2.5;
    }

    /** Tính Overall Band (làm tròn 0.5). */
    public Double calcOverall(Double l, Double r, Double w, Double s) {
        double sum = 0; int count = 0;
        if (l != null) { sum += l; count++; }
        if (r != null) { sum += r; count++; }
        if (w != null) { sum += w; count++; }
        if (s != null) { sum += s; count++; }
        if (count == 0) return null;
        return Math.round((sum / count) * 2) / 2.0;
    }
}

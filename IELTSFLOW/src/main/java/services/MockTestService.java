package services;

import dao.MockExamDAO;
import dao.MockSubmissionDAO;
import model.Exam;
import model.Question;
import model.SubmissionDetail;
import model.TestSubmission;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Random;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
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

    /** Lấy toàn bộ Section của một đề thi. */
    public List<model.ExamSection> getSectionsWithQuestionsForExam(int examId) {
        return examDAO.getSectionsWithQuestionsForExam(examId);
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
     * Hỗ trợ đáp án đơn (String bình thường) hoặc mảng nhiều đáp án (JSON Array).
     * Trả về số lượng đáp án đúng (tối đa bằng questionCount).
     */
    public int isAnswerCorrect(Question q, String candidateAnswer) {
        if (candidateAnswer == null || candidateAnswer.isBlank()) return 0;
        
        // Handle JSON array (nhiều đáp án/ô trống)
        if (candidateAnswer.trim().startsWith("[")) {
            System.out.println("[MockTestService] NEW GRADING ENGINE RUNNING! qType: " + q.getQuestionType() + " | answer: " + candidateAnswer);
            int correctCount = 0;
            try {
                ObjectMapper mapper = new ObjectMapper();
                List<String> answers = mapper.readValue(candidateAnswer, new TypeReference<List<String>>(){});
                
                if ("FillInBlanks".equals(q.getQuestionType()) || "FillBlank".equals(q.getQuestionType()) || "Matching".equals(q.getQuestionType())) {
                    if (q.getAnswers() != null && !q.getAnswers().isEmpty()) {
                        model.Answer correctAns = q.getAnswers().get(0);
                        if (correctAns.getContentJson() != null && !correctAns.getContentJson().isBlank()) {
                            Map<String, List<String>> answerMap = mapper.readValue(correctAns.getContentJson(), new TypeReference<Map<String, List<String>>>(){});
                            for (int i = 0; i < answers.size(); i++) {
                                String uAns = answers.get(i);
                                if (uAns == null || uAns.trim().isEmpty()) continue;
                                String blankKey = String.valueOf(i + 1);
                                List<String> validOptions = answerMap.get(blankKey);
                                if (validOptions != null) {
                                    for (String validOpt : validOptions) {
                                        if (uAns.trim().equalsIgnoreCase(validOpt.trim())) {
                                            correctCount++;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return Math.min(correctCount, q.getQuestionCount());
                }

                for (String ans : answers) {
                    if (ans == null || ans.isBlank()) continue;
                    for (model.Answer a : q.getAnswers()) {
                        if (a.isCorrect() && ans.equalsIgnoreCase(a.getContent().trim())) {
                            correctCount++;
                            break;
                        }
                        try {
                            if (a.isCorrect() && a.getAnswerId() == Integer.parseInt(ans.trim())) {
                                correctCount++;
                                break;
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                }
                return Math.min(correctCount, q.getQuestionCount());
            } catch (Exception e) {
                System.err.println("[MockTestService] Lỗi parse JSON array đáp án: " + e.getMessage());
                // Fallback xuống logic đáp án đơn bên dưới
            }
        }
        
        // Single answer logic
        for (model.Answer a : q.getAnswers()) {
            if (a.isCorrect() && candidateAnswer.equalsIgnoreCase(a.getContent().trim())) return 1;
            try {
                if (a.isCorrect() && a.getAnswerId() == Integer.parseInt(candidateAnswer.trim())) return 1;
            } catch (NumberFormatException ignored) {}
        }
        return 0;
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

    /** Chuyển % đúng sang thang band IELTS quy đổi về thang 40 câu. */
    public double rawToBand(int correct, int total) {
        if (total == 0) return 0.0;
        
        int equivalentCorrect = (int) Math.round(((double) correct / total) * 40.0);
        
        if (equivalentCorrect >= 39) return 9.0;
        if (equivalentCorrect >= 37) return 8.5;
        if (equivalentCorrect >= 35) return 8.0;
        if (equivalentCorrect >= 33) return 7.5;
        if (equivalentCorrect >= 30) return 7.0;
        if (equivalentCorrect >= 27) return 6.5;
        if (equivalentCorrect >= 23) return 6.0;
        if (equivalentCorrect >= 19) return 5.5;
        if (equivalentCorrect >= 15) return 5.0;
        if (equivalentCorrect >= 13) return 4.5;
        if (equivalentCorrect >= 10) return 4.0;
        if (equivalentCorrect >= 8)  return 3.5;
        if (equivalentCorrect >= 6)  return 3.0;
        if (equivalentCorrect >= 4)  return 2.5;
        if (equivalentCorrect >= 2)  return 2.0;
        if (equivalentCorrect >= 1)  return 1.0;
        return 0.0;
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

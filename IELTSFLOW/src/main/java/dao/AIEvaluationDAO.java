package dao;

import jakarta.persistence.Query;
import model.AIEvaluation;
import util.JpaHelper;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AIEvaluationDAO {
    private static final Logger LOGGER = Logger.getLogger(AIEvaluationDAO.class.getName());

    public AIEvaluationDAO() {
    }

    /**
     * Thêm một kết quả đánh giá bằng AI vào database
     *
     * @param detailId     ID của chi tiết bài làm
     * @param feedbackJson JSON feedback trả về từ AI
     * @return true nếu thêm thành công
     */
    public boolean insertAIEvaluation(int detailId, String feedbackJson) {
        try {
            JpaHelper.execute(em -> {
                String sql = "INSERT INTO AIEvaluations (DetailID, FeedbackJSON) VALUES (?1, ?2)";
                Query query = em.createNativeQuery(sql);
                query.setParameter(1, detailId);
                query.setParameter(2, feedbackJson);
                
                int updatedCount = query.executeUpdate();
                LOGGER.log(Level.INFO, "Đã lưu AI Evaluation cho detailId {0} (Affected rows: {1})", new Object[]{detailId, updatedCount});
            });
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu AIEvaluation cho detailId " + detailId, e);
            return false;
        }
    }

    /**
     * Cập nhật điểm Band và Feedback AI tổng hợp vào TestSubmissions
     * 
     * @param detailId ID của chi tiết bài làm
     * @param bandScore Điểm Overall của kỹ năng đó
     * @param skillType Loại kỹ năng (Writing / Speaking)
     * @param aiFeedback Lời nhận xét chung
     * @return true nếu cập nhật thành công
     */
    public boolean updateTestSubmissionBand(int detailId, double bandScore, String skillType, String aiFeedback) {
        try {
            JpaHelper.execute(em -> {
                String columnToUpdate = skillType.equalsIgnoreCase("Writing") ? "WritingBand" : "SpeakingBand";
                
                // Sử dụng subquery để tìm SubmissionID từ DetailID
                int subId = (Integer) em.createNativeQuery("SELECT SubmissionID FROM SubmissionDetails WHERE DetailID = ?1")
                                        .setParameter(1, detailId)
                                        .getSingleResult();

                String sql = "UPDATE TestSubmissions " +
                             "SET " + columnToUpdate + " = (CASE WHEN " + columnToUpdate + " IS NULL THEN CAST(?1 AS FLOAT) ELSE (" + columnToUpdate + " + CAST(?1 AS FLOAT)) / 2.0 END), " +
                             "    OverallAIFeedback = CASE " +
                             "        WHEN CHARINDEX('[" + skillType + " Feedback]', ISNULL(OverallAIFeedback, '')) > 0 THEN OverallAIFeedback " +
                             "        ELSE CONCAT(ISNULL(OverallAIFeedback, ''), CHAR(13), CHAR(10), ?2) " +
                             "    END " +
                             "WHERE SubmissionID = ?3";
                             
                Query query = em.createNativeQuery(sql);
                query.setParameter(1, bandScore);
                query.setParameter(2, "[" + skillType + " Feedback]: " + aiFeedback);
                query.setParameter(3, subId);
                
                int updatedCount = query.executeUpdate();
                
                // Cập nhật lại OverallBand
                String recalcSql = "UPDATE TestSubmissions SET OverallBand = ROUND((ISNULL(ListeningBand, 0) + ISNULL(ReadingBand, 0) + ISNULL(WritingBand, 0) + ISNULL(SpeakingBand, 0)) * 2.0 / " +
                                   "NULLIF((CASE WHEN ListeningBand IS NOT NULL THEN 1 ELSE 0 END + CASE WHEN ReadingBand IS NOT NULL THEN 1 ELSE 0 END + CASE WHEN WritingBand IS NOT NULL THEN 1 ELSE 0 END + CASE WHEN SpeakingBand IS NOT NULL THEN 1 ELSE 0 END), 0), 0) / 2.0 " +
                                   "WHERE SubmissionID = (SELECT SubmissionID FROM SubmissionDetails WHERE DetailID = ?1)";
                Query recalcQuery = em.createNativeQuery(recalcSql);
                recalcQuery.setParameter(1, detailId);
                recalcQuery.executeUpdate();
                
                LOGGER.log(Level.INFO, "Đã cập nhật {0} = {1} và OverallBand cho TestSubmission từ detailId {2} (Affected rows: {3})", 
                        new Object[]{columnToUpdate, bandScore, detailId, updatedCount});
            });
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật TestSubmission band cho detailId " + detailId, e);
            return false;
        }
    }

    /**
     * Lấy danh sách Feedback JSON của một Submission.
     */
    public java.util.List<String> getFeedbackJsonStringsBySubmissionId(int submissionId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT e.FeedbackJSON " +
                         "FROM AIEvaluations e " +
                         "JOIN SubmissionDetails d ON e.DetailID = d.DetailID " +
                         "WHERE d.SubmissionID = ?1 " +
                         "ORDER BY d.DetailID ASC";
            Query query = em.createNativeQuery(sql);
            query.setParameter(1, submissionId);
            @SuppressWarnings("unchecked")
            java.util.List<String> list = query.getResultList();
            return list;
        });
    }

    /**
     * Lấy danh sách đánh giá câu hỏi Reading/Listening cho trang kết quả.
     * Dùng 2 query riêng biệt để tránh STRING_AGG (yêu cầu SQL Server 2017+)
     * và tránh ClassCastException với kiểu bit.
     */
    public java.util.List<model.AnswerReviewItem> getAnswerReviewBySubmissionId(int submissionId) {
        try {
            return JpaHelper.query(em -> {
                // Query 1: Lấy từng câu hỏi + trạng thái đúng/sai + đáp án đúng
                String sql =
                    "SELECT q.QuestionID, q.Content, q.Skill, q.QuestionType, " +
                    "       sd.CandidateAnswer, sd.IsCorrect, q.Explanation, " +
                    "       (SELECT TOP 1 a.Content FROM Answers a " +
                    "        WHERE a.QuestionID = q.QuestionID AND a.IsCorrect = 1) AS CorrectAnswer " +
                    "FROM SubmissionDetails sd " +
                    "JOIN Questions q ON sd.QuestionID = q.QuestionID " +
                    "WHERE sd.SubmissionID = ?1 " +
                    "  AND q.Skill IN ('Reading', 'Listening') " +
                    "  AND q.QuestionType IN ('Multiple_Choice', 'FillInBlanks', 'FillBlank') " +
                    "ORDER BY q.Skill DESC, sd.DetailID ASC";

                Query query = em.createNativeQuery(sql);
                query.setParameter(1, submissionId);
                @SuppressWarnings("unchecked")
                java.util.List<Object[]> rows = query.getResultList();

                java.util.List<model.AnswerReviewItem> result = new java.util.ArrayList<>();
                for (Object[] row : rows) {
                    model.AnswerReviewItem item = new model.AnswerReviewItem();
                    item.setQuestionId(row[0] != null ? ((Number) row[0]).intValue() : 0);
                    item.setQuestionContent(row[1] != null ? row[1].toString() : "");
                    item.setSkill(row[2] != null ? row[2].toString() : "");
                    item.setQuestionType(row[3] != null ? row[3].toString() : "");
                    item.setCandidateAnswer(row[4] != null ? row[4].toString() : "");

                    // SQL Server trả 'bit' về Boolean hoặc Integer — xử lý cả 2 trường hợp
                    Object isCorrectObj = row[5];
                    if (isCorrectObj instanceof Boolean) {
                        item.setCorrect((Boolean) isCorrectObj);
                    } else if (isCorrectObj instanceof Number) {
                        item.setCorrect(((Number) isCorrectObj).intValue() == 1);
                    } else {
                        item.setCorrect(false);
                    }

                    item.setExplanation(row[6] != null ? row[6].toString() : "");
                    item.setCorrectAnswer(row[7] != null ? row[7].toString() : "");
                    result.add(item);
                }

                // Query 2: Lấy các lựa chọn (options) cho từng câu hỏi Multiple Choice
                // Chỉ load nếu có câu hỏi
                if (!result.isEmpty()) {
                    // Build danh sách questionId cần lấy options
                    java.util.Set<Integer> mcQids = new java.util.HashSet<>();
                    for (model.AnswerReviewItem item : result) {
                        if ("Multiple_Choice".equals(item.getQuestionType())) {
                            mcQids.add(item.getQuestionId());
                        }
                    }
                    if (!mcQids.isEmpty()) {
                        String qidList = mcQids.stream()
                            .map(String::valueOf)
                            .collect(java.util.stream.Collectors.joining(","));
                        String optSql = "SELECT a.QuestionID, a.Content FROM Answers a " +
                                        "WHERE a.QuestionID IN (" + qidList + ") ORDER BY a.AnswerID";
                        @SuppressWarnings("unchecked")
                        java.util.List<Object[]> optRows = em.createNativeQuery(optSql).getResultList();

                        // Group options theo QuestionID
                        java.util.Map<Integer, java.util.List<String>> optMap = new java.util.HashMap<>();
                        for (Object[] optRow : optRows) {
                            int qid = ((Number) optRow[0]).intValue();
                            String content = optRow[1] != null ? optRow[1].toString() : "";
                            optMap.computeIfAbsent(qid, k -> new java.util.ArrayList<>()).add(content);
                        }
                        // Gán options vào item
                        for (model.AnswerReviewItem item : result) {
                            java.util.List<String> opts = optMap.get(item.getQuestionId());
                            if (opts != null) item.setOptions(opts);
                        }
                    }
                }

                return result;
            });
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy answer review cho submissionId " + submissionId, e);
            return new java.util.ArrayList<>(); // Trả về list rỗng thay vì throw exception
        }
    }

    /**
     * Lấy toàn bộ FeedbackJSON và Skill của các bài đã được AI chấm,
     * thuộc các đề thi do mentor tạo.
     * @return List of Object[]{feedbackJson (String), skill (String)}
     */
    public java.util.List<Object[]> getAllFeedbackByMentor(int mentorId) {
        try {
            return JpaHelper.query(em -> {
                String sql =
                    "SELECT ae.FeedbackJSON, sd.Skill " +
                    "FROM AIEvaluations ae " +
                    "JOIN SubmissionDetails sd ON ae.DetailID = sd.DetailID " +
                    "JOIN TestSubmissions ts ON sd.SubmissionID = ts.SubmissionID " +
                    "JOIN Exams e ON ts.ExamID = e.ExamID " +
                    "WHERE e.MentorID = ?1 " +
                    "  AND e.Deleted = 0 " +
                    "  AND sd.Skill IN ('Writing', 'Speaking') " +
                    "  AND ae.FeedbackJSON IS NOT NULL";
                @SuppressWarnings("unchecked")
                java.util.List<Object[]> result = em.createNativeQuery(sql)
                         .setParameter(1, mentorId)
                         .getResultList();
                return result;
            });
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy feedback theo mentorId " + mentorId, e);
            return new java.util.ArrayList<>();
        }
    }
}

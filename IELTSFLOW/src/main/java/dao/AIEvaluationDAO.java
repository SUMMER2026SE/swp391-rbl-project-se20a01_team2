package dao;

import jakarta.persistence.Query;
import model.AIEvaluation;
import util.JpaHelper;

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
}

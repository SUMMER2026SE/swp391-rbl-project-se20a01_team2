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
                String sql = "UPDATE TestSubmissions " +
                             "SET " + columnToUpdate + " = ?1, " +
                             "    OverallAIFeedback = CONCAT(ISNULL(OverallAIFeedback, ''), CHAR(13), CHAR(10), ?2) " +
                             "WHERE SubmissionID = (SELECT SubmissionID FROM SubmissionDetails WHERE DetailID = ?3)";
                             
                Query query = em.createNativeQuery(sql);
                query.setParameter(1, bandScore);
                query.setParameter(2, "[" + skillType + " Feedback]: " + aiFeedback);
                query.setParameter(3, detailId);
                
                int updatedCount = query.executeUpdate();
                LOGGER.log(Level.INFO, "Đã cập nhật {0} = {1} cho TestSubmission từ detailId {2} (Affected rows: {3})", 
                        new Object[]{columnToUpdate, bandScore, detailId, updatedCount});
            });
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật TestSubmission band cho detailId " + detailId, e);
            return false;
        }
    }
}

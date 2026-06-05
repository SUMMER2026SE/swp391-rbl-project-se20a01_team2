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
}

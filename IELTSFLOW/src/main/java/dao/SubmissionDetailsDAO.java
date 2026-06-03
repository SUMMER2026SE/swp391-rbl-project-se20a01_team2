package dao;

import jakarta.persistence.Query;
import util.JpaHelper;

public class SubmissionDetailsDAO {

    public SubmissionDetailsDAO() {
    }

    /**
     * Cập nhật kết quả chấm điểm Speaking và Transcript từ Azure vào Database (Task 55 & 60)
     * 
     * @param detailId ID của chi tiết bài làm
     * @param transcript Chuỗi văn bản STT trả về
     * @param azureScore Điểm phát âm từ Azure (thang 100)
     * @return true nếu update thành công
     */
    public boolean updateSpeakingEvaluation(int detailId, String transcript, double azureScore) {
        // Quy đổi điểm từ thang 100 của Azure sang Band IELTS (0 - 9.0)
        double ieltsBand = convertAzureScoreToIeltsBand(azureScore);

        try {
            JpaHelper.execute(em -> {
                String sql = "UPDATE SubmissionDetails " +
                             "SET CandidateTranscript = :transcript, " +
                             "Score = :score, " +
                             "GradingStatus = 'Graded' " +
                             "WHERE DetailID = :detailId";
                Query query = em.createNativeQuery(sql);
                query.setParameter("transcript", transcript);
                query.setParameter("score", ieltsBand);
                query.setParameter("detailId", detailId);
                
                int updatedCount = query.executeUpdate();
                System.out.println("Đã lưu transcript và cập nhật điểm " + ieltsBand + " cho detailId " + detailId + " (Affected rows: " + updatedCount + ")");
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Hàm tiện ích giúp quy đổi điểm Azure sang Band điểm IELTS (Mapping Rule cơ bản)
     */
    private double convertAzureScoreToIeltsBand(double azureScore) {
        if (azureScore >= 95) return 9.0;
        if (azureScore >= 89) return 8.5;
        if (azureScore >= 83) return 8.0;
        if (azureScore >= 77) return 7.5;
        if (azureScore >= 71) return 7.0;
        if (azureScore >= 65) return 6.5;
        if (azureScore >= 59) return 6.0;
        if (azureScore >= 53) return 5.5;
        if (azureScore >= 47) return 5.0;
        if (azureScore >= 41) return 4.5;
        if (azureScore >= 35) return 4.0;
        return 3.0; // Dưới mức này cho mặc định band thấp nhất
    }
}

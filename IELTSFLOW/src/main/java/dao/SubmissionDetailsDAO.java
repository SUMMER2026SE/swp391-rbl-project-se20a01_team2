package dao;

import jakarta.persistence.Query;
import util.JpaHelper;

public class SubmissionDetailsDAO {

    public SubmissionDetailsDAO() {
    }

    /**
     * Lấy danh sách đếm số lỗi làm sai theo từng Tag của một bài test
     */
    public java.util.Map<String, Integer> getWrongTagsCountBySubmissionId(int submissionId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT t.Name, COUNT(sd.DetailID) " +
                         "FROM SubmissionDetails sd " +
                         "JOIN QuestionTags qt ON sd.QuestionID = qt.QuestionID " +
                         "JOIN Tags t ON qt.TagID = t.TagID " +
                         "WHERE sd.SubmissionID = :subId AND sd.IsCorrect = 0 " +
                         "GROUP BY t.Name";
            
            @SuppressWarnings("unchecked")
            java.util.List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("subId", submissionId)
                    .getResultList();
                    
            java.util.Map<String, Integer> wrongTagsCount = new java.util.HashMap<>();
            for (Object[] row : rows) {
                if (row[0] != null && row[1] != null) {
                    wrongTagsCount.put(row[0].toString(), ((Number) row[1]).intValue());
                }
            }
            return wrongTagsCount;
        });
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
    
    /**
     * Lấy nội dung đề bài (Topic) dựa vào DetailID
     */
    public String getQuestionContentByDetailId(int detailId) {
        try {
            return JpaHelper.query(em -> {
                String sql = "SELECT q.Content FROM SubmissionDetails sd " +
                             "JOIN Questions q ON sd.QuestionID = q.QuestionID " +
                             "WHERE sd.DetailID = :detailId";
                Query query = em.createNativeQuery(sql);
                query.setParameter("detailId", detailId);
                Object result = query.getSingleResult();
                return result != null ? result.toString() : null;
            });
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy Question Content cho DetailID " + detailId + ": " + e.getMessage());
            return null;
        }
    }

    /**
     * Cập nhật điểm và nhận xét của Mentor đè lên AI
     */
    public boolean updateMentorOverride(int detailId, double mentorScore, String mentorFeedback) {
        try {
            JpaHelper.execute(em -> {
                String sql = "UPDATE SubmissionDetails " +
                             "SET MentorScore = :mentorScore, " +
                             "MentorFeedback = :mentorFeedback " +
                             "WHERE DetailID = :detailId";
                Query query = em.createNativeQuery(sql);
                query.setParameter("mentorScore", mentorScore);
                query.setParameter("mentorFeedback", mentorFeedback);
                query.setParameter("detailId", detailId);
                query.executeUpdate();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách SubmissionDetails của bài thi cho Mentor
     */
    public java.util.List<model.SubmissionDetail> getDetailsBySubmissionId(int submissionId) {
        try {
            return JpaHelper.query(em -> {
                String sql = "SELECT sd.DetailID, sd.SubmissionID, sd.QuestionID, sd.CandidateAnswer, " +
                             "sd.SpeakingUrl, sd.CandidateTranscript, sd.IsCorrect, sd.Score, sd.GradingStatus, " +
                             "sd.MentorScore, sd.MentorFeedback, " +
                             "q.Content AS QuestionContent, q.QuestionType, q.Skill, " +
                             "(SELECT TOP 1 a.Content FROM Answers a WHERE a.QuestionID = q.QuestionID AND a.IsCorrect = 1) AS CorrectAnswerContent, " +
                             "q.Explanation, " +
                             "(SELECT TOP 1 ae.FeedbackJSON FROM AIEvaluations ae WHERE ae.DetailID = sd.DetailID ORDER BY ae.EvaluationID DESC) AS AiFeedbackJson " +
                             "FROM SubmissionDetails sd " +
                             "JOIN Questions q ON sd.QuestionID = q.QuestionID " +
                             "WHERE sd.SubmissionID = :submissionId " +
                             "ORDER BY q.Skill DESC, sd.DetailID ASC";
                Query query = em.createNativeQuery(sql);
                query.setParameter("submissionId", submissionId);
                
                @SuppressWarnings("unchecked")
                java.util.List<Object[]> rows = query.getResultList();
                java.util.List<model.SubmissionDetail> list = new java.util.ArrayList<>();
                
                for (Object[] row : rows) {
                    model.SubmissionDetail sd = new model.SubmissionDetail();
                    sd.setDetailId(row[0] != null ? ((Number) row[0]).intValue() : 0);
                    sd.setSubmissionId(row[1] != null ? ((Number) row[1]).intValue() : 0);
                    sd.setQuestionId(row[2] != null ? ((Number) row[2]).intValue() : 0);
                    sd.setCandidateAnswer(row[3] != null ? row[3].toString() : null);
                    sd.setSpeakingUrl(row[4] != null ? row[4].toString() : null);
                    sd.setCandidateTranscript(row[5] != null ? row[5].toString() : null);
                    
                    Object isCorrectObj = row[6];
                    if (isCorrectObj != null) {
                        if (isCorrectObj instanceof Boolean) sd.setIsCorrect((Boolean) isCorrectObj);
                        else if (isCorrectObj instanceof Number) sd.setIsCorrect(((Number) isCorrectObj).intValue() == 1);
                    }
                    
                    sd.setScore(row[7] != null ? ((Number) row[7]).doubleValue() : null);
                    sd.setGradingStatus(row[8] != null ? row[8].toString() : null);
                    sd.setMentorScore(row[9] != null ? ((Number) row[9]).doubleValue() : null);
                    sd.setMentorFeedback(row[10] != null ? row[10].toString() : null);
                    
                    sd.setQuestionContent(row[11] != null ? row[11].toString() : null);
                    sd.setQuestionType(row[12] != null ? row[12].toString() : null);
                    sd.setSkill(row[13] != null ? row[13].toString() : null);
                    sd.setCorrectAnswerContent(row[14] != null ? row[14].toString() : null);
                    sd.setExplanation(row[15] != null ? row[15].toString() : null);
                    sd.setAiFeedbackJson(row[16] != null ? row[16].toString() : null);
                    
                    list.add(sd);
                }
                return list;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}

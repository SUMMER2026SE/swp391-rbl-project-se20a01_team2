package services;

public interface SubmissionService {
    /**
     * Cập nhật kết quả chấm điểm Speaking và Transcript từ Azure vào Database
     * @param detailId ID của chi tiết bài làm
     * @param transcript Chuỗi văn bản STT trả về
     * @param azureScore Điểm phát âm từ Azure (thang 100)
     * @return true nếu update thành công
     */
    boolean updateSpeakingEvaluation(int detailId, String transcript, double azureScore);
}

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
    
    /**
     * Lấy nội dung đề bài (Topic) để cung cấp cho quá trình chấm điểm AI
     * @param detailId ID của chi tiết bài làm
     * @return Nội dung đề bài
     */
    String getQuestionContentByDetailId(int detailId);
}

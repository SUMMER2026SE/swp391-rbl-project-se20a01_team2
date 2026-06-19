package services;

import model.TestSubmission;
import java.util.List;

/**
 * Service: Cung cấp dữ liệu lịch sử bài thi và thống kê Band Score cho Candidate.
 */
public interface ExamHistoryService {

    /**
     * Lấy toàn bộ lịch sử bài thi của user (mọi trạng thái), mới nhất trước.
     */
    List<TestSubmission> getSubmissionsByUser(int userId);

    /**
     * Lấy danh sách bài thi đã hoàn thành (Completed/Abandoned) theo thời gian tăng dần,
     * dùng để render biểu đồ tiến độ Band Score.
     */
    List<TestSubmission> getCompletedSubmissionsForChart(int userId);

    /**
     * Tính band trung bình từ danh sách bài thi đã hoàn thành.
     */
    double getAverageBand(List<TestSubmission> completed);

    /**
     * Lấy band cao nhất từ danh sách bài thi đã hoàn thành.
     */
    double getMaxBand(List<TestSubmission> completed);
}

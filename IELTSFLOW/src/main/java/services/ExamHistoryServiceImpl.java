package services;

import dao.ExamHistoryDAO;
import model.TestSubmission;

import java.util.List;

/**
 * Implementation của ExamHistoryService.
 * Dùng ExamHistoryDAO để truy vấn dữ liệu từ DB.
 */
public class ExamHistoryServiceImpl implements ExamHistoryService {

    private final ExamHistoryDAO examHistoryDAO;

    public ExamHistoryServiceImpl() {
        this.examHistoryDAO = new ExamHistoryDAO();
    }

    @Override
    public List<TestSubmission> getSubmissionsByUser(int userId) {
        return examHistoryDAO.getSubmissionsByUser(userId);
    }

    @Override
    public List<TestSubmission> getCompletedSubmissionsForChart(int userId) {
        return examHistoryDAO.getCompletedSubmissionsForChart(userId);
    }

    @Override
    public double getAverageBand(List<TestSubmission> completed) {
        return completed.stream()
                .filter(s -> s.getOverallBand() != null)
                .mapToDouble(TestSubmission::getOverallBand)
                .average()
                .orElse(0.0);
    }

    @Override
    public double getMaxBand(List<TestSubmission> completed) {
        return completed.stream()
                .filter(s -> s.getOverallBand() != null)
                .mapToDouble(TestSubmission::getOverallBand)
                .max()
                .orElse(0.0);
    }
}

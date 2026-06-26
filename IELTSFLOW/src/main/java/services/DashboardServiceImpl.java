package services;

import dao.DashboardDAO;
import services.DashboardService;

import java.math.BigDecimal;

public class DashboardServiceImpl implements DashboardService {
    private DashboardDAO dashboardDAO;

    public DashboardServiceImpl() {
        this.dashboardDAO = new DashboardDAO();
    }

    @Override
    public BigDecimal getTotalRevenue() {
        return dashboardDAO.getTotalRevenue();
    }

    @Override
    public Long getTotalActiveUsers() {
        return dashboardDAO.getTotalActiveUsers();
    }

    @Override
    public Long getTotalTestSubmissions() {
        return dashboardDAO.getTotalTestSubmissions();
    }

    @Override
    public Long getTotalLessonsByMentor(int mentorId) {
        return dashboardDAO.getTotalLessonsByMentor(mentorId);
    }

    @Override
    public Long getTotalQuestionsByMentor(int mentorId) {
        return dashboardDAO.getTotalQuestionsByMentor(mentorId);
    }

    @Override
    public Long getTotalExamsByMentor(int mentorId) {
        return dashboardDAO.getTotalExamsByMentor(mentorId);
    }
}

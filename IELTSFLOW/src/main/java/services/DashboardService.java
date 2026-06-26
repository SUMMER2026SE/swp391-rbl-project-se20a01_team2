package services;

import java.math.BigDecimal;

public interface DashboardService {
    BigDecimal getTotalRevenue();
    Long getTotalActiveUsers();
    Long getTotalTestSubmissions();
    Long getTotalLessonsByMentor(int mentorId);
    Long getTotalQuestionsByMentor(int mentorId);
    Long getTotalExamsByMentor(int mentorId);
}

package dao;

import util.JpaHelper;
import java.util.HashMap;
import java.util.Map;

public class CandidateDashboardDAO {
    
    public Map<String, Object> getCandidateStats(int userId) {
        return JpaHelper.query(em -> {
            Map<String, Object> stats = new HashMap<>();
            
            // 1. Lessons Completed
            try {
                Number lessonsCompleted = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM UserLessonProgress WHERE UserID = :userId AND IsCompleted = 1")
                    .setParameter("userId", userId)
                    .getSingleResult();
                stats.put("lessonsCompleted", lessonsCompleted != null ? lessonsCompleted.intValue() : 0);
            } catch (Exception e) {
                stats.put("lessonsCompleted", 0);
            }
            
            // 2. Latest Mock Test
            try {
                Number latestMockTest = (Number) em.createNativeQuery(
                    "SELECT TOP 1 OverallBand FROM TestSubmissions WHERE UserID = :userId AND Status = 'Completed' AND OverallBand IS NOT NULL ORDER BY EndTime DESC")
                    .setParameter("userId", userId)
                    .getSingleResult();
                stats.put("latestMockTest", latestMockTest != null ? latestMockTest.doubleValue() : 0.0);
            } catch (Exception e) {
                stats.put("latestMockTest", 0.0);
            }
            
            // 3. Study Hours (This Week) - MOCK DATA
            try {
                // Number studyMinutes = (Number) em.createNativeQuery(
                //     "SELECT ISNULL(SUM(DATEDIFF(minute, StartTime, EndTime)), 0) FROM TestSubmissions WHERE UserID = :userId AND StartTime >= DATEADD(day, -7, GETDATE())")
                //     .setParameter("userId", userId)
                //     .getSingleResult();
                // double studyHours = studyMinutes != null ? studyMinutes.doubleValue() / 60.0 : 0.0;
                // Round to 1 decimal place
                // studyHours = Math.round(studyHours * 10.0) / 10.0;
                stats.put("studyHours", 12.5); // Mock data as requested
            } catch (Exception e) {
                stats.put("studyHours", 12.5);
            }
            
            // 4. Target Band & Current Band
            try {
                Object[] targetInfo = (Object[]) em.createNativeQuery(
                    "SELECT TOP 1 TargetBand, CurrentBand FROM CandidateTargets WHERE UserID = :userId AND IsActive = 1 ORDER BY TargetID DESC")
                    .setParameter("userId", userId)
                    .getSingleResult();
                stats.put("targetBand", targetInfo != null && targetInfo[0] != null ? ((Number) targetInfo[0]).doubleValue() : 0.0);
                stats.put("currentBand", targetInfo != null && targetInfo[1] != null ? ((Number) targetInfo[1]).doubleValue() : 0.0);
            } catch (Exception e) {
                stats.put("targetBand", 0.0);
                stats.put("currentBand", 0.0);
            }
            
            return stats;
        });
    }
}

package dao;

import model.TestSubmission;
import util.JpaHelper;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO: Lấy lịch sử bài thi của candidate từ bảng TestSubmissions JOIN Exams.
 */
public class ExamHistoryDAO {

    /**
     * Lấy tất cả bài thi của một user (bao gồm cả InProgress, Completed, Abandoned).
     * Sắp xếp mới nhất trước.
     */
    public List<TestSubmission> getSubmissionsByUser(int userId) {
        return JpaHelper.query(em -> {
            String sql =
                "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, e.Title, e.Type, " +
                "       ts.StartTime, ts.EndTime, " +
                "       ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, " +
                "       ts.OverallBand, ts.TotalScore, " +
                "       ts.ViolationCount, ts.IsCheated, ts.Status " +
                "FROM TestSubmissions ts " +
                "JOIN Exams e ON ts.ExamID = e.ExamID " +
                "WHERE ts.UserID = :userId " +
                "ORDER BY ts.StartTime DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("userId", userId)
                    .getResultList();

            List<TestSubmission> result = new ArrayList<>();
            for (Object[] row : rows) {
                result.add(mapRow(row));
            }
            return result;
        });
    }

    /**
     * Lấy danh sách bài thi Completed/Abandoned, sắp xếp theo thời gian tăng dần,
     * dùng để vẽ biểu đồ tiến độ.
     */
    public List<TestSubmission> getCompletedSubmissionsForChart(int userId) {
        return JpaHelper.query(em -> {
            String sql =
                "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, e.Title, e.Type, " +
                "       ts.StartTime, ts.EndTime, " +
                "       ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, " +
                "       ts.OverallBand, ts.TotalScore, " +
                "       ts.ViolationCount, ts.IsCheated, ts.Status " +
                "FROM TestSubmissions ts " +
                "JOIN Exams e ON ts.ExamID = e.ExamID " +
                "WHERE ts.UserID = :userId " +
                "  AND ts.Status IN ('Completed', 'Abandoned') " +
                "ORDER BY ts.StartTime ASC";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("userId", userId)
                    .getResultList();

            List<TestSubmission> result = new ArrayList<>();
            for (Object[] row : rows) {
                result.add(mapRow(row));
            }
            return result;
        });
    }

    /** Map một hàng kết quả native query sang DTO TestSubmission */
    private TestSubmission mapRow(Object[] row) {
        TestSubmission s = new TestSubmission();
        s.setSubmissionId(toInt(row[0]));
        s.setUserId(toInt(row[1]));
        s.setExamId(toInt(row[2]));
        s.setExamTitle(row[3] != null ? row[3].toString() : "");
        s.setExamType(row[4] != null ? row[4].toString() : "");

        // StartTime / EndTime (DATETIME → Timestamp → LocalDateTime)
        if (row[5] instanceof Timestamp) {
            s.setStartTime(((Timestamp) row[5]).toLocalDateTime());
        }
        if (row[6] instanceof Timestamp) {
            s.setEndTime(((Timestamp) row[6]).toLocalDateTime());
        }

        s.setListeningBand(toDouble(row[7]));
        s.setReadingBand(toDouble(row[8]));
        s.setWritingBand(toDouble(row[9]));
        s.setSpeakingBand(toDouble(row[10]));
        s.setOverallBand(toDouble(row[11]));
        s.setTotalScore(toDouble(row[12]));
        s.setViolationCount(row[13] != null ? ((Number) row[13]).intValue() : 0);
        s.setCheated(Boolean.TRUE.equals(row[14]));
        s.setStatus(row[15] != null ? row[15].toString() : "InProgress");
        return s;
    }

    private int toInt(Object o) {
        return o != null ? ((Number) o).intValue() : 0;
    }

    private Double toDouble(Object o) {
        if (o == null) return null;
        if (o instanceof BigDecimal) return ((BigDecimal) o).doubleValue();
        return ((Number) o).doubleValue();
    }
}

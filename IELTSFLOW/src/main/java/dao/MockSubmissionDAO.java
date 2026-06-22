package dao;

import model.SubmissionDetail;
import model.TestSubmission;
import util.JpaHelper;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO dùng JPA Native Query để quản lý bài làm (TestSubmissions, SubmissionDetails).
 * Phục vụ tính năng Mock Test: tạo bài làm, lưu đáp án, cập nhật điểm, anti-cheat.
 */
public class MockSubmissionDAO {

    /**
     * Tạo mới một bản ghi TestSubmission khi bắt đầu thi.
     * Trả về submissionId được tạo ra.
     */
    public int createSubmission(TestSubmission sub) {
        return JpaHelper.query(em -> {
            jakarta.persistence.EntityTransaction tx = em.getTransaction();
            tx.begin();
            try {
                // Use OUTPUT INSERTED to get the ID in a single statement
                String sql = "INSERT INTO TestSubmissions (UserID, ExamID, StartTime, Status) " +
                             "OUTPUT INSERTED.SubmissionID " +
                             "VALUES (:userId, :examId, :startTime, 'InProgress')";
                Object id = em.createNativeQuery(sql)
                        .setParameter("userId", sub.getUserId())
                        .setParameter("examId", sub.getExamId())
                        .setParameter("startTime", Timestamp.valueOf(sub.getStartTime()))
                        .getSingleResult();

                tx.commit();
                return id != null ? ((Number) id).intValue() : -1;
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw new RuntimeException("Không thể tạo bài làm: " + e.getMessage(), e);
            }
        });
    }

    /**
     * Lưu một câu trả lời chi tiết (SubmissionDetail).
     * Trả về detailId được tạo.
     */
    public int saveDetail(SubmissionDetail detail) {
        return JpaHelper.query(em -> {
            jakarta.persistence.EntityTransaction tx = em.getTransaction();
            tx.begin();
            try {
                String sql = "INSERT INTO SubmissionDetails " +
                             "(SubmissionID, QuestionID, CandidateAnswer, SpeakingUrl, " +
                             " CandidateTranscript, IsCorrect, Score, GradingStatus) " +
                             "OUTPUT INSERTED.DetailID " +
                             "VALUES (:subId, :qId, :answer, :spUrl, :transcript, :isCorrect, :score, :status)";
                var q = em.createNativeQuery(sql)
                        .setParameter("subId", detail.getSubmissionId())
                        .setParameter("qId", detail.getQuestionId())
                        .setParameter("answer", detail.getCandidateAnswer())
                        .setParameter("spUrl", detail.getSpeakingUrl())
                        .setParameter("transcript", detail.getCandidateTranscript());
                if (detail.getIsCorrect() != null)
                    q.setParameter("isCorrect", detail.getIsCorrect());
                else
                    q.setParameter("isCorrect", null);
                if (detail.getScore() != null)
                    q.setParameter("score", detail.getScore());
                else
                    q.setParameter("score", null);
                q.setParameter("status", detail.getGradingStatus() != null ? detail.getGradingStatus() : "Graded");

                Object id = q.getSingleResult();

                tx.commit();
                return id != null ? ((Number) id).intValue() : -1;
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw new RuntimeException("Không thể lưu chi tiết: " + e.getMessage(), e);
            }
        });
    }

    /**
     * Cập nhật điểm + trạng thái cuối cùng của bài làm khi nộp bài.
     */
    public void finaliseSubmission(TestSubmission sub) {
        JpaHelper.execute(em -> {
            String sql = "UPDATE TestSubmissions SET EndTime=:endTime, " +
                         "ListeningBand=:lb, ReadingBand=:rb, WritingBand=:wb, SpeakingBand=:sb, " +
                         "OverallBand=:ob, TotalScore=:ts, " +
                         "ViolationCount=:vc, IsCheated=:cheated, Status=:status " +
                         "WHERE SubmissionID=:subId";
            em.createNativeQuery(sql)
                    .setParameter("endTime", sub.getEndTime() != null ? Timestamp.valueOf(sub.getEndTime()) : null)
                    .setParameter("lb", sub.getListeningBand())
                    .setParameter("rb", sub.getReadingBand())
                    .setParameter("wb", sub.getWritingBand())
                    .setParameter("sb", sub.getSpeakingBand())
                    .setParameter("ob", sub.getOverallBand())
                    .setParameter("ts", sub.getTotalScore())
                    .setParameter("vc", sub.getViolationCount())
                    .setParameter("cheated", sub.isCheated())
                    .setParameter("status", sub.getStatus())
                    .setParameter("subId", sub.getSubmissionId())
                    .executeUpdate();
        });
    }

    /**
     * Tăng bộ đếm vi phạm anti-cheat. Trả về số lần vi phạm mới.
     */
    public int incrementViolation(int submissionId, int maxViolations) {
        return JpaHelper.query(em -> {
            jakarta.persistence.EntityTransaction tx = em.getTransaction();
            tx.begin();
            try {
                // Đọc số lần hiện tại
                Object cur = em.createNativeQuery(
                        "SELECT ViolationCount FROM TestSubmissions WHERE SubmissionID = :id")
                        .setParameter("id", submissionId)
                        .getSingleResult();
                int current = cur != null ? ((Number) cur).intValue() : 0;
                int next = current + 1;
                boolean cheat = next >= maxViolations;

                String update = cheat
                        ? "UPDATE TestSubmissions SET ViolationCount=:vc, IsCheated=1, Status='Abandoned' WHERE SubmissionID=:id"
                        : "UPDATE TestSubmissions SET ViolationCount=:vc, IsCheated=0 WHERE SubmissionID=:id";
                em.createNativeQuery(update)
                        .setParameter("vc", next)
                        .setParameter("id", submissionId)
                        .executeUpdate();

                tx.commit();
                return next;
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw new RuntimeException("Lỗi khi ghi nhận vi phạm: " + e.getMessage(), e);
            }
        });
    }

    /**
     * Lấy một bài làm theo ID, kèm thông tin đề thi (JOIN Exams).
     */
    public TestSubmission getSubmissionById(int submissionId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, ts.StartTime, ts.EndTime, " +
                         "ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, " +
                         "ts.OverallBand, ts.TotalScore, ts.ViolationCount, ts.IsCheated, ts.Status, " +
                         "e.Title AS ExamTitle, e.Type AS ExamType, e.SkillFocus " +
                         "FROM TestSubmissions ts " +
                         "JOIN Exams e ON ts.ExamID = e.ExamID " +
                         "WHERE ts.SubmissionID = :id";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("id", submissionId)
                    .getResultList();

            if (rows.isEmpty()) return null;
            return mapSubmission(rows.get(0));
        });
    }

    /**
     * Lấy tất cả bài làm của user, sắp xếp theo ngày mới nhất.
     */
    public List<TestSubmission> getSubmissionsByUser(int userId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, ts.StartTime, ts.EndTime, " +
                         "ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, " +
                         "ts.OverallBand, ts.TotalScore, ts.ViolationCount, ts.IsCheated, ts.Status, " +
                         "e.Title AS ExamTitle, e.Type AS ExamType, e.SkillFocus " +
                         "FROM TestSubmissions ts " +
                         "JOIN Exams e ON ts.ExamID = e.ExamID " +
                         "WHERE ts.UserID = :userId " +
                         "ORDER BY ts.StartTime DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("userId", userId)
                    .getResultList();

            List<TestSubmission> list = new ArrayList<>();
            for (Object[] row : rows) {
                list.add(mapSubmission(row));
            }
            return list;
        });
    }

    // ──── Mapper helpers ────────────────────────────────────────────────

    private TestSubmission mapSubmission(Object[] row) {
        TestSubmission s = new TestSubmission();
        s.setSubmissionId(toInt(row[0]));
        s.setUserId(toInt(row[1]));
        s.setExamId(toInt(row[2]));
        if (row[3] instanceof Timestamp) s.setStartTime(((Timestamp) row[3]).toLocalDateTime());
        if (row[4] instanceof Timestamp) s.setEndTime(((Timestamp) row[4]).toLocalDateTime());
        s.setListeningBand(toDouble(row[5]));
        s.setReadingBand(toDouble(row[6]));
        s.setWritingBand(toDouble(row[7]));
        s.setSpeakingBand(toDouble(row[8]));
        s.setOverallBand(toDouble(row[9]));
        s.setTotalScore(toDouble(row[10]));
        s.setViolationCount(row[11] != null ? ((Number) row[11]).intValue() : 0);
        s.setCheated(Boolean.TRUE.equals(row[12]) || Integer.valueOf(1).equals(row[12])
                || (row[12] instanceof Number && ((Number) row[12]).intValue() == 1));
        s.setStatus(row[13] != null ? row[13].toString() : "InProgress");
        s.setExamTitle(row[14] != null ? row[14].toString() : "");
        s.setExamType(row[15] != null ? row[15].toString() : "");
        return s;
    }

    private int toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof BigDecimal) return ((BigDecimal) o).intValue();
        return ((Number) o).intValue();
    }

    private Double toDouble(Object o) {
        if (o == null) return null;
        if (o instanceof BigDecimal) return ((BigDecimal) o).doubleValue();
        return ((Number) o).doubleValue();
    }
}

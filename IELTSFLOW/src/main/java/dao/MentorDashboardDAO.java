package dao;

import model.Ticket;
import util.JpaHelper;

import java.util.List;

/**
 * DAO tổng hợp các thống kê dành riêng cho Mentor Dashboard.
 */
public class MentorDashboardDAO {

    /**
     * Đếm số câu hỏi do mentor tạo (chưa bị xóa).
     */
    public long countQuestionsByMentor(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Questions WHERE CreatedBy = ?1 AND Deleted = 0")
                    .setParameter(1, mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Đếm số bài học do mentor tạo (chưa bị xóa).
     */
    public long countLessonsByMentor(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Lessons WHERE CreatedBy = ?1 AND Deleted = 0")
                    .setParameter(1, mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Đếm số đề thi do mentor tạo (chưa bị xóa).
     */
    public long countExamsByMentor(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Exams WHERE MentorID = ?1 AND Deleted = 0")
                    .setParameter(1, mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Đếm tổng số bài nộp (TestSubmissions) trên các đề thi của mentor này.
     */
    public long countSubmissionsForMentor(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM TestSubmissions ts " +
                    "JOIN Exams e ON ts.ExamID = e.ExamID " +
                    "WHERE e.MentorID = ?1 AND e.Deleted = 0")
                    .setParameter(1, mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Lấy top 5 ticket đang mở (Open) gần nhất để hiển thị trên dashboard.
     */
    public List<Ticket> getRecentOpenTickets(int limit) {
        return JpaHelper.query(em -> {
            List<Ticket> tickets = em.createQuery(
                    "SELECT t FROM Ticket t WHERE t.status = 'Open' ORDER BY t.createdAt DESC",
                    Ticket.class)
                    .setMaxResults(limit)
                    .getResultList();
            // Force-init lazy replies count
            for (Ticket t : tickets) {
                t.getReplies().size();
            }
            return tickets;
        });
    }
}

package dao;

import model.Ticket;
import util.JpaHelper;

import java.util.List;

/**
 * DAO tổng hợp các thống kê dành riêng cho Mentor Dashboard.
 */
public class MentorDashboardDAO {

    /**
     * Đếm tổng số câu hỏi trong hệ thống (Ngân hàng câu hỏi dùng chung).
     */
    public long countTotalQuestions() {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Questions WHERE Deleted = 0")
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    public long countPersonalQuestions(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Questions WHERE Deleted = 0 AND CreatedBy = :mentorId")
                    .setParameter("mentorId", mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Đếm tổng số bài học trong hệ thống.
     */
    public long countTotalLessons() {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Lessons WHERE Deleted = 0")
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    public long countPersonalLessons(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Lessons WHERE Deleted = 0 AND CreatedBy = :mentorId")
                    .setParameter("mentorId", mentorId)
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    /**
     * Đếm tổng số đề thi trong hệ thống.
     */
    public long countTotalExams() {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Exams WHERE Deleted = 0")
                    .getSingleResult();
            return n != null ? n.longValue() : 0L;
        });
    }

    public long countPersonalExams(int mentorId) {
        return JpaHelper.query(em -> {
            Number n = (Number) em.createNativeQuery(
                    "SELECT COUNT(*) FROM Exams WHERE Deleted = 0 AND MentorID = :mentorId")
                    .setParameter("mentorId", mentorId)
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
                    "WHERE e.Deleted = 0 AND e.MentorID = :mentorId")
                    .setParameter("mentorId", mentorId)
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

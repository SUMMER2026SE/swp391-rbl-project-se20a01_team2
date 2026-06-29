package dao;

import util.JpaHelper;
import model.User;
import jakarta.persistence.Query;
import java.util.List;

public class MentorStudentDAO {

    public List<User> getAllCandidates() {
        return JpaHelper.query(em -> {
            String sql = "SELECT u.* FROM Users u WHERE u.RoleID = 3 AND u.Deleted = 0 ORDER BY u.CreatedAt DESC";
            Query query = em.createNativeQuery(sql, User.class);
            @SuppressWarnings("unchecked")
            List<User> list = query.getResultList();
            return list;
        });
    }

    public List<User> getMyStudents(int mentorId) {
        return JpaHelper.query(em -> {
            // My Students are candidates who have submitted a test for an exam created by this mentor
            // OR assigned a ticket to this mentor
            String sql = "SELECT DISTINCT u.* FROM Users u " +
                         "LEFT JOIN TestSubmissions ts ON u.UserID = ts.UserID " +
                         "LEFT JOIN Exams e ON ts.ExamID = e.ExamID " +
                         "WHERE u.RoleID = 3 AND u.Deleted = 0 " +
                         "AND (e.MentorID = ?1) " +
                         "ORDER BY u.CreatedAt DESC";
            Query query = em.createNativeQuery(sql, User.class);
            query.setParameter(1, mentorId);
            @SuppressWarnings("unchecked")
            List<User> list = query.getResultList();
            return list;
        });
    }
}

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

    public List<User> searchStudents(String keyword, String sort) {
        return JpaHelper.query(em -> {
            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            String sql = "SELECT u.* FROM Users u WHERE u.RoleID = 3 AND u.Deleted = 0";
            if (hasKeyword) {
                sql += " AND (LOWER(u.FullName) LIKE :kw OR LOWER(u.Email) LIKE :kw)";
            }
            if ("oldest".equals(sort)) {
                sql += " ORDER BY u.CreatedAt ASC";
            } else if ("name_asc".equals(sort)) {
                sql += " ORDER BY u.FullName ASC";
            } else if ("name_desc".equals(sort)) {
                sql += " ORDER BY u.FullName DESC";
            } else {
                sql += " ORDER BY u.CreatedAt DESC"; // default
            }
            
            Query query = em.createNativeQuery(sql, User.class);
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            @SuppressWarnings("unchecked")
            List<User> list = query.getResultList();
            return list;
        });
    }
}

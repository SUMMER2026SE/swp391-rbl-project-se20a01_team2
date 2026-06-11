package dao;

import model.Exam;
import util.JpaHelper;
import java.util.List;

public class ExamDAO {

    // Lấy tất cả đề thi chưa bị xóa
    public List<Exam> findAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.deleted = false ORDER BY e.createdAt DESC",
                Exam.class)
              .getResultList()
        );
    }

    // Xem chi tiết đề thi
    public Exam findById(int id) {
        return JpaHelper.query(em -> {
            Exam e = em.find(Exam.class, id);
            return (e != null && !e.isDeleted()) ? e : null;
        });
    }

    // Lọc theo type: "Practice", "Mock Test", "Placement Test"
    public List<Exam> findByType(String type) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.type = :type AND e.deleted = false " +
                "ORDER BY e.createdAt DESC",
                Exam.class)
              .setParameter("type", type)
              .getResultList()
        );
    }

    // Tìm kiếm đề thi theo keyword (#28)
    public List<Exam> searchByKeyword(String keyword) {
        String kw = "%" + keyword.toLowerCase() + "%";
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.deleted = false " +
                "AND LOWER(e.title) LIKE :kw " +
                "ORDER BY e.createdAt DESC",
                Exam.class)
              .setParameter("kw", kw)
              .getResultList()
        );
    }

    // Tìm kiếm đề thi theo keyword + skill (#28)
    public List<Exam> searchByKeywordAndSkill(String keyword, String skillFocus) {
        String kw = "%" + keyword.toLowerCase() + "%";
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.deleted = false AND e.skillFocus = :skill " +
                "AND LOWER(e.title) LIKE :kw " +
                "ORDER BY e.createdAt DESC",
                Exam.class)
              .setParameter("skill", skillFocus)
              .setParameter("kw", kw)
              .getResultList()
        );
    }

    // Lọc theo skillFocus (#28)
    public List<Exam> findBySkillFocus(String skillFocus) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.skillFocus = :skill AND e.deleted = false " +
                "ORDER BY e.createdAt DESC",
                Exam.class)
              .setParameter("skill", skillFocus)
              .getResultList()
        );
    }

    public void save(Exam exam) {
        JpaHelper.execute(em -> em.persist(exam));
    }

    public void update(Exam exam) {
        JpaHelper.execute(em -> em.merge(exam));
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            Exam e = em.find(Exam.class, id);
            if (e != null) { e.setDeleted(true); em.merge(e); }
        });
    }
}

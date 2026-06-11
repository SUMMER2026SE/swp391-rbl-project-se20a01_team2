package dao;

import model.Lesson;
import util.JpaHelper;
import java.util.List;

public class LessonDAO {

    // Lấy tất cả bài học chưa bị xóa
    public List<Lesson> findAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT l FROM Lesson l WHERE l.deleted = false ORDER BY l.createdAt DESC",
                Lesson.class)
              .getResultList()
        );
    }

    // Xem chi tiết bài học (#22)
    public Lesson findById(int id) {
        return JpaHelper.query(em -> {
            Lesson l = em.find(Lesson.class, id);
            return (l != null && !l.isDeleted()) ? l : null;
        });
    }

    // Tìm kiếm bài học theo keyword (#21)
    public List<Lesson> searchByKeyword(String keyword) {
        String kw = "%" + keyword.toLowerCase() + "%";
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT l FROM Lesson l WHERE l.deleted = false " +
                "AND (LOWER(l.title) LIKE :kw OR LOWER(l.content) LIKE :kw) " +
                "ORDER BY l.createdAt DESC",
                Lesson.class)
              .setParameter("kw", kw)
              .getResultList()
        );
    }

    // Lọc theo skill (#21)
    public List<Lesson> findBySkill(String skill) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT l FROM Lesson l WHERE l.skill = :skill AND l.deleted = false " +
                "ORDER BY l.createdAt DESC",
                Lesson.class)
              .setParameter("skill", skill)
              .getResultList()
        );
    }

    // Tìm kiếm kết hợp keyword + skill (#21)
    public List<Lesson> searchByKeywordAndSkill(String keyword, String skill) {
        String kw = "%" + keyword.toLowerCase() + "%";
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT l FROM Lesson l WHERE l.deleted = false AND l.skill = :skill " +
                "AND (LOWER(l.title) LIKE :kw OR LOWER(l.content) LIKE :kw) " +
                "ORDER BY l.createdAt DESC",
                Lesson.class)
              .setParameter("skill", skill)
              .setParameter("kw", kw)
              .getResultList()
        );
    }

    public void save(Lesson lesson) {
        JpaHelper.execute(em -> em.persist(lesson));
    }

    public void update(Lesson lesson) {
        JpaHelper.execute(em -> em.merge(lesson));
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            Lesson l = em.find(Lesson.class, id);
            if (l != null) { l.setDeleted(true); em.merge(l); }
        });
    }
}

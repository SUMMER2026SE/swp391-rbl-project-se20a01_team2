package dao;

import model.Lesson;
import util.JpaHelper;
import util.PaginatedList;
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
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT l FROM Lesson l WHERE l.deleted = false");
        if (hasKeyword) {
            queryStr.append(" AND (LOWER(l.title) LIKE :kw OR LOWER(l.content) LIKE :kw)");
        }
        queryStr.append(" ORDER BY l.createdAt DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Lesson> query = em.createQuery(queryStr.toString(), Lesson.class);
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            return query.getResultList();
        });
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
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skill != null && !skill.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT l FROM Lesson l WHERE l.deleted = false");
        if (hasSkill) {
            queryStr.append(" AND l.skill = :skill");
        }
        if (hasKeyword) {
            queryStr.append(" AND (LOWER(l.title) LIKE :kw OR LOWER(l.content) LIKE :kw)");
        }
        queryStr.append(" ORDER BY l.createdAt DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Lesson> query = em.createQuery(queryStr.toString(), Lesson.class);
            if (hasSkill) {
                query.setParameter("skill", skill);
            }
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            return query.getResultList();
        });
    }

    public PaginatedList<Lesson> searchLessons(String keyword, String skill, int page, int pageSize) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skill != null && !skill.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT l FROM Lesson l WHERE l.deleted = false");
        StringBuilder countStr = new StringBuilder("SELECT COUNT(l) FROM Lesson l WHERE l.deleted = false");
        
        StringBuilder conditions = new StringBuilder();
        if (hasSkill) conditions.append(" AND l.skill = :skill");
        if (hasKeyword) conditions.append(" AND (LOWER(l.title) LIKE :kw OR LOWER(l.content) LIKE :kw)");

        queryStr.append(conditions).append(" ORDER BY l.createdAt DESC");
        countStr.append(conditions);

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Long> countQuery = em.createQuery(countStr.toString(), Long.class);
            jakarta.persistence.TypedQuery<Lesson> query = em.createQuery(queryStr.toString(), Lesson.class);

            if (hasSkill) { countQuery.setParameter("skill", skill); query.setParameter("skill", skill); }
            if (hasKeyword) {
                String kw = "%" + keyword.toLowerCase() + "%";
                countQuery.setParameter("kw", kw);
                query.setParameter("kw", kw);
            }

            long totalItems = countQuery.getSingleResult();
            
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            
            return new PaginatedList<>(query.getResultList(), page, totalItems, pageSize);
        });
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
    public List<Lesson> findByMentor(int mentorId) {
        return JpaHelper.query(em ->
                em.createQuery(
                                "SELECT l FROM Lesson l WHERE l.createdBy = :mentorId AND l.deleted = false ORDER BY l.createdAt DESC",
                                Lesson.class)
                        .setParameter("mentorId", mentorId)
                        .getResultList()
        );
    }
}

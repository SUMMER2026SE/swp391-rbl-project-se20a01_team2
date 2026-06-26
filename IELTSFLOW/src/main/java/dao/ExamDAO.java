package dao;

import model.Exam;
import util.JpaHelper;
import util.PaginatedList;
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
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        
        StringBuilder queryStr = new StringBuilder("SELECT e FROM Exam e WHERE e.deleted = false");
        if (hasKeyword) {
            queryStr.append(" AND LOWER(e.title) LIKE :kw");
        }
        queryStr.append(" ORDER BY e.createdAt DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Exam> query = em.createQuery(queryStr.toString(), Exam.class);
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            return query.getResultList();
        });
    }

    // Tìm kiếm đề thi theo keyword + skill (#28)
    public List<Exam> searchByKeywordAndSkill(String keyword, String skillFocus) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skillFocus != null && !skillFocus.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT e FROM Exam e WHERE e.deleted = false");
        if (hasSkill) {
            queryStr.append(" AND e.skillFocus = :skill");
        }
        if (hasKeyword) {
            queryStr.append(" AND LOWER(e.title) LIKE :kw");
        }
        queryStr.append(" ORDER BY e.createdAt DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Exam> query = em.createQuery(queryStr.toString(), Exam.class);
            if (hasSkill) {
                query.setParameter("skill", skillFocus);
            }
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }
            return query.getResultList();
        });
    }

    public PaginatedList<Exam> searchExams(String keyword, String skillFocus, String type, int page, int pageSize) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skillFocus != null && !skillFocus.trim().isEmpty();
        boolean hasType = type != null && !type.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT e FROM Exam e WHERE e.deleted = false");
        StringBuilder countStr = new StringBuilder("SELECT COUNT(e) FROM Exam e WHERE e.deleted = false");
        
        StringBuilder conditions = new StringBuilder();
        if (hasSkill) conditions.append(" AND e.skillFocus = :skill");
        if (hasType) conditions.append(" AND e.type = :type");
        if (hasKeyword) conditions.append(" AND LOWER(e.title) LIKE :kw");

        queryStr.append(conditions).append(" ORDER BY e.createdAt DESC");
        countStr.append(conditions);

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Long> countQuery = em.createQuery(countStr.toString(), Long.class);
            jakarta.persistence.TypedQuery<Exam> query = em.createQuery(queryStr.toString(), Exam.class);

            if (hasSkill) { countQuery.setParameter("skill", skillFocus); query.setParameter("skill", skillFocus); }
            if (hasType) { countQuery.setParameter("type", type); query.setParameter("type", type); }
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

    public List<Exam> findByMentor(int mentorId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT e FROM Exam e WHERE e.mentorId = :mentorId AND e.deleted = false ORDER BY e.createdAt DESC",
                Exam.class)
              .setParameter("mentorId", mentorId)
              .getResultList()
        );
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            Exam e = em.find(Exam.class, id);
            if (e != null) { e.setDeleted(true); em.merge(e); }
        });
    }
}

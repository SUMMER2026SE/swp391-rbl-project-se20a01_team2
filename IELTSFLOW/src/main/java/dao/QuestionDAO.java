package dao;

import model.Question;
import util.JpaHelper;
import util.PaginatedList;
import java.util.List;
import jakarta.persistence.NoResultException;
public class QuestionDAO {

    public List<Question> findAll() {
        return JpaHelper.query(em ->
                em.createQuery(
                                "SELECT q FROM Question q WHERE q.deleted = false ORDER BY q.questionId DESC",
                                Question.class)
                        .getResultList()
        );
    }

    public Question findById(int id) {
        return JpaHelper.query(em -> {
            Question q = em.find(Question.class, id);
            return (q != null && !q.isDeleted()) ? q : null;
        });
    }

    public Question findByIdWithTags(int id) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                                "SELECT q FROM Question q LEFT JOIN FETCH q.tags " +
                                        "WHERE q.questionId = :id AND q.deleted = false",
                                Question.class)
                        .setParameter("id", id)
                        .getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        });
    }

    public void addTag(int questionId, int tagId) {
        JpaHelper.execute(em ->
                em.createNativeQuery(
                                "INSERT INTO QuestionTags (QuestionID, TagID) " +
                                        "SELECT :qid, :tid WHERE NOT EXISTS (" +
                                        "SELECT 1 FROM QuestionTags WHERE QuestionID = :qid AND TagID = :tid)")
                        .setParameter("qid", questionId)
                        .setParameter("tid", tagId)
                        .executeUpdate()
        );
    }

    public void removeTag(int questionId, int tagId) {
        JpaHelper.execute(em ->
                em.createNativeQuery("DELETE FROM QuestionTags WHERE QuestionID = :qid AND TagID = :tid")
                        .setParameter("qid", questionId)
                        .setParameter("tid", tagId)
                        .executeUpdate()
        );
    }

    public List<Question> getQuestionsByResourceId(int resourceId) {
        return JpaHelper.query(em ->
                em.createQuery("SELECT q FROM Question q WHERE q.resourceId = :resId AND q.deleted = false ORDER BY q.orderInResource ASC", Question.class)
                        .setParameter("resId", resourceId)
                        .getResultList()
        );
    }

    public void updateQuestionsOrder(List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) return;
        JpaHelper.execute(em -> {
            int order = 1;
            for (Integer qid : questionIds) {
                em.createQuery("UPDATE Question q SET q.orderInResource = :order WHERE q.questionId = :qid")
                        .setParameter("order", order++)
                        .setParameter("qid", qid)
                        .executeUpdate();
            }
        });
    }

    public int getNextOrderInResource(int resourceId) {
        return JpaHelper.query(em -> {
            try {
                Integer maxOrder = em.createQuery(
                        "SELECT MAX(q.orderInResource) FROM Question q WHERE q.resourceId = :resId AND q.deleted = false", Integer.class)
                        .setParameter("resId", resourceId)
                        .getSingleResult();
                return (maxOrder != null) ? maxOrder + 1 : 1;
            } catch (Exception e) {
                return 1;
            }
        });
    }

    public void removeAllTags(int questionId) {
        JpaHelper.execute(em ->
                em.createNativeQuery("DELETE FROM QuestionTags WHERE QuestionID = :qid")
                        .setParameter("qid", questionId)
                        .executeUpdate()
        );
    }

    public List<Question> findBySkill(String skill) {
        return JpaHelper.query(em ->
                em.createQuery(
                                "SELECT q FROM Question q WHERE q.skill = :skill AND q.deleted = false ORDER BY q.questionId DESC",
                                Question.class)
                        .setParameter("skill", skill)
                        .getResultList()
        );
    }

    public List<Question> findByMentor(int mentorId) {
        return JpaHelper.query(em ->
                em.createQuery(
                                "SELECT q FROM Question q WHERE q.createdBy = :mentorId AND q.deleted = false ORDER BY q.questionId DESC",
                                Question.class)
                        .setParameter("mentorId", mentorId)
                        .getResultList()
        );
    }
    public List<Question> searchByKeywordAndSkill(String keyword, String skill) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skill != null && !skill.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT q FROM Question q WHERE q.deleted = false");
        if (hasSkill) queryStr.append(" AND q.skill = :skill");
        if (hasKeyword) queryStr.append(" AND LOWER(q.content) LIKE :kw");
        queryStr.append(" ORDER BY q.questionId DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Question> query = em.createQuery(queryStr.toString(), Question.class);
            if (hasSkill) query.setParameter("skill", skill);
            if (hasKeyword) query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            return query.getResultList();
        });
    }

    public List<Question> searchByKeywordSkillAndResource(String keyword, String skill, Integer resourceId) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skill != null && !skill.trim().isEmpty();
        boolean hasResource = resourceId != null;

        StringBuilder queryStr = new StringBuilder("SELECT q FROM Question q WHERE q.deleted = false");
        if (hasSkill) queryStr.append(" AND q.skill = :skill");
        if (hasKeyword) queryStr.append(" AND LOWER(q.content) LIKE :kw");
        if (hasResource) queryStr.append(" AND q.resourceId = :resourceId");
        queryStr.append(" ORDER BY q.questionId DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Question> query = em.createQuery(queryStr.toString(), Question.class);
            if (hasSkill) query.setParameter("skill", skill);
            if (hasKeyword) query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            if (hasResource) query.setParameter("resourceId", resourceId);
            return query.getResultList();
        });
    }

    public PaginatedList<Question> searchQuestions(String keyword, String skill, String difficulty, String type, int page, int pageSize) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasSkill = skill != null && !skill.trim().isEmpty();
        boolean hasDifficulty = difficulty != null && !difficulty.trim().isEmpty();
        boolean hasType = type != null && !type.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT q FROM Question q WHERE q.deleted = false");
        StringBuilder countStr = new StringBuilder("SELECT COUNT(q) FROM Question q WHERE q.deleted = false");
        
        StringBuilder conditions = new StringBuilder();
        if (hasSkill) conditions.append(" AND q.skill = :skill");
        if (hasDifficulty) conditions.append(" AND q.difficulty = :difficulty");
        if (hasType) conditions.append(" AND q.questionType = :type");
        if (hasKeyword) conditions.append(" AND LOWER(q.content) LIKE :kw");

        queryStr.append(conditions).append(" ORDER BY q.questionId DESC");
        countStr.append(conditions);

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Long> countQuery = em.createQuery(countStr.toString(), Long.class);
            jakarta.persistence.TypedQuery<Question> query = em.createQuery(queryStr.toString(), Question.class);

            if (hasSkill) { countQuery.setParameter("skill", skill); query.setParameter("skill", skill); }
            if (hasDifficulty) { countQuery.setParameter("difficulty", difficulty); query.setParameter("difficulty", difficulty); }
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

    public void save(Question question) {
        JpaHelper.execute(em -> em.persist(question));
    }

    public void update(Question question) {
        JpaHelper.execute(em -> em.merge(question));
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            Question q = em.find(Question.class, id);
            if (q != null) { q.setDeleted(true); em.merge(q); }
        });
    }
}

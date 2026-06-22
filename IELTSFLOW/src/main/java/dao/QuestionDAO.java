package dao;

import model.Question;
import util.JpaHelper;
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
        String kw = "%" + keyword.toLowerCase() + "%";
        boolean hasSkill = skill != null && !skill.isBlank();

        if (hasSkill) {
            return JpaHelper.query(em ->
                    em.createQuery(
                                    "SELECT q FROM Question q WHERE q.deleted = false AND q.skill = :skill " +
                                            "AND LOWER(q.content) LIKE :kw ORDER BY q.questionId DESC",
                                    Question.class)
                            .setParameter("skill", skill)
                            .setParameter("kw", kw)
                            .getResultList()
            );
        }
        return JpaHelper.query(em ->
                em.createQuery(
                                "SELECT q FROM Question q WHERE q.deleted = false " +
                                        "AND LOWER(q.content) LIKE :kw ORDER BY q.questionId DESC",
                                Question.class)
                        .setParameter("kw", kw)
                        .getResultList()
        );
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

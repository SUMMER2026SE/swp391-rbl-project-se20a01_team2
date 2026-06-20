package dao;

import model.Question;
import util.JpaHelper;
import java.util.List;

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

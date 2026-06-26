package dao;

import model.ExamQuestion;
import util.JpaHelper;
import java.util.List;

public class ExamQuestionDAO {

    public List<ExamQuestion> findBySectionId(int sectionId) {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT eq FROM ExamQuestion eq JOIN FETCH eq.question WHERE eq.sectionId = :sectionId ORDER BY eq.orderIndex", ExamQuestion.class)
              .setParameter("sectionId", sectionId)
              .getResultList()
        );
    }

    public int getMaxOrderIndex(int sectionId) {
        return JpaHelper.query(em -> {
            Integer max = em.createQuery("SELECT MAX(eq.orderIndex) FROM ExamQuestion eq WHERE eq.sectionId = :sectionId", Integer.class)
                            .setParameter("sectionId", sectionId)
                            .getSingleResult();
            return max == null ? 0 : max;
        });
    }

    public boolean exists(int sectionId, int questionId) {
        return JpaHelper.query(em -> {
            Long count = em.createQuery("SELECT COUNT(eq) FROM ExamQuestion eq WHERE eq.sectionId = :sId AND eq.questionId = :qId", Long.class)
                           .setParameter("sId", sectionId)
                           .setParameter("qId", questionId)
                           .getSingleResult();
            return count != null && count > 0;
        });
    }

    public void save(ExamQuestion eq) {
        JpaHelper.execute(em -> em.persist(eq));
    }

    public void delete(int sectionId, int questionId) {
        JpaHelper.execute(em -> {
            em.createQuery("DELETE FROM ExamQuestion eq WHERE eq.sectionId = :sId AND eq.questionId = :qId")
              .setParameter("sId", sectionId)
              .setParameter("qId", questionId)
              .executeUpdate();
        });
    }
}

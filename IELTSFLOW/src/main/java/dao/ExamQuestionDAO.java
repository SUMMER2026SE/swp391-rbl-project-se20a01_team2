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

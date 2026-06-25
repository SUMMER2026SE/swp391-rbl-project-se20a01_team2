package dao;

import model.ExamSection;
import util.JpaHelper;
import java.util.List;

public class ExamSectionDAO {

    public List<ExamSection> findByExamId(int examId) {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT s FROM ExamSection s WHERE s.examId = :examId ORDER BY s.orderIndex", ExamSection.class)
              .setParameter("examId", examId)
              .getResultList()
        );
    }

    public ExamSection findById(int sectionId) {
        return JpaHelper.query(em -> em.find(ExamSection.class, sectionId));
    }

    public void save(ExamSection section) {
        JpaHelper.execute(em -> em.persist(section));
    }

    public void update(ExamSection section) {
        JpaHelper.execute(em -> em.merge(section));
    }

    public void delete(int sectionId) {
        JpaHelper.execute(em -> {
            ExamSection section = em.find(ExamSection.class, sectionId);
            if (section != null) em.remove(section);
        });
    }
}

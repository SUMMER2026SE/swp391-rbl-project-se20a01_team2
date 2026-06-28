package dao;

import model.ExamSection;
import util.JpaHelper;
import java.util.List;

public class ExamSectionDAO {

    public List<ExamSection> findByExamId(int examId) {
        return JpaHelper.query(em -> {
            String sql = "SELECT s.SectionID, s.ExamID, s.Skill, s.SectionName, s.ResourceID, s.OrderIndex, " +
                         "r.ResourceText, r.ResourceAudioUrl " +
                         "FROM ExamSections s " +
                         "LEFT JOIN QuestionResource r ON s.ResourceID = r.ResourceID " +
                         "WHERE s.ExamID = :examId ORDER BY s.OrderIndex";
            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("examId", examId)
                    .getResultList();
            
            java.util.List<ExamSection> sections = new java.util.ArrayList<>();
            for (Object[] row : rows) {
                ExamSection sec = new ExamSection();
                sec.setSectionId(((Number) row[0]).intValue());
                sec.setExamId(((Number) row[1]).intValue());
                sec.setSkill(row[2] != null ? row[2].toString() : "");
                sec.setSectionName(row[3] != null ? row[3].toString() : "");
                if (row[4] != null) sec.setResourceId(((Number) row[4]).intValue());
                sec.setOrderIndex(((Number) row[5]).intValue());
                if (row[6] != null) sec.setResourceText(row[6].toString());
                if (row[7] != null) sec.setResourceAudioUrl(row[7].toString());
                sections.add(sec);
            }
            return sections;
        });
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

package services;

import dao.ExamDAO;
import model.Exam;
import java.time.LocalDateTime;
import java.util.List;
import util.PaginatedList;

public class ExamService {

    private final ExamDAO examDAO = new ExamDAO();

    public List<Exam> getAllExams() {
        return examDAO.findAll();
    }

    public Exam getExamById(int id) {
        return examDAO.findById(id);
    }

    public PaginatedList<Exam> searchExams(String keyword, String skillFocus, String type, int page, int pageSize) {
        return examDAO.searchExams(keyword, skillFocus, type, page, pageSize);
    }

    public List<Exam> searchExams(String keyword, String skillFocus, String type) {
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        boolean hasSkill = skillFocus != null && !skillFocus.isBlank();
        boolean hasType = type != null && !type.isBlank();

        if (hasType && !hasKeyword && !hasSkill) {
            return examDAO.findByType(type);
        }
        if (hasSkill && !hasKeyword) {
            return examDAO.findBySkillFocus(skillFocus);
        }
        if (hasKeyword && hasSkill) {
            return examDAO.searchByKeywordAndSkill(keyword, skillFocus);
        }
        if (hasKeyword) {
            return examDAO.searchByKeyword(keyword);
        }
        return examDAO.findAll();
    }

    public List<Exam> getPracticeExams() {
        return examDAO.findByType("Practice");
    }

    public void createExam(Exam exam) throws Exception {
        validate(exam);
        exam.setDeleted(false);
        exam.setCreatedAt(LocalDateTime.now());
        examDAO.save(exam);
    }

    public void updateExam(Exam exam) throws Exception {
        Exam existing = examDAO.findById(exam.getExamId());
        if (existing == null)
            throw new Exception("Không tìm thấy đề thi #" + exam.getExamId());
        validate(exam);

        existing.setTitle(exam.getTitle());
        existing.setType(exam.getType());
        existing.setSkillFocus(exam.getSkillFocus());
        existing.setDuration(exam.getDuration());
        examDAO.update(existing);
    }

    public void deleteExam(int id) {
        examDAO.softDelete(id);
    }

    private void validate(Exam exam) throws Exception {
        if (exam.getTitle() == null || exam.getTitle().isBlank())
            throw new Exception("Tiêu đề không được để trống");
        if (exam.getType() == null || exam.getType().isBlank())
            throw new Exception("Loại đề thi không được để trống");
        if (exam.getDuration() < 0)
            throw new Exception("Thời lượng không được âm");
    }

    // --- Section & Question Management ---
    private final dao.ExamSectionDAO sectionDAO = new dao.ExamSectionDAO();
    private final dao.ExamQuestionDAO examQuestionDAO = new dao.ExamQuestionDAO();

    public List<model.ExamSection> getExamSections(int examId) {
        List<model.ExamSection> sections = sectionDAO.findByExamId(examId);
        for (model.ExamSection sec : sections) {
            sec.setExamQuestions(examQuestionDAO.findBySectionId(sec.getSectionId()));
        }
        return sections;
    }

    public model.ExamSection getSectionById(int sectionId) {
        return sectionDAO.findById(sectionId);
    }

    public void addSection(model.ExamSection section) {
        sectionDAO.save(section);
    }

    public void updateSection(model.ExamSection section) {
        sectionDAO.update(section);
    }

    public void deleteSection(int sectionId) {
        sectionDAO.delete(sectionId);
    }

    public void addQuestionToSection(int sectionId, int questionId) {
        if (examQuestionDAO.exists(sectionId, questionId)) {
            return; // Ignore duplicates
        }
        int nextOrder = examQuestionDAO.getMaxOrderIndex(sectionId) + 1;
        model.ExamQuestion eq = new model.ExamQuestion();
        eq.setSectionId(sectionId);
        eq.setQuestionId(questionId);
        eq.setOrderIndex(nextOrder);
        examQuestionDAO.save(eq);
    }

    public void removeQuestionFromSection(int sectionId, int questionId) {
        examQuestionDAO.delete(sectionId, questionId);
    }
}

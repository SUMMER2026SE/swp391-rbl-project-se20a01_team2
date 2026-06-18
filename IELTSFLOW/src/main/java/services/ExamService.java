package services;

import dao.ExamDAO;
import model.Exam;
import java.time.LocalDateTime;
import java.util.List;

public class ExamService {

    private final ExamDAO examDAO = new ExamDAO();

    public List<Exam> getAllExams() {
        return examDAO.findAll();
    }

    public Exam getExamById(int id) {
        return examDAO.findById(id);
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
        if (exam.getDuration() <= 0)
            throw new Exception("Thời lượng phải lớn hơn 0");
    }
}

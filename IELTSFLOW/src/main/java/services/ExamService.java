package services;

import dao.ExamDAO;
import model.Exam;
import java.util.List;

public class ExamService {

    private final ExamDAO examDAO = new ExamDAO();

    // Lấy tất cả đề thi
    public List<Exam> getAllExams() {
        return examDAO.findAll();
    }

    // Lấy chi tiết đề thi (cần cho làm lại #24)
    public Exam getExamById(int id) {
        return examDAO.findById(id);
    }

    // Tìm kiếm đề thi (#28) - hỗ trợ keyword, skillFocus, type, hoặc kết hợp
    public List<Exam> searchExams(String keyword, String skillFocus, String type) {
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        boolean hasSkill = skillFocus != null && !skillFocus.isBlank();
        boolean hasType = type != null && !type.isBlank();

        // Ưu tiên filter theo type trước (Practice / Mock Test...)
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

    // Lấy danh sách đề luyện tập (type = Practice) cho chức năng #24
    public List<Exam> getPracticeExams() {
        return examDAO.findByType("Practice");
    }

    public void createExam(Exam exam) {
        examDAO.save(exam);
    }

    public void updateExam(Exam exam) {
        if (examDAO.findById(exam.getExamId()) == null)
            throw new IllegalArgumentException("Exam not found: " + exam.getExamId());
        examDAO.update(exam);
    }

    public void deleteExam(int id) {
        examDAO.softDelete(id);
    }
}

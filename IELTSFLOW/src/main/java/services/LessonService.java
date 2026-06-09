package services;

import dao.LessonDAO;
import model.Lesson;
import java.util.List;

public class LessonService {

    private final LessonDAO lessonDAO = new LessonDAO();

    // Lấy tất cả bài học
    public List<Lesson> getAllLessons() {
        return lessonDAO.findAll();
    }

    // Xem chi tiết bài học (#22)
    public Lesson getLessonById(int id) {
        return lessonDAO.findById(id);
    }

    // Tìm kiếm bài học (#21) - hỗ trợ keyword, skill, hoặc kết hợp cả hai
    public List<Lesson> searchLessons(String keyword, String skill) {
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        boolean hasSkill = skill != null && !skill.isBlank();

        if (hasKeyword && hasSkill) {
            return lessonDAO.searchByKeywordAndSkill(keyword, skill);
        } else if (hasKeyword) {
            return lessonDAO.searchByKeyword(keyword);
        } else if (hasSkill) {
            return lessonDAO.findBySkill(skill);
        } else {
            return lessonDAO.findAll();
        }
    }

    public void createLesson(Lesson lesson) {
        lessonDAO.save(lesson);
    }

    public void updateLesson(Lesson lesson) {
        if (lessonDAO.findById(lesson.getLessonId()) == null)
            throw new IllegalArgumentException("Lesson not found: " + lesson.getLessonId());
        lessonDAO.update(lesson);
    }

    public void deleteLesson(int id) {
        lessonDAO.softDelete(id);
    }
}

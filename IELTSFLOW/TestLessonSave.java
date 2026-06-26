import util.JpaHelper;
import model.Lesson;
import java.time.LocalDateTime;

public class TestLessonSave {
    public static void main(String[] args) {
        try {
            Lesson lesson = new Lesson();
            lesson.setTitle("Test Title");
            lesson.setContent("Test Content");
            lesson.setSkill("Listening");
            lesson.setCreatedBy(1);
            lesson.setCreatedAt(LocalDateTime.now());
            lesson.setDeleted(false);
            
            JpaHelper.execute(em -> em.persist(lesson));
            System.out.println("Lesson saved successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

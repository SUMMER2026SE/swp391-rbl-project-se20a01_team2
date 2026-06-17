package dao;

import model.UserLessonProgress;
import util.JpaHelper;

import java.util.List;

public class UserLessonProgressDAO {

    public List<UserLessonProgress> findByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM UserLessonProgress u WHERE u.userId = :userId ORDER BY u.lastAccessed DESC",
                UserLessonProgress.class)
              .setParameter("userId", userId)
              .getResultList()
        );
    }

    public UserLessonProgress findByUserAndLesson(int userId, int lessonId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM UserLessonProgress u WHERE u.userId = :userId AND u.lessonId = :lessonId",
                UserLessonProgress.class)
              .setParameter("userId", userId)
              .setParameter("lessonId", lessonId)
              .getResultStream().findFirst().orElse(null)
        );
    }

    public void save(UserLessonProgress progress) {
        JpaHelper.execute(em -> em.persist(progress));
    }

    public void update(UserLessonProgress progress) {
        JpaHelper.execute(em -> em.merge(progress));
    }

    public void delete(int id) {
        JpaHelper.execute(em -> {
            UserLessonProgress p = em.find(UserLessonProgress.class, id);
            if (p != null) {
                em.remove(p);
            }
        });
    }

    public List<Integer> findInactiveUsers(java.time.LocalDateTime threshold) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u.userId FROM UserLessonProgress u GROUP BY u.userId HAVING MAX(u.lastAccessed) < :threshold",
                Integer.class)
              .setParameter("threshold", threshold)
              .getResultList()
        );
    }
}

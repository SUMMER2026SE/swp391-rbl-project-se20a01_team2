package dao;

import model.UserQuestionBookmark;
import util.JpaHelper;

import java.util.List;

public class UserQuestionBookmarkDAO {

    public List<UserQuestionBookmark> findByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT b FROM UserQuestionBookmark b WHERE b.userId = :userId ORDER BY b.createdAt DESC",
                UserQuestionBookmark.class)
              .setParameter("userId", userId)
              .getResultList()
        );
    }

    public UserQuestionBookmark findByUserAndQuestion(int userId, int questionId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT b FROM UserQuestionBookmark b WHERE b.userId = :userId AND b.questionId = :questionId",
                UserQuestionBookmark.class)
              .setParameter("userId", userId)
              .setParameter("questionId", questionId)
              .getResultStream().findFirst().orElse(null)
        );
    }

    public void save(UserQuestionBookmark bookmark) {
        JpaHelper.execute(em -> em.persist(bookmark));
    }

    public void delete(int id) {
        JpaHelper.execute(em -> {
            UserQuestionBookmark b = em.find(UserQuestionBookmark.class, id);
            if (b != null) {
                em.remove(b);
            }
        });
    }

    public void deleteByUserAndQuestion(int userId, int questionId) {
        JpaHelper.execute(em -> {
            em.createQuery("DELETE FROM UserQuestionBookmark b WHERE b.userId = :userId AND b.questionId = :questionId")
              .setParameter("userId", userId)
              .setParameter("questionId", questionId)
              .executeUpdate();
        });
    }
}

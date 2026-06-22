package dao;

import model.Pathway;
import model.WeeklyPlan;
import util.JpaHelper;
import java.util.List;

public class PathwayDAO {

    // Lấy tất cả pathway
    public List<Pathway> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Pathway p ORDER BY p.createdAt DESC", Pathway.class)
              .getResultList()
        );
    }

    // Tìm pathway theo ID
    public Pathway findById(int id) {
        return JpaHelper.query(em -> em.find(Pathway.class, id));
    }

    // Lấy pathway theo userId (#26)
    public List<Pathway> findByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT p FROM Pathway p WHERE p.userId = :uid ORDER BY p.createdAt DESC",
                Pathway.class)
              .setParameter("uid", userId)
              .getResultList()
        );
    }

    // Lấy tất cả weekly plans của 1 pathway (#26)
    public List<WeeklyPlan> findWeeklyPlansByPathway(int pathwayId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT w FROM WeeklyPlan w WHERE w.pathwayId = :pid ORDER BY w.weekNumber ASC",
                WeeklyPlan.class)
              .setParameter("pid", pathwayId)
              .getResultList()
        );
    }

    // Lấy weekly plan của tuần hiện tại (tuần chưa hoàn thành đầu tiên) (#27)
    public WeeklyPlan findCurrentWeekPlan(int pathwayId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT w FROM WeeklyPlan w WHERE w.pathwayId = :pid AND w.isCompleted = false " +
                "ORDER BY w.weekNumber ASC",
                WeeklyPlan.class)
              .setParameter("pid", pathwayId)
              .setMaxResults(1)
              .getResultStream().findFirst().orElse(null)
        );
    }

    // Lưu pathway mới
    public void savePathway(Pathway pathway) {
        JpaHelper.execute(em -> em.persist(pathway));
    }

    // Lưu weekly plan
    public void saveWeeklyPlan(WeeklyPlan plan) {
        JpaHelper.execute(em -> em.persist(plan));
    }

    // Cập nhật weekly plan (đánh dấu hoàn thành)
    public void updateWeeklyPlan(WeeklyPlan plan) {
        JpaHelper.execute(em -> em.merge(plan));
    }

    // Xóa pathway
    public void deletePathway(int id) {
        JpaHelper.execute(em -> {
            Pathway p = em.find(Pathway.class, id);
            if (p != null) em.remove(p);
        });
    }
}

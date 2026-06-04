package services;

import dao.PathwayDAO;
import model.Pathway;
import model.WeeklyPlan;
import java.util.List;

public class PathwayService {

    private final PathwayDAO pathwayDAO = new PathwayDAO();

    // Lấy tất cả pathway
    public List<Pathway> getAllPathways() {
        return pathwayDAO.findAll();
    }

    // Lấy pathway theo ID
    public Pathway getPathwayById(int id) {
        return pathwayDAO.findById(id);
    }

    // Lấy lộ trình học của user (#26)
    public List<Pathway> getPathwaysByUser(int userId) {
        return pathwayDAO.findByUserId(userId);
    }

    // Lấy toàn bộ weekly plans của 1 lộ trình (#26)
    public List<WeeklyPlan> getWeeklyPlans(int pathwayId) {
        return pathwayDAO.findWeeklyPlansByPathway(pathwayId);
    }

    // Lấy gợi ý học hôm nay = tuần chưa hoàn thành đầu tiên (#27)
    public WeeklyPlan getTodaySuggestion(int userId) {
        List<Pathway> pathways = pathwayDAO.findByUserId(userId);
        if (pathways.isEmpty()) return null;
        // Lấy pathway mới nhất
        Pathway latest = pathways.get(0);
        return pathwayDAO.findCurrentWeekPlan(latest.getPathwayId());
    }

    // Tạo lộ trình mới kèm weekly plans
    public void createPathway(Pathway pathway, List<WeeklyPlan> plans) {
        pathwayDAO.savePathway(pathway);
        for (WeeklyPlan plan : plans) {
            plan.setPathwayId(pathway.getPathwayId());
            pathwayDAO.saveWeeklyPlan(plan);
        }
    }

    // Cập nhật tiến độ weekly plan (đánh dấu hoàn thành)
    public void updateWeeklyPlan(WeeklyPlan plan) {
        pathwayDAO.updateWeeklyPlan(plan);
    }

    // Xóa pathway
    public void deletePathway(int id) {
        pathwayDAO.deletePathway(id);
    }
}

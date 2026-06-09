package services;

import dao.DashboardDAO;
import model.SystemLog;
import services.SystemLogService;

import java.util.Date;
import java.util.List;

public class SystemLogServiceImpl implements SystemLogService {
    private DashboardDAO dashboardDAO;

    public SystemLogServiceImpl() {
        this.dashboardDAO = new DashboardDAO();
    }

    @Override
    public List<SystemLog> filterSystemLogs(Integer userId, String action, String entity, Date fromDate, Date toDate, int limit) {
        return dashboardDAO.filterSystemLogs(userId, action, entity, fromDate, toDate, limit);
    }
}

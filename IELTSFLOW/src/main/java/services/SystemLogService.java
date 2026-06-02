package services;

import model.SystemLog;
import java.util.Date;
import java.util.List;

public interface SystemLogService {
    List<SystemLog> filterSystemLogs(Integer userId, String action, String entity, Date fromDate, Date toDate, int limit);
}

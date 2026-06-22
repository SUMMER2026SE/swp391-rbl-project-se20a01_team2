package dao;

import model.SystemLog;
import util.JpaHelper;

public class SystemLogDAO {
    
    public void createSystemLog(SystemLog systemLog) {
        JpaHelper.execute(em -> em.persist(systemLog));
    }
}

package listener;

import jakarta.persistence.PostPersist;
import jakarta.persistence.PostRemove;
import jakarta.persistence.PostUpdate;
import model.SystemLog;
import util.JpaHelper;
import util.UserContext;

/**
 * Listener gắn vào các Entity để tự động ghi log mọi thay đổi (Insert/Update/Delete).
 */
public class AuditEntityListener {

    @PostPersist
    public void postPersist(Object target) {
        logAudit("CREATE", target);
    }

    @PostUpdate
    public void postUpdate(Object target) {
        logAudit("UPDATE", target);
    }

    @PostRemove
    public void postRemove(Object target) {
        logAudit("DELETE", target);
    }

    private void logAudit(String action, Object target) {
        Integer userId = UserContext.getCurrentUserId();
        String entityName = target.getClass().getSimpleName();
        
        // Trích xuất thông tin chi tiết bằng Reflection (nếu cần) 
        // Hoặc đơn giản là dùng toString() của đối tượng đó.
        String details = "Auto " + action + " for " + entityName + ": " + target.toString();
        // Giới hạn độ dài để không tràn cột
        if (details.length() > 500) {
            details = details.substring(0, 497) + "...";
        }

        SystemLog log = new SystemLog(userId, action, entityName, details);

        // Mở một Transaction mới (độc lập) để lưu Log
        // Lưu ý: JpaHelper.execute() sẽ tạo một EntityManager mới
        try {
            JpaHelper.execute(em -> {
                em.persist(log);
            });
        } catch (Exception e) {
            // Không làm gián đoạn luồng chính nếu ghi log thất bại
            e.printStackTrace();
            System.err.println("Ghi Audit Log thất bại: " + e.getMessage());
        }
    }
}

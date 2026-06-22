package listener;

import jakarta.persistence.PostPersist;
import jakarta.persistence.PostRemove;
import jakarta.persistence.PostUpdate;
import jakarta.persistence.PreUpdate;
import model.SystemLog;
import util.JpaHelper;
import util.UserContext;

import java.lang.reflect.Field;
import java.util.Objects;

/**
 * Listener gắn vào các Entity để tự động ghi log mọi thay đổi (Insert/Update/Delete).
 */
public class AuditEntityListener {

    // ThreadLocal để truyền chuỗi diff từ PreUpdate sang PostUpdate (cùng 1 thread)
    private static final ThreadLocal<String> updateDiff = new ThreadLocal<>();

    @PostPersist
    public void postPersist(Object target) {
        String entityName = target.getClass().getSimpleName();
        String details = "Tạo mới " + entityName + " (ID: " + extractId(target) + ")";
        logAudit("CREATE", target, details);
    }

    @PreUpdate
    public void preUpdate(Object target) {
        try {
            Object id = extractId(target);
            if (id != null && !id.equals("Unknown")) {
                // Mở một EntityManager mới để lấy dữ liệu cũ từ Database
                String diff = JpaHelper.query(em -> {
                    Object oldEntity = em.find(target.getClass(), id);
                    return compareDiff(oldEntity, target);
                });
                updateDiff.set(diff);
            }
        } catch (Exception e) {
            updateDiff.set("Cập nhật " + target.getClass().getSimpleName() + " (ID: " + extractId(target) + ")");
        }
    }

    @PostUpdate
    public void postUpdate(Object target) {
        String diff = updateDiff.get();
        if (diff == null || diff.isEmpty()) {
            diff = "Cập nhật " + target.getClass().getSimpleName() + " (ID: " + extractId(target) + ")";
        }
        logAudit("UPDATE", target, diff);
        updateDiff.remove(); // Tránh memory leak
    }

    @PostRemove
    public void postRemove(Object target) {
        String entityName = target.getClass().getSimpleName();
        String details = "Xóa " + entityName + " (ID: " + extractId(target) + ")";
        logAudit("DELETE", target, details);
    }

    private void logAudit(String action, Object target, String details) {
        Integer userId = UserContext.getCurrentUserId();
        String entityName = target.getClass().getSimpleName();
        
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

    // --- CÁC HÀM TRỢ GIÚP REFLECTION ---

    private Object extractId(Object target) {
        for (Field field : target.getClass().getDeclaredFields()) {
            if (field.isAnnotationPresent(jakarta.persistence.Id.class)) {
                try {
                    field.setAccessible(true);
                    return field.get(target);
                } catch (Exception ignored) {}
            }
        }
        return "Unknown";
    }

    private String compareDiff(Object oldEntity, Object newEntity) {
        if (oldEntity == null || newEntity == null) return "";
        StringBuilder diff = new StringBuilder("Thay đổi: ");
        boolean hasChange = false;
        
        for (Field field : oldEntity.getClass().getDeclaredFields()) {
            // Bỏ qua các field là collection (danh sách) hoặc Transient để tránh lỗi
            if (java.util.Collection.class.isAssignableFrom(field.getType()) || 
                field.isAnnotationPresent(jakarta.persistence.Transient.class)) {
                continue;
            }
            try {
                field.setAccessible(true);
                Object oldValue = field.get(oldEntity);
                Object newValue = field.get(newEntity);
                
                if (!Objects.equals(oldValue, newValue)) {
                    diff.append(field.getName()).append(" từ '").append(oldValue).append("' sang '").append(newValue).append("', ");
                    hasChange = true;
                }
            } catch (Exception ignored) {}
        }
        
        if (hasChange) {
            return diff.substring(0, diff.length() - 2); // Bỏ dấu phẩy cuối
        }
        return "Cập nhật dữ liệu";
    }
}

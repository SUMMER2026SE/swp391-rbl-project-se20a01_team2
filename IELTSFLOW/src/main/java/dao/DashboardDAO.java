/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ntpho
 */

import util.JpaHelper;
import java.math.BigDecimal;
import java.util.List;
import java.util.Date;
import jakarta.persistence.TypedQuery;
import model.SystemLog;

public class DashboardDAO {
    
    // Task 53: Thống kê tổng doanh thu từ các giao dịch thành công
    public BigDecimal getTotalRevenue() {
        return JpaHelper.query(em -> {
            BigDecimal total = em.createQuery("SELECT SUM(t.amount) FROM Transaction t WHERE t.status = 'Success'", BigDecimal.class)
                                 .getSingleResult();
            return total != null ? total : BigDecimal.ZERO;
        });
    }
    
    // Task 54: Thống kê lượng user đang Active (Dùng Native Query để độc lập với code của Minh)
    public Long getTotalActiveUsers() {
        return JpaHelper.query(em -> {
            Number count = (Number) em.createNativeQuery("SELECT COUNT(*) FROM Users WHERE Status = 'Active'")
                                      .getSingleResult();
            return count != null ? count.longValue() : 0L;
        });
    }
    
    // Task 54: Thống kê tổng bài test đã thực hiện 
    public Long getTotalTestSubmissions() {
        return JpaHelper.query(em -> {
            Number count = (Number) em.createNativeQuery("SELECT COUNT(*) FROM TestSubmissions")
                                      .getSingleResult();
            return count != null ? count.longValue() : 0L;
        });
    }

    // Task 55: Lấy danh sách Log hệ thống gần đây
    public List<SystemLog> getRecentSystemLogs(int limit) {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT l FROM SystemLog l ORDER BY l.createdAt DESC", SystemLog.class)
              .setMaxResults(limit)
              .getResultList()
        );
    }
    
    // Thêm Log hệ thống (Bạn và các team member khác đều có thể gọi hàm này để lưu Log)
    public void addSystemLog(SystemLog log) {
        JpaHelper.execute(em -> em.persist(log));
    }

    // Task 54: Lọc Log hệ thống
    public List<SystemLog> filterSystemLogs(Integer userId, String action, String entity, Date fromDate, Date toDate, int limit) {
        return JpaHelper.query(em -> {
            StringBuilder jpql = new StringBuilder("SELECT l FROM SystemLog l WHERE 1=1");
            if (userId != null) {
                jpql.append(" AND l.userId = :userId");
            }
            if (action != null && !action.isEmpty()) {
                jpql.append(" AND l.action = :action");
            }
            if (entity != null && !entity.isEmpty()) {
                jpql.append(" AND l.entity = :entity");
            }
            if (fromDate != null) {
                jpql.append(" AND l.createdAt >= :fromDate");
            }
            if (toDate != null) {
                jpql.append(" AND l.createdAt <= :toDate");
            }
            jpql.append(" ORDER BY l.createdAt DESC");

            TypedQuery<SystemLog> query = em.createQuery(jpql.toString(), SystemLog.class);
            
            if (userId != null) query.setParameter("userId", userId);
            if (action != null && !action.isEmpty()) query.setParameter("action", action);
            if (entity != null && !entity.isEmpty()) query.setParameter("entity", entity);
            if (fromDate != null) query.setParameter("fromDate", fromDate);
            if (toDate != null) query.setParameter("toDate", toDate);

            return query.setMaxResults(limit).getResultList();
        });
    }
}
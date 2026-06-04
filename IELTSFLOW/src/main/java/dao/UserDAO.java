package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.User;
import util.JpaHelper;

import java.util.Optional;

/**
 * Lá»›p DAO xá»­ lÃ½ dá»¯ liá»‡u ngÆ°á»i dÃ¹ng (User) sá»­ dá»¥ng JPA
 */
public class UserDAO {

    /**
     * TÃ¬m ngÆ°á»i dÃ¹ng qua email
     * @param email Email cáº§n tÃ¬m
     * @return Optional chá»©a User náº¿u tÃ¬m tháº¥y
     */
    public Optional<User> findByEmail(String email) {
        return JpaHelper.query(em -> {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            try {
                return Optional.of(query.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        });
    }

    /**
     * TÃ¬m ngÆ°á»i dÃ¹ng qua ID
     * @param userId ID ngÆ°á»i dÃ¹ng
     * @return Optional chá»©a User náº¿u tÃ¬m tháº¥y
     */
    public Optional<User> findById(int userId) {
        return JpaHelper.query(em -> Optional.ofNullable(em.find(User.class, userId)));
    }

    /**
     * Kiá»ƒm tra email Ä‘Ã£ tá»“n táº¡i chÆ°a
     * @param email Email cáº§n kiá»ƒm tra
     * @return true náº¿u Ä‘Ã£ tá»“n táº¡i
     */
    public boolean emailExists(String email) {
        return JpaHelper.query(em -> {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class);
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        });
    }

    /**
     * Táº¡o má»›i ngÆ°á»i dÃ¹ng
     * @param user Äá»‘i tÆ°á»£ng User
     * @return UserID vá»«a Ä‘Æ°á»£c táº¡o
     */
    public int create(User user) {
        JpaHelper.execute(em -> em.persist(user));
        return user.getUserId();
    }

    /**
     * Cáº­p nháº­t tráº¡ng thÃ¡i ngÆ°á»i dÃ¹ng
     * @param userId ID ngÆ°á»i dÃ¹ng
     * @param status Tráº¡ng thÃ¡i má»›i (VD: "Active", "Inactive")
     * @return true náº¿u thÃ nh cÃ´ng
     */
    public boolean updateStatus(int userId, String status) {
        try {
            JpaHelper.execute(em -> {
                User user = em.find(User.class, userId);
                if (user != null) {
                    user.setStatus(status);
                }
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cáº­p nháº­t máº­t kháº©u ngÆ°á»i dÃ¹ng
     * @param userId ID ngÆ°á»i dÃ¹ng
     * @param newPasswordHash Hash máº­t kháº©u má»›i
     * @return true náº¿u thÃ nh cÃ´ng
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        try {
            JpaHelper.execute(em -> {
                User user = em.find(User.class, userId);
                if (user != null) {
                    user.setPasswordHash(newPasswordHash);
                }
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Láº¥y ID cá»§a quyá»n Candidate (Há»c viÃªn)
     * @return RoleID cá»§a Candidate (máº·c Ä‘á»‹nh lÃ  3 náº¿u khÃ´ng tÃ¬m tháº¥y)
     */
    public int getCandidateRoleId() {
        return JpaHelper.query(em -> {
            try {
                Object result = em.createNativeQuery("SELECT RoleID FROM Roles WHERE RoleName = 'Candidate'").getSingleResult();
                if (result != null) {
                    return ((Number) result).intValue();
                }
            } catch (NoResultException e) {
                // Fallback náº¿u khÃ´ng cÃ³
            }
            return 3;
        });
    }

    /**
     * Láº¥y danh sÃ¡ch táº¥t cáº£ user cho trang Admin (tráº£ vá» Map Ä‘á»ƒ trÃ¡nh serialize toÃ n bá»™ entity)
     */
    public java.util.List<java.util.Map<String, Object>> findAllForAdmin() {
        return JpaHelper.query(em -> {
            java.util.List<User> users = em.createQuery("SELECT u FROM User u ORDER BY u.createdAt DESC", User.class)
                    .getResultList();
            java.util.List<java.util.Map<String, Object>> result = new java.util.ArrayList<>();
            for (User u : users) {
                java.util.Map<String, Object> m = new java.util.LinkedHashMap<>();
                m.put("userId",       u.getUserId());
                m.put("fullName",     u.getFullName());
                m.put("email",        u.getEmail());
                m.put("roleId",       u.getRoleId());
                m.put("status",       u.getStatus());
                m.put("authProvider", u.getAuthProvider());
                m.put("createdAt",    u.getCreatedAt() != null ? u.getCreatedAt().toString() : null);
                result.add(m);
            }
            return result;
        });
    }

    /**
     * Thá»‘ng kÃª nhanh cho Admin Dashboard
     */
    public java.util.Map<String, Object> getStats() {
        return JpaHelper.query(em -> {
            java.util.Map<String, Object> stats = new java.util.LinkedHashMap<>();

            Long total = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
            stats.put("totalUsers", total);

            Long active = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.status = 'Active'", Long.class).getSingleResult();
            stats.put("activeUsers", active);

            Long banned = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.status = 'Banned'", Long.class).getSingleResult();
            stats.put("bannedUsers", banned);

            Long googleUsers = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.authProvider = 'Google'", Long.class).getSingleResult();
            stats.put("googleUsers", googleUsers);

            Long newToday = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.createdAt >= :startOfDay", Long.class)
                .setParameter("startOfDay", java.time.LocalDateTime.now().toLocalDate().atStartOfDay())
                .getSingleResult();
            stats.put("newToday", newToday);

            return stats;
        });
    }

    /**
     * Cáº­p nháº­t fullName ngÆ°á»i dÃ¹ng
     */
    public boolean updateFullName(int userId, String fullName) {
        try {
            JpaHelper.execute(em -> {
                User user = em.find(User.class, userId);
                if (user != null) {
                    user.setFullName(fullName);
                }
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy toàn bộ user (dùng cho broadcast notification)
     */
    public java.util.List<User> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT u FROM User u", User.class).getResultList()
        );
    }
}




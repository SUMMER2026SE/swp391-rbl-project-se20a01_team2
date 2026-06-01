package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.User;
import util.JpaHelper;

import java.util.Optional;

/**
 * Lớp DAO xử lý dữ liệu người dùng (User) sử dụng JPA
 */
public class UserDAO {

    /**
     * Tìm người dùng qua email
     * @param email Email cần tìm
     * @return Optional chứa User nếu tìm thấy
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
     * Tìm người dùng qua ID
     * @param userId ID người dùng
     * @return Optional chứa User nếu tìm thấy
     */
    public Optional<User> findById(int userId) {
        return JpaHelper.query(em -> Optional.ofNullable(em.find(User.class, userId)));
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     * @param email Email cần kiểm tra
     * @return true nếu đã tồn tại
     */
    public boolean emailExists(String email) {
        return JpaHelper.query(em -> {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class);
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        });
    }

    /**
     * Tạo mới người dùng
     * @param user Đối tượng User
     * @return UserID vừa được tạo
     */
    public int create(User user) {
        JpaHelper.execute(em -> em.persist(user));
        return user.getUserId();
    }

    /**
     * Cập nhật trạng thái người dùng
     * @param userId ID người dùng
     * @param status Trạng thái mới (VD: "Active", "Inactive")
     * @return true nếu thành công
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
     * Cập nhật mật khẩu người dùng
     * @param userId ID người dùng
     * @param newPasswordHash Hash mật khẩu mới
     * @return true nếu thành công
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
     * Lấy ID của quyền Candidate (Học viên)
     * @return RoleID của Candidate (mặc định là 3 nếu không tìm thấy)
     */
    public int getCandidateRoleId() {
        return JpaHelper.query(em -> {
            try {
                Object result = em.createNativeQuery("SELECT RoleID FROM Roles WHERE RoleName = 'Candidate'").getSingleResult();
                if (result != null) {
                    return ((Number) result).intValue();
                }
            } catch (NoResultException e) {
                // Fallback nếu không có
            }
            return 3;
        });
    }

    /**
     * Lấy danh sách tất cả user cho trang Admin (trả về Map để tránh serialize toàn bộ entity)
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
     * Thống kê nhanh cho Admin Dashboard
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
     * Cập nhật fullName người dùng
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
}

package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.User;
import util.JpaHelper;

import java.util.Optional;
import java.util.List;

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
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.deleted = false", User.class);
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
        return JpaHelper.query(em -> {
            User u = em.find(User.class, userId);
            return (u != null && !u.isDeleted()) ? Optional.of(u) : Optional.empty();
        });
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     * @param email Email cần kiểm tra
     * @return true nếu đã tồn tại
     */
    public boolean emailExists(String email) {
        return JpaHelper.query(em -> {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email AND u.deleted = false", Long.class);
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
                if (user != null && !user.isDeleted()) {
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
                if (user != null && !user.isDeleted()) {
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
     * Thống kê nhanh cho Admin Dashboard
     */
    public java.util.Map<String, Object> getStats() {
        return JpaHelper.query(em -> {
            java.util.Map<String, Object> stats = new java.util.LinkedHashMap<>();

            Long total = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.deleted = false", Long.class).getSingleResult();
            stats.put("totalUsers", total);

            Long active = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.status = 'Active' AND u.deleted = false", Long.class).getSingleResult();
            stats.put("activeUsers", active);

            Long banned = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.status = 'Banned' AND u.deleted = false", Long.class).getSingleResult();
            stats.put("bannedUsers", banned);

            Long googleUsers = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.authProvider = 'Google' AND u.deleted = false", Long.class).getSingleResult();
            stats.put("googleUsers", googleUsers);

            Long newToday = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.createdAt >= :startOfDay AND u.deleted = false", Long.class)
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
                if (user != null && !user.isDeleted()) {
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
     * Lấy toàn bộ user
     */
    public List<User> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT u FROM User u WHERE u.deleted = false ORDER BY u.createdAt DESC", User.class).getResultList()
        );
    }

    // Lọc user theo roleId (#49)
    public List<User> findByRole(int roleId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM User u WHERE u.roleId = :roleId AND u.deleted = false",
                User.class)
              .setParameter("roleId", roleId)
              .getResultList()
        );
    }

    // Cập nhật thông tin user - chỉ cho phép sửa fullName, email, status (#48)
    public void update(User user) {
        JpaHelper.execute(em -> {
            User existing = em.find(User.class, user.getUserId());
            if (existing == null || existing.isDeleted()) return;
            existing.setFullName(user.getFullName());
            existing.setEmail(user.getEmail());
            existing.setStatus(user.getStatus());
            em.merge(existing);
        });
    }



    // Phân quyền Mentor (#49) - roleId: 1=Admin, 2=Mentor, 3=Candidate
    public void setRole(int userId, int roleId) {
        JpaHelper.execute(em -> {
            User u = em.find(User.class, userId);
            if (u != null && !u.isDeleted()) { u.setRoleId(roleId); em.merge(u); }
        });
    }

    // Soft delete user (#48)
    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            User u = em.find(User.class, id);
            if (u != null) { u.setDeleted(true); em.merge(u); }
        });
    }
}

package dao;

import model.User;
import util.JpaHelper;
import java.util.List;

public class UserDAO {

    // Lấy tất cả user chưa bị xóa (#48)
    public List<User> findAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM User u WHERE u.deleted = false ORDER BY u.createdAt DESC",
                User.class)
              .getResultList()
        );
    }

    // Lấy user theo ID
    public User findById(int id) {
        return JpaHelper.query(em -> {
            User u = em.find(User.class, id);
            return (u != null && !u.isDeleted()) ? u : null;
        });
    }

    // Tìm user theo email
    public User findByEmail(String email) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM User u WHERE u.email = :email AND u.deleted = false",
                User.class)
              .setParameter("email", email)
              .getResultStream().findFirst().orElse(null)
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

    // Thêm user mới (#48)
    public void save(User user) {
        JpaHelper.execute(em -> em.persist(user));
    }

    // Cập nhật thông tin user - chỉ cho phép sửa fullName, email, status (#48)
    public void update(User user) {
        JpaHelper.execute(em -> {
            User existing = em.find(User.class, user.getUserId());
            if (existing == null) return;
            existing.setFullName(user.getFullName());
            existing.setEmail(user.getEmail());
            existing.setStatus(user.getStatus());
            em.merge(existing);
        });
    }

    // Khóa tài khoản (#48) - set status = Banned
    public void lockUser(int id) {
        JpaHelper.execute(em -> {
            User u = em.find(User.class, id);
            if (u != null) { u.setStatus("Banned"); em.merge(u); }
        });
    }

    // Phân quyền Mentor (#49) - roleId: 1=Admin, 2=Mentor, 3=Candidate
    public void setRole(int userId, int roleId) {
        JpaHelper.execute(em -> {
            User u = em.find(User.class, userId);
            if (u != null) { u.setRoleId(roleId); em.merge(u); }
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

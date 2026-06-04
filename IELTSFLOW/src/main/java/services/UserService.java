package services;

import dao.UserDAO;
import model.User;
import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    // RoleID constants theo DB seed data
    public static final int ROLE_ADMIN     = 1;
    public static final int ROLE_MENTOR    = 2;
    public static final int ROLE_CANDIDATE = 3;

    // Lấy tất cả user (#48)
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    // Lấy user theo ID
    public User getUserById(int id) {
        return userDAO.findById(id);
    }

    // Lấy user theo email
    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    // Lấy danh sách Mentor (#49)
    public List<User> getMentors() {
        return userDAO.findByRole(ROLE_MENTOR);
    }

    // Thêm user mới (#48)
    public void createUser(User user) {
        if (userDAO.findByEmail(user.getEmail()) != null)
            throw new IllegalArgumentException("Email đã tồn tại: " + user.getEmail());
        // Mặc định là Candidate nếu không chỉ định role
        if (user.getRoleId() == 0) user.setRoleId(ROLE_CANDIDATE);
        userDAO.save(user);
    }

    // Cập nhật user - chỉ cho phép sửa fullName, email, status (#48)
    public void updateUser(int id, String fullName, String email, String status) {
        User existing = userDAO.findById(id);
        if (existing == null) throw new IllegalArgumentException("User not found: " + id);
        existing.setFullName(fullName);
        existing.setEmail(email);
        existing.setStatus(status);
        userDAO.update(existing);
    }

    // Khóa tài khoản (#48)
    public void lockUser(int id) {
        User user = userDAO.findById(id);
        if (user == null) throw new IllegalArgumentException("User not found: " + id);
        userDAO.lockUser(id);
    }

    // Phân quyền Mentor (#49) - chỉ Admin mới được gọi endpoint này
    public void assignMentorRole(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) throw new IllegalArgumentException("User not found: " + userId);
        userDAO.setRole(userId, ROLE_MENTOR);
    }

    // Thu hồi quyền Mentor -> về Candidate (#49)
    public void revokeMentorRole(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) throw new IllegalArgumentException("User not found: " + userId);
        userDAO.setRole(userId, ROLE_CANDIDATE);
    }

    // Xóa mềm user (#48)
    public void deleteUser(int id) {
        userDAO.softDelete(id);
    }
}

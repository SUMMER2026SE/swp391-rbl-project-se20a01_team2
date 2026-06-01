package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;

/**
 * Thực thể User (Người dùng)
 */
@Entity
@Table(name = "Users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserID")
    private int userId;

    @Column(name = "RoleID")
    private int roleId;

    @Column(name = "Email", unique = true)
    private String email;

    @Column(name = "PasswordHash")
    private String passwordHash;

    @Column(name = "AuthProvider")
    private String authProvider; // "Local", "Google", "Facebook"

    @Column(name = "ProviderID")
    private String providerId;

    @Column(name = "FullName")
    private String fullName;

    @Column(name = "Status")
    private String status; // "Active", "Inactive", "Banned"

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    // Các hàm khởi tạo
    public User() {
    }

    public User(int roleId, String email, String passwordHash, String fullName) {
        this.roleId = roleId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.authProvider = "Local";
        this.status = "Inactive"; // Đổi thành Inactive để yêu cầu xác thực email
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(String authProvider) {
        this.authProvider = authProvider;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

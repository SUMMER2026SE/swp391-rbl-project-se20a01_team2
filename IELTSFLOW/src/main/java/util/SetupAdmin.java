package util;

import dao.UserDAO;
import model.User;

public class SetupAdmin {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        String adminEmail = "admin@ieltsflow.com";
        String adminPassword = "AdminPassword123!";
        
        System.out.println("Checking if admin exists...");
        if (userDAO.emailExists(adminEmail)) {
            System.out.println("Admin account already exists: " + adminEmail);
        } else {
            System.out.println("Creating admin account...");
            String hash = PasswordUtil.hashPassword(adminPassword);
            User admin = new User(1, adminEmail, hash, "System Admin");
            admin.setStatus("Active");
            int id = userDAO.create(admin);
            System.out.println("Admin created successfully with ID: " + id);
            System.out.println("Email: " + adminEmail);
            System.out.println("Password: " + adminPassword);
        }
    }
}

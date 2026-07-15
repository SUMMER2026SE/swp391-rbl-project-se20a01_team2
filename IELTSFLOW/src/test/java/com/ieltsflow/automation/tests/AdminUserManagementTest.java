package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.AdminUserManagementPage;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AdminUserManagementTest extends BaseTest {

    @Test
    @Order(1)
    @DisplayName("[Happy Path] Test Case 1.1: Ban/Lock User & Verify Login")
    public void testLockUserAndVerifyLogin() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        // Assume admin account
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminUserManagementPage adminPage = new AdminUserManagementPage(driver);
        adminPage.navigate();

        // Find user by email
        int targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        Assertions.assertTrue(targetRow >= 0, "Candidate user not found in the table");
        
        // Lock user
        adminPage.clickLockInRow(targetRow);
        adminPage.confirmAction();
        
        // Re-fetch row index in case sorting changed after reload
        targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        
        String newStatus = adminPage.getUserStatusInRow(targetRow);
        Assertions.assertTrue(newStatus.equals("Inactive") || newStatus.equals("Banned"), "Status did not change to Inactive/Banned");

        // Verify login fails for this user
        loginPage.navigate();
        loginPage.login(ConfigReader.getCandidateEmail(), ConfigReader.getCandidatePassword());
        Assertions.assertTrue(loginPage.isErrorDisplayed(), "Error message should be displayed for locked user");
    }

    @Test
    @Order(2)
    @DisplayName("[Happy Path] Test Case 1.2: Unlock User")
    public void testUnlockUser() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminUserManagementPage adminPage = new AdminUserManagementPage(driver);
        adminPage.navigate();

        // Find user by email
        int targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        Assertions.assertTrue(targetRow >= 0, "Candidate user not found in the table");

        // Unlock user
        adminPage.clickUnlockInRow(targetRow);
        adminPage.confirmAction();
        
        // Re-fetch row index in case sorting changed after reload
        targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        
        String newStatus = adminPage.getUserStatusInRow(targetRow);
        Assertions.assertEquals(newStatus, "Active", "Status did not change to Active");
    }

    @Test
    @Order(3)
    @DisplayName("[Happy Path] Test Case 1.3: Change Role to Mentor & Verify Login")
    public void testChangeRoleToMentorAndVerify() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminUserManagementPage adminPage = new AdminUserManagementPage(driver);
        adminPage.navigate();

        // Find user by email
        int targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        Assertions.assertTrue(targetRow >= 0, "Candidate user not found in the table");
        
        // 2 is Mentor role value
        adminPage.clickEditInRow(targetRow);
        adminPage.changeRoleAndSave("2");

        // Re-fetch row index in case sorting changed after reload
        targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());

        String newRole = adminPage.getUserRoleInRow(targetRow);
        Assertions.assertEquals(newRole, "Mentor", "Role did not change to Mentor");
        
        // Login as the promoted user to verify
        loginPage.navigate();
        loginPage.login(ConfigReader.getCandidateEmail(), ConfigReader.getCandidatePassword());
        loginPage.waitForLoginSuccess();
        // Verification happens if login redirects to mentor dashboard
        Assertions.assertTrue(driver.getCurrentUrl().contains("/mentor/"), "Not redirected to mentor dashboard");
    }

    @Test
    @Order(4)
    @DisplayName("[Happy Path] Test Case 1.4: Revoke Mentor Role")
    public void testRevokeMentorRole() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminUserManagementPage adminPage = new AdminUserManagementPage(driver);
        adminPage.navigate();

        // Find user by email
        int targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());
        Assertions.assertTrue(targetRow >= 0, "Candidate user not found in the table");
        
        // 3 is Candidate role value
        adminPage.clickEditInRow(targetRow);
        adminPage.changeRoleAndSave("3");

        // Re-fetch row index in case sorting changed after reload
        targetRow = adminPage.getRowIndexByEmail(ConfigReader.getCandidateEmail());

        String newRole = adminPage.getUserRoleInRow(targetRow);
        Assertions.assertEquals("Candidate", newRole, "Role did not change to Candidate");
        
        // Verify login as candidate does not go to mentor dashboard
        loginPage.navigate();
        loginPage.login(ConfigReader.getCandidateEmail(), ConfigReader.getCandidatePassword());
        loginPage.waitForLoginSuccess();
        
        Assertions.assertFalse(driver.getCurrentUrl().contains("/mentor/"), "Revoked user should not be redirected to mentor dashboard");
    }

    @Test
    @Order(5)
    @DisplayName("[Unhappy Path] Test Case 1.5: Search non-existent user")
    public void testSearchNonExistentUser() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminUserManagementPage adminPage = new AdminUserManagementPage(driver);
        adminPage.navigate();

        adminPage.searchUser("invalid_user_123");
        
        Assertions.assertTrue(adminPage.isNoResultMessageDisplayed(), "No result message should be displayed");
        Assertions.assertEquals(adminPage.getRowsCount(), 0, "Rows count should be 0");
    }
}

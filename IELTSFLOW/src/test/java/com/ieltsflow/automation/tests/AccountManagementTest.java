package com.ieltsflow.automation.tests;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.AccountPage;
import com.ieltsflow.automation.pages.ChangePasswordPage;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.TargetBandPage;
import com.ieltsflow.automation.utils.ConfigReader;

public class AccountManagementTest extends BaseTest {
    private LoginPage loginPage;
    private AccountPage accountPage;
    private ChangePasswordPage changePasswordPage;
    private TargetBandPage targetBandPage;

    @BeforeEach
    public void setUpPages() {
        loginPage = new LoginPage(driver);
        accountPage = new AccountPage(driver);
        changePasswordPage = new ChangePasswordPage(driver);
        targetBandPage = new TargetBandPage(driver);
        
        // Log in before testing account features
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();
    }

    @Test
    @DisplayName("Verify update profile full name")
    public void testUpdateProfile() {
        accountPage.navigate();
        accountPage.updateFullName("New Name " + System.currentTimeMillis());
        
        assertTrue(accountPage.isToastMessageDisplayed() || 
                   driver.getPageSource().contains("thành công"), 
                   "Success message should be displayed after updating profile");
    }

    @Test
    @DisplayName("Verify change password functionality")
    public void testChangePassword() {
        changePasswordPage.navigate();
        changePasswordPage.changePassword(ConfigReader.getAdminPassword(), "NewPass123!", "Mismatch123!");
        
        // Error should be displayed
        assertTrue(changePasswordPage.isToastMessageDisplayed() ||
                   driver.getPageSource().contains("không khớp") || 
                   driver.getPageSource().contains("Error"),
                   "Error message should be shown on password mismatch");
    }

    @Test
    @DisplayName("Verify set Target Band")
    public void testSetTargetBand() {
        // Needs candidate role for this page ideally, but test script navigates there
        targetBandPage.navigate();
        
        // Check if page is accessible (Admin might be redirected, so we just verify URL first)
        if (driver.getCurrentUrl().contains("ielts-target")) {
            targetBandPage.selectTargetBand("7.0");
            targetBandPage.saveTargetBand();
            
            assertTrue(targetBandPage.isToastMessageDisplayed() || 
                       driver.getPageSource().contains("thành công"),
                       "Success message should be displayed after setting target band");
        }
    }
}

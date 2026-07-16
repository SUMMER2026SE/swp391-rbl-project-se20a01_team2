package com.ieltsflow.automation.tests;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.RegisterPage;
import com.ieltsflow.automation.utils.ConfigReader;

public class AuthenticationTest extends BaseTest {
    private LoginPage loginPage;
    private RegisterPage registerPage;

    @BeforeEach
    public void setUpPages() {
        loginPage = new LoginPage(driver);
        registerPage = new RegisterPage(driver);
    }

    @Test
    @DisplayName("Verify valid login")
    public void testValidLogin() {
        // Assume default admin or user exists based on DB script
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();
        
        // Assert we are not on the auth page anymore
        assertTrue(!driver.getCurrentUrl().contains("/auth"), "URL should not contain auth after successful login");
    }

    @Test
    @DisplayName("Verify invalid login - Wrong password")
    public void testInvalidLogin() {
        loginPage.login("wrong@example.com", "wrongpassword");
        
        assertTrue(loginPage.isErrorDisplayed(), "Error message should be displayed");
    }

    @Test
    @DisplayName("Verify valid registration")
    public void testValidRegistration() {
        registerPage.navigate();
        
        String uniqueEmail = "testuser" + System.currentTimeMillis() + "@example.com";
        registerPage.register("Test User", uniqueEmail, "Password123!", "Password123!", true);
        
        // Wait for redirect to login or success message
        // Usually, registration redirects to auth with a success message or automatically logs in
        loginPage.waitForLoginSuccess();
        assertTrue(!driver.getCurrentUrl().contains("/auth"), "Should redirect to dashboard after successful registration");
    }

    @Test
    @DisplayName("Verify invalid registration - Password mismatch")
    public void testPasswordMismatchRegistration() {
        registerPage.navigate();
        
        String uniqueEmail = "testuser" + System.currentTimeMillis() + "@example.com";
        registerPage.register("Test User", uniqueEmail, "Password123!", "DifferentPass123!", true);
        
        assertTrue(registerPage.isErrorDisplayed(), "Error message should be displayed for password mismatch");
    }

    @Test
    @DisplayName("Verify invalid registration - Existing email")
    public void testExistingEmailRegistration() {
        registerPage.navigate();
        
        // Register with an existing email (e.g. admin email)
        registerPage.register("Admin User", ConfigReader.getAdminEmail(), "Password123!", "Password123!", true);
        
        assertTrue(registerPage.isErrorDisplayed(), "Error message should be displayed for existing email");
    }
}

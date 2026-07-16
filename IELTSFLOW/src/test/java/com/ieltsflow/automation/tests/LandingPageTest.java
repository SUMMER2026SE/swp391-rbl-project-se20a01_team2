package com.ieltsflow.automation.tests;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LandingPage;

public class LandingPageTest extends BaseTest {
    private LandingPage landingPage;

    @BeforeEach
    public void setUpPages() {
        landingPage = new LandingPage(driver);
    }

    @Test
    @DisplayName("Verify Landing Page UI Elements")
    public void testLandingPageUI() {
        landingPage.navigate();
        
        assertTrue(landingPage.isLogoDisplayed(), "Logo should be displayed on the landing page.");
        assertTrue(landingPage.isHeroTitleDisplayed(), "Hero title should be displayed on the landing page.");
    }

    @Test
    @DisplayName("Verify Navigation to Login")
    public void testNavigationToLogin() {
        landingPage.navigate();
        landingPage.clickLogin();
        
        // Wait and verify URL
        assertTrue(driver.getCurrentUrl().contains("auth"), "URL should contain 'auth'");
    }
}

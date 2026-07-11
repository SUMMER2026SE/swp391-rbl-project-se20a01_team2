package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.mentor.LoginPage;
import com.ieltsflow.automation.pages.mentor.MockTestPage;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class MockTestManagementTest extends BaseTest {

    @Test
    @DisplayName("Create Mock Test and Add Questions")
    public void testCreateMockTestFlow() {
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/exams");
        MockTestPage mockTestPage = new MockTestPage(driver);
        
        mockTestPage.createMockTest("IELTS Academic Mock Test 1", "120");
        mockTestPage.openFirstMockTest();
        mockTestPage.addSectionToMockTest("Reading Passage 1");
    }
}

package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.mentor.MockTestPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class MockTestManagementTest extends BaseTest {

    @Test
    @DisplayName("Create Mock Test and Add Questions")
    public void testCreateMockTestFlow() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        MockTestPage mockTestPage = new MockTestPage(driver);
        mockTestPage.navigate();
        
        mockTestPage.createMockTest("IELTS Academic Mock Test 1", "120");
        mockTestPage.openFirstMockTest();
        mockTestPage.addSectionToMockTest("Reading Passage 1");
    }
}

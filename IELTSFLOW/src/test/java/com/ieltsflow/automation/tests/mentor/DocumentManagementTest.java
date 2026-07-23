package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.mentor.DocumentPage;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.io.File;

public class DocumentManagementTest extends BaseTest {

    @Test
    @DisplayName("Upload a new PDF document")
    public void testUploadDocument() throws Exception {
        System.out.println("[LOG] Starting testUploadDocument: Navigating to login...");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        DocumentPage documentPage = new DocumentPage(driver);
        documentPage.navigate();
        
        File dummyFile = File.createTempFile("dummy_document", ".pdf");
        dummyFile.deleteOnExit();

        documentPage.uploadDocument("Reading Practice PDF", dummyFile.getAbsolutePath());
        
        Assertions.assertTrue(documentPage.isUploadSuccessful(), "Upload success message should be displayed");
    }
}

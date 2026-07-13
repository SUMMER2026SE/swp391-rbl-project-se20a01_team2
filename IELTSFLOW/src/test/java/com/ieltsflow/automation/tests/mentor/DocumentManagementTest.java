package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.mentor.DocumentPage;
import com.ieltsflow.automation.pages.mentor.LoginPage;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.io.File;

public class DocumentManagementTest extends BaseTest {

    @Test
    @DisplayName("Upload a new PDF document")
    public void testUploadDocument() throws Exception {
        System.out.println("[LOG] Starting testUploadDocument: Navigating to login...");
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        // Wait for login to complete and redirect to dashboard
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/lessons?action=new");
        DocumentPage documentPage = new DocumentPage(driver);
        
        File dummyFile = File.createTempFile("dummy_document", ".pdf");
        dummyFile.deleteOnExit();

        documentPage.uploadDocument("Reading Practice PDF", dummyFile.getAbsolutePath());
        
        Assertions.assertTrue(documentPage.isUploadSuccessful(), "Upload success message should be displayed");
    }
}

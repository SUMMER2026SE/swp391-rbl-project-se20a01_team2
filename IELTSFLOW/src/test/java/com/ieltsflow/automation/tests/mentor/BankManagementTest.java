package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.mentor.LoginPage;
import com.ieltsflow.automation.pages.mentor.QuestionBankPage;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class BankManagementTest extends BaseTest {

    @Test
    @DisplayName("Create a complex Matching Question")
    public void testCreateMatchingQuestion() {
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        // Wait for login to complete and redirect to dashboard
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/questions");
        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.navigateToCreateQuestion();
        
        String matchingData = "{\"pairs\": [{\"left\": \"A\", \"right\": \"B\"}]}";
        questionBankPage.fillMatchingQuestion("Match the following items", matchingData);
        questionBankPage.saveQuestion();
    }
    
    @Test
    @DisplayName("Create a complex Fill in the Blanks Question")
    public void testCreateFillInBlanksQuestion() {
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        // Wait for login to complete and redirect to dashboard
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/questions");
        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.navigateToCreateQuestion();
        
        String fillBlankData = "{\"blanks\": [\"apple\", \"banana\"]}";
        questionBankPage.fillFillInBlanksQuestion("I eat an [1] and a [2].", fillBlankData);
        questionBankPage.saveQuestion();
    }

    @Test
    @DisplayName("Delete a Question from Bank")
    public void testDeleteQuestion() {
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        // Wait for login to complete and redirect to dashboard
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/questions");
        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.deleteQuestion();
    }
}

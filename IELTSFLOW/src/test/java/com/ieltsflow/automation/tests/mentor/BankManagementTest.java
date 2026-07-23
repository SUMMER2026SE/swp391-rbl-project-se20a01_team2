package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.mentor.QuestionBankPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class BankManagementTest extends BaseTest {

    @Test
    @DisplayName("Create a complex Matching Question")
    public void testCreateMatchingQuestion() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.navigate();
        questionBankPage.navigateToCreateQuestion();
        
        String matchingData = "{\"pairs\": [{\"left\": \"A\", \"right\": \"B\"}]}";
        questionBankPage.fillMatchingQuestion("Match the following items", matchingData);
        questionBankPage.saveQuestion();
    }
    
    @Test
    @DisplayName("Create a complex Fill in the Blanks Question")
    public void testCreateFillInBlanksQuestion() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.navigate();
        questionBankPage.navigateToCreateQuestion();
        
        String fillBlankData = "{\"blanks\": [\"apple\", \"banana\"]}";
        questionBankPage.fillFillInBlanksQuestion("I eat an [1] and a [2].", fillBlankData);
        questionBankPage.saveQuestion();
    }

    @Test
    @DisplayName("Delete a Question from Bank")
    public void testDeleteQuestion() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        QuestionBankPage questionBankPage = new QuestionBankPage(driver);
        questionBankPage.navigate();
        questionBankPage.deleteQuestion();
    }
}

package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.base.BasePage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class QuestionBankPage extends BasePage {

    private By btnAddQuestion = By.xpath("//a[contains(@href, 'action=new')]");
    private By inputQuestionContent = By.name("content");
    private By selectQuestionType = By.name("questionType");
    private By inputJsonData = By.id("contentJson");
    private By toggleRawJson = By.id("toggleRawContentJson");
    private By btnSaveQuestion = By.xpath("//button[@type='submit' and contains(., 'Lưu Câu Hỏi')]");
    private By btnDeleteQuestion = By.xpath("(//form[input[@name='action' and @value='delete']]//button[@type='submit'])[1]");

    public QuestionBankPage(WebDriver driver) {
        super(driver);
    }

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/mentor/questions");
    }

    public void navigateToCreateQuestion() {
        click(btnAddQuestion);
    }

    public void fillMatchingQuestion(String content, String jsonData) {
        type(inputQuestionContent, content);
        selectByValue(selectQuestionType, "Matching");
        toggleAndFillJson(jsonData);
    }

    public void fillFillInBlanksQuestion(String content, String blanksData) {
        type(inputQuestionContent, content);
        selectByValue(selectQuestionType, "FillInBlanks");
        toggleAndFillJson(blanksData);
    }
    
    private void toggleAndFillJson(String jsonData) {
        // Toggle raw JSON view
        jsClick(toggleRawJson);
        
        org.openqa.selenium.WebElement jsonInput = wait.until(org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated(inputJsonData));
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].value = arguments[1];", jsonInput, jsonData);
    }

    public void saveQuestion() {
        jsClick(btnSaveQuestion);
    }

    public void deleteQuestion() {
        click(btnDeleteQuestion);
        
        // Handle JS confirm alert
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(5));
        try {
            wait.until(org.openqa.selenium.support.ui.ExpectedConditions.alertIsPresent());
            driver.switchTo().alert().accept();
        } catch (org.openqa.selenium.TimeoutException e) {
            System.out.println("[LOG] No alert appeared after clicking delete. The element might have been deleted directly or there were no elements.");
        }
    }
}

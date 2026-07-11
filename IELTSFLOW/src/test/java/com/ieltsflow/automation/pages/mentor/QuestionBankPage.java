package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.utils.WaitUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class QuestionBankPage {
    private WebDriver driver;

    private By btnAddQuestion = By.xpath("//a[contains(@href, 'action=new')]");
    private By inputQuestionContent = By.name("content");
    private By selectQuestionType = By.name("questionType");
    private By inputJsonData = By.id("contentJson");
    private By toggleRawJson = By.id("toggleRawContentJson");
    private By btnSaveQuestion = By.xpath("//button[@type='submit' and contains(., 'Lưu Câu Hỏi')]");
    private By btnDeleteQuestion = By.xpath("(//form[input[@name='action' and @value='delete']]//button[@type='submit'])[1]");

    public QuestionBankPage(WebDriver driver) {
        this.driver = driver;
    }

    public void navigateToCreateQuestion() {
        WaitUtils.waitForElementClickable(driver, btnAddQuestion, 3).click();
    }

    public void fillMatchingQuestion(String content, String jsonData) {
        WaitUtils.waitForElementVisible(driver, inputQuestionContent, 3).sendKeys(content);
        driver.findElement(selectQuestionType).sendKeys("Matching");
        toggleAndFillJson(jsonData);
    }

    public void fillFillInBlanksQuestion(String content, String blanksData) {
        WaitUtils.waitForElementVisible(driver, inputQuestionContent, 3).sendKeys(content);
        driver.findElement(selectQuestionType).sendKeys("Fill In Blanks");
        toggleAndFillJson(blanksData);
    }
    
    private void toggleAndFillJson(String jsonData) {
        // Toggle raw JSON view
        org.openqa.selenium.WebElement toggle = WaitUtils.waitForElementClickable(driver, toggleRawJson, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", toggle);
        
        org.openqa.selenium.WebElement jsonInput = WaitUtils.waitForElementVisible(driver, inputJsonData, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].value = arguments[1];", jsonInput, jsonData);
    }

    public void saveQuestion() {
        org.openqa.selenium.WebElement saveBtn = WaitUtils.waitForElementClickable(driver, btnSaveQuestion, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", saveBtn);
    }

    public void deleteQuestion() {
        WaitUtils.waitForElementClickable(driver, btnDeleteQuestion, 3).click();
        
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

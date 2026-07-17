package com.ieltsflow.automation.pages;

import com.ieltsflow.automation.base.BasePage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class MockTestPage extends BasePage {

    public MockTestPage(WebDriver driver) {
        super(driver);
    }

    private By btnStartMock = By.id("btn-start-mock-test");
    private By btnStartExam = By.id("btn-start-exam");
    private By timer = By.id("timer");
    private By violationOverlay = By.id("violation-overlay");
    private By vioCount = By.id("vio-count");
    private By btnBackFocus = By.id("btn-back-focus");

    public void navigateToMockTestInfo() {
        navigateTo(ConfigReader.getBaseUrl() + "/candidate/mock-test");
    }

    public void clickStartMockTest() {
        // Dùng JS submit trực tiếp form thay vì click để tránh popup bị chặn
        WebElement btn = wait.until(ExpectedConditions.presenceOfElementLocated(btnStartMock));
        ((JavascriptExecutor) driver).executeScript("arguments[0].closest('form').submit();", btn);
    }

    public void clickStartExamSecurity() {
        jsClick(btnStartExam);
    }

    public void waitForTimerToAppear() {
        wait.until(ExpectedConditions.visibilityOfElementLocated(timer));
    }

    public String getTimerText() {
        return getText(timer);
    }

    public void triggerTabSwitchViolation() {
        // Chạy trực tiếp JS function trên web để giả lập bị đổi tab
        ((JavascriptExecutor) driver).executeScript("triggerViolation('tab');");
    }

    public void waitForViolationOverlay() {
        wait.until(ExpectedConditions.visibilityOfElementLocated(violationOverlay));
    }

    public void waitForViolationOverlayToDisappear() {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(violationOverlay));
    }

    public String getViolationCount() {
        return getText(vioCount);
    }

    public void clickBackToExam() {
        jsClick(btnBackFocus);
    }

    public void waitForExamToAutoSubmit() {
        // Chờ đến khi URL không còn chứa action=take (tức là đã văng ra khỏi phòng thi)
        waitForUrlNotContains("action=take");
    }
}

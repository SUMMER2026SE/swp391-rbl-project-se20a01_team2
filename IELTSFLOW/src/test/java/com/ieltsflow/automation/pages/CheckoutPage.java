package com.ieltsflow.automation.pages;

import com.ieltsflow.automation.base.BasePage;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class CheckoutPage extends BasePage {

    public CheckoutPage(WebDriver driver) {
        super(driver);
    }

    private By timer = By.id("timer");
    private By statusBox = By.className("status-box");
    private By cancelBtn = By.className("btn-cancel");
    
    private By modalTitle = By.id("modalTitle");
    private By modalText = By.id("modalText");
    private By confirmCancelBtn = By.xpath("//button[contains(text(), 'Đồng ý')]");
    
    private By timeoutCard = By.id("timeoutCard");
    private By orderSummary = By.id("orderSummary");

    public boolean isTimerDisplayed() {
        return isElementDisplayed(timer);
    }
    
    public String getTransactionIdFromUI() {
        // e.g. "IF01"
        WebElement el = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//span[text()='Mã đơn hàng']/following-sibling::span")));
        return el.getText().replace("IF", "").trim();
    }

    public void clickCancel() {
        jsClick(cancelBtn);
    }

    public void confirmCancel() {
        click(confirmCancelBtn);
    }
    
    public String getModalTitle() {
        return getText(modalTitle);
    }
    
    public boolean isTimeoutCardDisplayed() {
        return isElementDisplayed(timeoutCard);
    }
    
    public void simulateTimeout() {
        org.openqa.selenium.JavascriptExecutor js = (org.openqa.selenium.JavascriptExecutor) driver;
        js.executeScript("timeleft = 0;");
    }
}

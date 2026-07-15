package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.utils.WaitUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class TicketPage {
    private WebDriver driver;

    private By openTicketLink = By.cssSelector("a.issue-title");
    private By inputReply = By.name("content");
    private By btnSendReply = By.xpath("//button[@type='submit' and contains(text(), 'Comment')]");

    public TicketPage(WebDriver driver) {
        this.driver = driver;
    }

    public void replyToTicket(String replyContent) {
        WaitUtils.waitForElementClickable(driver, openTicketLink, 3).click();
        WaitUtils.waitForElementVisible(driver, inputReply, 3).sendKeys(replyContent);
        
        org.openqa.selenium.WebElement btn = WaitUtils.waitForElementClickable(driver, btnSendReply, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);
    }
}

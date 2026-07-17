package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.base.BasePage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class TicketPage extends BasePage {

    private By openTicketLink = By.cssSelector("a.issue-title");
    private By inputReply = By.name("content");
    private By btnSendReply = By.xpath("//button[@type='submit' and contains(text(), 'Comment')]");

    public TicketPage(WebDriver driver) {
        super(driver);
    }

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/mentor/tickets");
    }

    public void replyToTicket(String replyContent) {
        if (!isElementDisplayed(openTicketLink)) {
            System.out.println("[LOG] No tickets found to reply to. Skipping.");
            return;
        }
        click(openTicketLink);
        type(inputReply, replyContent);
        
        jsClick(btnSendReply);
    }
}

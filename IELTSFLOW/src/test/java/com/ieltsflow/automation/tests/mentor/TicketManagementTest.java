package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.mentor.LoginPage;
import com.ieltsflow.automation.pages.mentor.TicketPage;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class TicketManagementTest extends BaseTest {

    @Test
    @DisplayName("Reply and resolve a ticket")
    public void testReplyToTicket() {
        driver.get("http://localhost:8080/IELTSFLOW/login");
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("cookingoils3@gmail.com", "15032006duy");
        
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(3));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.urlContains("/dashboard"));

        driver.get("http://localhost:8080/IELTSFLOW/mentor/tickets");
        TicketPage ticketPage = new TicketPage(driver);
        
        ticketPage.replyToTicket("Here is the answer to your reading question.");
    }
}

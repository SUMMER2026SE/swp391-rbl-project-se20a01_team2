package com.ieltsflow.automation.tests.mentor;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.mentor.TicketPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class TicketManagementTest extends BaseTest {

    @Test
    @DisplayName("Reply and resolve a ticket")
    public void testReplyToTicket() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(ConfigReader.getMentorEmail(), ConfigReader.getMentorPassword());
        loginPage.waitForLoginSuccess();

        TicketPage ticketPage = new TicketPage(driver);
        ticketPage.navigate();
        
        ticketPage.replyToTicket("Here is the answer to your reading question.");
    }
}

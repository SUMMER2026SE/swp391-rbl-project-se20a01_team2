package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.CandidateSubscriptionPage;
import com.ieltsflow.automation.pages.CheckoutPage;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.utils.MockPaymentHelper;
import com.ieltsflow.automation.utils.TestConfig;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class CandidatePaymentTest extends BaseTest {

    @Test
    @DisplayName("[Happy Path] Test Case 3.1: Pro Package Purchase & Valid Mock Webhook")
    public void testProPackagePurchaseWithValidWebhook() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(TestConfig.getCandidateEmail(), TestConfig.getCandidatePassword());
        loginPage.waitForLoginSuccess();

        CandidateSubscriptionPage subPage = new CandidateSubscriptionPage(driver);
        subPage.navigate();
        subPage.selectPackageByPrice("49000");

        CheckoutPage checkoutPage = new CheckoutPage(driver);
        Assertions.assertTrue(driver.getCurrentUrl().contains("/checkout"), "Should be redirected to checkout page");
        Assertions.assertTrue(checkoutPage.isTimerDisplayed(), "Checkout timer should be displayed");

        String transactionId = checkoutPage.getTransactionIdFromUI();
        Assertions.assertNotNull(transactionId, "Transaction ID should not be null");

        // Mock valid webhook for 49000 VND
        boolean webhookSent = MockPaymentHelper.sendMockWebhook(transactionId, 49000);
        Assertions.assertTrue(webhookSent, "Webhook should be sent successfully");

        // Wait for polling to redirect to success or update modal
        checkoutPage.waitForUrlNotContains("/checkout");
        
        // Verify success (either redirected to /account or success modal)
        Assertions.assertFalse(driver.getCurrentUrl().contains("/checkout"), "Should not be on checkout page anymore");
    }

    @Test
    @DisplayName("[Unhappy Path] Test Case 3.2: Cancel Checkout")
    public void testCancelCheckout() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(TestConfig.getCandidateEmail(), TestConfig.getCandidatePassword());
        loginPage.waitForLoginSuccess();

        CandidateSubscriptionPage subPage = new CandidateSubscriptionPage(driver);
        subPage.navigate();
        subPage.selectPackageByPrice("49000");

        CheckoutPage checkoutPage = new CheckoutPage(driver);
        Assertions.assertTrue(driver.getCurrentUrl().contains("/checkout"), "Should be redirected to checkout page");
        
        checkoutPage.clickCancel();
        checkoutPage.confirmCancel();

        checkoutPage.waitForUrlNotContains("/checkout");
        
        Assertions.assertTrue(driver.getCurrentUrl().contains("/subscription") || driver.getCurrentUrl().contains("/account"), "Should be redirected after cancel");
    }

    @Test
    @DisplayName("[Unhappy Path] Test Case 3.3: Checkout Timeout")
    public void testCheckoutTimeout() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(TestConfig.getCandidateEmail(), TestConfig.getCandidatePassword());
        loginPage.waitForLoginSuccess();

        CandidateSubscriptionPage subPage = new CandidateSubscriptionPage(driver);
        subPage.navigate();
        subPage.selectPackageByPrice("49000");

        CheckoutPage checkoutPage = new CheckoutPage(driver);
        Assertions.assertTrue(driver.getCurrentUrl().contains("/checkout"), "Should be redirected to checkout page");
        
        // Simulate timeout via JS
        checkoutPage.simulateTimeout();

        Assertions.assertTrue(checkoutPage.isTimeoutCardDisplayed(), "Timeout card/message should be displayed");
    }
}

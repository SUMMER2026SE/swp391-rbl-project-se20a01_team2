package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.utils.WaitUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage {
    private WebDriver driver;

    private By emailInput = By.id("loginEmail");
    private By passwordInput = By.id("loginPassword");
    private By loginButton = By.cssSelector("#loginForm button[type='submit']");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String email, String password) {
        WaitUtils.waitForElementVisible(driver, emailInput, 10).sendKeys(email);
        driver.findElement(passwordInput).sendKeys(password);
        WaitUtils.waitForElementClickable(driver, loginButton, 10).click();
    }
}

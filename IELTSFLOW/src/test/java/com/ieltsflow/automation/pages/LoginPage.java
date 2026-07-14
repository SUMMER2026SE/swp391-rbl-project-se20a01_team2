package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;

import com.ieltsflow.automation.utils.TestConfig;

public class LoginPage extends BasePage {

    public LoginPage(WebDriver driver) {
        super(driver);
    }

    private By emailInput = By.id("loginEmail");
    private By passwordInput = By.id("loginPassword");
    private By loginBtn = By.cssSelector("#loginForm button[type='submit']");
    private By errorAlert = By.className("alert-error");

    public void navigate() {
        navigateTo(TestConfig.getBaseUrl() + "/auth");
    }

    public void login(String email, String password) {
        // Đảm bảo không bị dính session cũ
        logout();
        navigate();
        
        type(emailInput, email);
        type(passwordInput, password);
        click(loginBtn);
    }
    
    public void logout() {
        driver.manage().deleteAllCookies();
        navigateTo(TestConfig.getBaseUrl() + "/logout");
    }

    public void waitForLoginSuccess() {
        // Đợi cho đến khi URL thay đổi (không còn ở trang đăng nhập nữa)
        wait.until(ExpectedConditions.not(ExpectedConditions.urlContains("auth")));
    }

    public boolean isErrorDisplayed() {
        return isElementDisplayed(errorAlert);
    }

    public String getErrorMessage() {
        return getText(errorAlert);
    }
}

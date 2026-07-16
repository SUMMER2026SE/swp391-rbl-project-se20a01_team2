package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import com.ieltsflow.automation.base.BasePage;

import com.ieltsflow.automation.utils.ConfigReader;

public class RegisterPage extends BasePage {

    public RegisterPage(WebDriver driver) {
        super(driver);
    }

    private By tabRegisterBtn = By.id("tabRegisterBtn");
    private By fullNameInput = By.id("regName");
    private By emailInput = By.id("regEmail");
    private By passwordInput = By.id("regPassword");
    private By confirmPasswordInput = By.id("regConfirmPassword");
    private By termsCheckbox = By.id("regTerms");
    private By registerBtn = By.cssSelector("#registerForm button[type='submit']");
    private By errorAlert = By.className("alert-error");
    private By strengthText = By.id("strengthText");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/auth");
        click(tabRegisterBtn);
        // Wait for form to be visible (animation)
        wait.until(ExpectedConditions.visibilityOfElementLocated(fullNameInput));
    }

    public void register(String fullName, String email, String password, String confirmPassword, boolean acceptTerms) {
        type(fullNameInput, fullName);
        type(emailInput, email);
        type(passwordInput, password);
        type(confirmPasswordInput, confirmPassword);
        
        if (acceptTerms) {
            // Check if not already checked
            if (!driver.findElement(termsCheckbox).isSelected()) {
                click(termsCheckbox);
            }
        }
        
        click(registerBtn);
    }

    public boolean isErrorDisplayed() {
        return isElementDisplayed(errorAlert);
    }

    public String getErrorMessage() {
        return getText(errorAlert);
    }

    public String getPasswordStrength() {
        return getText(strengthText);
    }
}

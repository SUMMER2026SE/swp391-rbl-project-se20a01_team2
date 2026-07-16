package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import com.ieltsflow.automation.base.BasePage;

import com.ieltsflow.automation.utils.ConfigReader;

public class ChangePasswordPage extends BasePage {

    public ChangePasswordPage(WebDriver driver) {
        super(driver);
    }

    private By currentPasswordInput = By.id("currentPassword");
    private By newPasswordInput = By.id("newPassword");
    private By confirmPasswordInput = By.id("confirmPassword");
    private By saveBtn = By.cssSelector("#passwordForm button[type='submit']");
    private By toastMessage = By.cssSelector(".toast");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/change-password");
    }

    public void changePassword(String currentPwd, String newPwd, String confirmPwd) {
        type(currentPasswordInput, currentPwd);
        type(newPasswordInput, newPwd);
        type(confirmPasswordInput, confirmPwd);
        click(saveBtn);
    }

    public boolean isToastMessageDisplayed() {
        return isElementDisplayed(toastMessage);
    }
}

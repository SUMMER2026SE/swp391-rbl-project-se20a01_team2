package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import com.ieltsflow.automation.base.BasePage;

import com.ieltsflow.automation.utils.ConfigReader;

public class AccountPage extends BasePage {

    public AccountPage(WebDriver driver) {
        super(driver);
    }

    private By fullNameInput = By.id("fullName");
    private By saveProfileBtn = By.cssSelector("#profileForm button[type='submit']");
    private By toastMessage = By.cssSelector(".toast");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/account");
    }

    public void updateFullName(String newName) {
        type(fullNameInput, newName);
        click(saveProfileBtn);
    }

    public boolean isToastMessageDisplayed() {
        return isElementDisplayed(toastMessage);
    }
}

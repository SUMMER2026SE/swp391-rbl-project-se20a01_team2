package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import com.ieltsflow.automation.base.BasePage;

import com.ieltsflow.automation.utils.ConfigReader;

public class LandingPage extends BasePage {

    public LandingPage(WebDriver driver) {
        super(driver);
    }

    private By logo = By.cssSelector(".logo");
    private By heroTitle = By.cssSelector(".hero-title");
    private By loginBtn = By.xpath("//a[contains(text(), 'Đăng nhập')]");
    private By registerBtn = By.xpath("//a[contains(text(), 'Đăng ký')]");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/");
    }

    public boolean isLogoDisplayed() {
        return isElementDisplayed(logo);
    }

    public boolean isHeroTitleDisplayed() {
        return isElementDisplayed(heroTitle);
    }

    public void clickLogin() {
        click(loginBtn);
    }

    public void clickRegister() {
        click(registerBtn);
    }
}

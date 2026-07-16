package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import java.util.List;
import com.ieltsflow.automation.base.BasePage;

import com.ieltsflow.automation.utils.ConfigReader;

public class TargetBandPage extends BasePage {

    public TargetBandPage(WebDriver driver) {
        super(driver);
    }

    private By bandOptions = By.cssSelector(".band-option");
    private By saveBtn = By.id("saveGoalBtn");
    private By toastMessage = By.cssSelector(".toast");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/ielts-target");
    }

    public void selectTargetBand(String band) {
        List<WebElement> options = getElements(bandOptions);
        for (WebElement option : options) {
            if (option.getText().trim().equals(band)) {
                option.click();
                break;
            }
        }
    }

    public void saveTargetBand() {
        click(saveBtn);
    }

    public boolean isToastMessageDisplayed() {
        return isElementDisplayed(toastMessage);
    }
}

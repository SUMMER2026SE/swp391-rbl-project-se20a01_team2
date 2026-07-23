package com.ieltsflow.automation.pages;

import com.ieltsflow.automation.base.BasePage;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

import com.ieltsflow.automation.utils.ConfigReader;

public class CandidateSubscriptionPage extends BasePage {

    public CandidateSubscriptionPage(WebDriver driver) {
        super(driver);
    }

    private By pricingCards = By.cssSelector(".pricing-card");
    
    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/subscription");
    }

    public void selectFirstProPackage() {
        List<WebElement> cards = getElements(pricingCards);
        for (WebElement card : cards) {
            if (card.getAttribute("class").contains("pro")) {
                WebElement btn = card.findElement(By.cssSelector("button[type='submit']"));
                jsClick(btn);
                return;
            }
        }
    }

    public void selectPackageByPrice(String price) {
        List<WebElement> cards = getElements(pricingCards);
        for (WebElement card : cards) {
            String priceText = card.findElement(By.className("pricing-price")).getText();
            if (priceText.contains(price)) {
                WebElement btn = card.findElement(By.cssSelector("button[type='submit']"));
                jsClick(btn);
                return;
            }
        }
        throw new RuntimeException("Package with price " + price + " not found");
    }
}

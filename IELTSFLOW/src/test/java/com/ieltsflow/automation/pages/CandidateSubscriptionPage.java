package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

import com.ieltsflow.automation.utils.TestConfig;

public class CandidateSubscriptionPage extends BasePage {

    public CandidateSubscriptionPage(WebDriver driver) {
        super(driver);
    }

    private By pricingCards = By.cssSelector(".pricing-card");
    
    public void navigate() {
        navigateTo(TestConfig.getBaseUrl() + "/subscription");
    }

    public void selectFirstProPackage() {
        List<WebElement> cards = getElements(pricingCards);
        for (WebElement card : cards) {
            if (card.getAttribute("class").contains("pro")) {
                card.findElement(By.cssSelector("button[type='submit']")).click();
                return;
            }
        }
    }

    public void selectPackageByPrice(String price) {
        List<WebElement> cards = getElements(pricingCards);
        for (WebElement card : cards) {
            String priceText = card.findElement(By.className("pricing-price")).getText();
            if (priceText.contains(price)) {
                card.findElement(By.cssSelector("button[type='submit']")).click();
                return;
            }
        }
        throw new RuntimeException("Package with price " + price + " not found");
    }
}

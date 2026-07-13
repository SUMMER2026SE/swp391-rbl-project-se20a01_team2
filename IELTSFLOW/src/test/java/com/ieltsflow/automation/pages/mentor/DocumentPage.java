package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.utils.WaitUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class DocumentPage {
    private WebDriver driver;

    private By btnUploadResource = By.xpath("//button[contains(@onclick, 'documentUpload')]");
    private By inputResourceTitle = By.name("title");
    private By inputFileUpload = By.id("documentUpload");
    private By btnSubmitUpload = By.cssSelector("form button[type='submit']");
    private By successMessage = By.cssSelector(".alert-success");

    public DocumentPage(WebDriver driver) {
        this.driver = driver;
    }

    public void uploadDocument(String title, String filePath) {
        WaitUtils.waitForElementVisible(driver, inputResourceTitle, 3).sendKeys(title);
        driver.findElement(inputFileUpload).sendKeys(filePath);
        
        // Click the 'Tải lên' button using JavascriptExecutor to bypass the sticky footer
        org.openqa.selenium.WebElement uploadBtn = WaitUtils.waitForElementClickable(driver, btnUploadResource, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", uploadBtn);
        
        // Wait for JS Alert "Tải lên thành công!"
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(15));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.alertIsPresent());
        driver.switchTo().alert().accept();
        
        // Submit the form to save the lesson
        org.openqa.selenium.WebElement submitBtn = WaitUtils.waitForElementClickable(driver, btnSubmitUpload, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", submitBtn);
    }
    
    public boolean isUploadSuccessful() {
        return WaitUtils.waitForElementVisible(driver, successMessage, 15).isDisplayed();
    }
}

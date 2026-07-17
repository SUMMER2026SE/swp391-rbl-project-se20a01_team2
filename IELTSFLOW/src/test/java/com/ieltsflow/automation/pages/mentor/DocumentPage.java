package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.pages.BasePage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class DocumentPage extends BasePage {

    private By btnUploadResource = By.xpath("//button[contains(@onclick, 'documentUpload')]");
    private By inputResourceTitle = By.name("title");
    private By inputFileUpload = By.id("documentUpload");
    private By btnSubmitUpload = By.cssSelector("form button[type='submit']");
    private By successMessage = By.cssSelector(".alert-success");

    public DocumentPage(WebDriver driver) {
        super(driver);
    }

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/mentor/lessons?action=new");
    }

    public void uploadDocument(String title, String filePath) {
        type(inputResourceTitle, title);
        driver.findElement(inputFileUpload).sendKeys(filePath);
        
        // Click the 'Tải lên' button using JavascriptExecutor to bypass the sticky footer
        jsClick(btnUploadResource);
        
        // Wait for JS Alert "Tải lên thành công!"
        org.openqa.selenium.support.ui.WebDriverWait wait = new org.openqa.selenium.support.ui.WebDriverWait(driver, java.time.Duration.ofSeconds(15));
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.alertIsPresent());
        driver.switchTo().alert().accept();
        
        // Submit the form to save the lesson
        jsClick(btnSubmitUpload);
    }
    
    public boolean isUploadSuccessful() {
        return isElementDisplayed(successMessage);
    }
}

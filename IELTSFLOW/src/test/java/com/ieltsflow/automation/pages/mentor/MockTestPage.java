package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.utils.WaitUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class MockTestPage {
    private WebDriver driver;

    private By btnCreateMockTest = By.xpath("//a[contains(@href, 'action=new')]");
    private By inputExamTitle = By.name("title");
    private By inputDuration = By.name("duration");
    private By btnSaveExam = By.xpath("//button[@type='submit' and contains(., 'Lưu Đề Thi')]");
    
    private By btnAddSectionModal = By.xpath("//button[@data-bs-target='#addSectionModal']");
    private By inputSectionName = By.xpath("//div[@id='addSectionModal']//input[@name='sectionName']");
    private By btnSubmitSection = By.xpath("//div[@id='addSectionModal']//button[@type='submit']");
    private By sectionAccordionItem = By.cssSelector(".accordion-item");
    private By btnEditFirstExam = By.xpath("(//a[@title='Chỉnh sửa'])[1]");

    public MockTestPage(WebDriver driver) {
        this.driver = driver;
    }

    public void openFirstMockTest() {
        WaitUtils.waitForElementClickable(driver, btnEditFirstExam, 3).click();
    }

    public void createMockTest(String title, String duration) {
        WaitUtils.waitForElementClickable(driver, btnCreateMockTest, 3).click();
        WaitUtils.waitForElementVisible(driver, inputExamTitle, 3).sendKeys(title);
        driver.findElement(inputDuration).sendKeys(duration);
        
        org.openqa.selenium.WebElement saveBtn = WaitUtils.waitForElementClickable(driver, btnSaveExam, 3);
        ((org.openqa.selenium.JavascriptExecutor) driver).executeScript("arguments[0].click();", saveBtn);
    }

    public void addSectionToMockTest(String sectionName) {
        WaitUtils.waitForElementClickable(driver, btnAddSectionModal, 3).click();
        WaitUtils.waitForElementVisible(driver, inputSectionName, 3).sendKeys(sectionName);
        WaitUtils.waitForElementClickable(driver, btnSubmitSection, 3).click();
        
        // Wait for the new section to appear
        WaitUtils.waitForElementVisible(driver, sectionAccordionItem, 3);
    }
}

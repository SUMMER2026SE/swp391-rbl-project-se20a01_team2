package com.ieltsflow.automation.pages.mentor;

import com.ieltsflow.automation.pages.BasePage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class MockTestPage extends BasePage {

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
        super(driver);
    }

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/mentor/exams");
    }

    public void openFirstMockTest() {
        click(btnEditFirstExam);
    }

    public void createMockTest(String title, String duration) {
        click(btnCreateMockTest);
        type(inputExamTitle, title);
        type(inputDuration, duration); // changed to type to match pattern
        
        jsClick(btnSaveExam);
    }

    public void addSectionToMockTest(String sectionName) {
        click(btnAddSectionModal);
        type(inputSectionName, sectionName);
        click(btnSubmitSection);
        
        // Wait for the new section to appear
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated(sectionAccordionItem));
    }
}

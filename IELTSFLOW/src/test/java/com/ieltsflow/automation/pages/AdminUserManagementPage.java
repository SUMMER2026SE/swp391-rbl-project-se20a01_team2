package com.ieltsflow.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

import com.ieltsflow.automation.utils.ConfigReader;

public class AdminUserManagementPage extends BasePage {

    public AdminUserManagementPage(WebDriver driver) {
        super(driver);
    }

    // Locators
    private By searchInput = By.name("search");
    private By roleFilter = By.name("roleFilter");
    private By statusFilter = By.name("statusFilter");
    private By filterButton = By.cssSelector("#filterForm button[type='submit']");
    private By tableRows = By.cssSelector("#usersTable tbody tr");
    private By noResultMsg = By.xpath("//td[contains(text(), 'Không tìm thấy người dùng nào phù hợp')]");
    
    // Edit Modal
    private By fullNameInput = By.id("formFullName");
    private By roleSelect = By.id("formRoleIdDisplay"); // 1: Admin, 2: Mentor, 3: Candidate
    private By saveUserBtn = By.cssSelector("#userForm button[type='submit']");
    
    // Confirm Modal
    private By confirmBtn = By.id("confirmBtn");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/admin/users");
    }

    public void searchUser(String keyword) {
        type(searchInput, keyword);
        WebElement btn = wait.until(org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated(filterButton));
        click(filterButton);
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.stalenessOf(btn));
    }

    public boolean isNoResultMessageDisplayed() {
        List<WebElement> rows = getElements(tableRows);
        return rows.size() == 1 && rows.get(0).getAttribute("textContent").trim().contains("Không tìm thấy");
    }

    public int getRowsCount() {
        List<WebElement> rows = getElements(tableRows);
        if (rows.size() == 1 && rows.get(0).getAttribute("textContent").trim().contains("Không tìm thấy")) {
            return 0;
        }
        return rows.size();
    }

    public String getUserStatusInRow(int rowIndex) {
        // rowIndex is 0-based
        List<WebElement> rows = getElements(tableRows);
        return rows.get(rowIndex).findElement(By.xpath("./td[6]/span")).getAttribute("textContent").trim();
    }

    public int getRowIndexByEmail(String email) {
        List<WebElement> rows = getElements(tableRows);
        for (int i = 0; i < rows.size(); i++) {
            String rowEmail = rows.get(i).findElement(By.xpath("./td[4]")).getAttribute("textContent").trim();
            if (rowEmail.equalsIgnoreCase(email)) {
                return i;
            }
        }
        return -1;
    }
    
    public String getUserRoleInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        return rows.get(rowIndex).findElement(By.xpath("./td[7]")).getAttribute("textContent").trim();
    }

    public void clickLockInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        WebElement lockBtn = rows.get(rowIndex).findElement(By.xpath(".//button[contains(@onclick, 'lock')]"));
        lockBtn.click();
    }

    public void clickUnlockInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        WebElement unlockBtn = rows.get(rowIndex).findElement(By.xpath(".//button[contains(@onclick, 'unlock')]"));
        unlockBtn.click();
    }

    public void clickEditInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        WebElement editBtn = rows.get(rowIndex).findElement(By.xpath(".//button[contains(@onclick, 'update')]"));
        editBtn.click();
    }

    public void confirmAction() {
        WebElement btn = wait.until(org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated(confirmBtn));
        click(confirmBtn);
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.stalenessOf(btn));
    }

    public void changeRoleAndSave(String roleValue) {
        selectByValue(roleSelect, roleValue);
        WebElement btn = wait.until(org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated(saveUserBtn));
        click(saveUserBtn);
        wait.until(org.openqa.selenium.support.ui.ExpectedConditions.stalenessOf(btn));
    }
}

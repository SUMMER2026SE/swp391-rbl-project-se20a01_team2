package com.ieltsflow.automation.pages;

import com.ieltsflow.automation.base.BasePage;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

import com.ieltsflow.automation.utils.ConfigReader;

public class AdminSubscriptionPage extends BasePage {

    public AdminSubscriptionPage(WebDriver driver) {
        super(driver);
    }

    private By createPackageBtn = By.cssSelector("a[href*='action=add']");
    private By tableRows = By.cssSelector(".table-custom tbody tr");
    private By noDataMsg = By.xpath("//td[contains(text(), 'Không có dữ liệu gói thành viên')]");

    public void navigate() {
        navigateTo(ConfigReader.getBaseUrl() + "/admin/packages");
    }

    public void clickCreatePackage() {
        click(createPackageBtn);
    }

    public int getRowsCount() {
        List<WebElement> rows = getElements(tableRows);
        if (rows.size() == 1 && rows.get(0).getText().contains("Không có dữ liệu")) {
            return 0;
        }
        return rows.size();
    }

    public String getPackageNameInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        return rows.get(rowIndex).findElement(By.xpath("./td[2]")).getText().trim();
    }
    
    public String getPackagePriceInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        return rows.get(rowIndex).findElement(By.xpath("./td[4]")).getText().trim();
    }

    public void clickEditInRow(int rowIndex) {
        List<WebElement> rows = getElements(tableRows);
        WebElement editBtn = rows.get(rowIndex).findElement(By.cssSelector("a[href*='action=edit']"));
        editBtn.click();
    }

    public void clickEditForPackage(String packageName) {
        List<WebElement> rows = getElements(tableRows);
        for (WebElement row : rows) {
            String name = row.findElement(By.xpath("./td[2]")).getText().trim();
            if (name.equals(packageName)) {
                WebElement editBtn = row.findElement(By.cssSelector("a[href*='action=edit']"));
                editBtn.click();
                return;
            }
        }
        throw new RuntimeException("Package not found: " + packageName);
    }
    public void clickDeleteForPackage(String packageName) {
        List<WebElement> rows = getElements(tableRows);
        for (WebElement row : rows) {
            String name = row.findElement(By.xpath("./td[2]")).getText().trim();
            if (name.equals(packageName)) {
                WebElement deleteBtn = row.findElement(By.cssSelector("a[href*='action=delete']"));
                deleteBtn.click();
                return;
            }
        }
        throw new RuntimeException("Package not found for deletion: " + packageName);
    }
    
    public void confirmDelete() {
        // The customConfirm shows a javascript alert or a custom modal?
        // Let's assume it's a standard JS alert based on standard onclick handling or we need to handle SweetAlert.
        // Wait, looking at packages.jsp: onclick="return customConfirm(event, this, '...');"
        // Since customConfirm probably uses SweetAlert, we need to click the confirm button.
        // I will use a generic confirmAction if the base page has one, or just handle alert.
        try {
            driver.switchTo().alert().accept();
        } catch (Exception e) {
            // If it's a SweetAlert instead of standard alert
            click(By.cssSelector(".swal2-confirm"));
        }
    }
}

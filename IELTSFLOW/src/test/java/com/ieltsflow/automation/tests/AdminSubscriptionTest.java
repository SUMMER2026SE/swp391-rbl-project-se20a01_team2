package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.AdminPackageFormPage;
import com.ieltsflow.automation.pages.AdminSubscriptionPage;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import util.JpaHelper;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AdminSubscriptionTest extends BaseTest {

    private static String createdPackageName = null;

    @Test
    @Order(1)
    @DisplayName("[Happy Path] Test Case 2.1: Create new package")
    public void testCreateNewPackage() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();
        AdminSubscriptionPage subscriptionPage = new AdminSubscriptionPage(driver);
        subscriptionPage.navigate();
        int initialRows = subscriptionPage.getRowsCount();
        subscriptionPage.clickCreatePackage();
        
        AdminPackageFormPage formPage = new AdminPackageFormPage(driver);
        String pkgName = "Pro Package Test " + System.currentTimeMillis();
        formPage.fillFormAndSubmit(pkgName, "3", "300000", "Description of test package");
        
        formPage.waitForUrlContains("packages");
        
        int finalRows = subscriptionPage.getRowsCount();
        
        Assertions.assertEquals(finalRows, initialRows + 1, "Package count should increase by 1");
        
        // Find if new package is listed
        boolean found = false;
        for (int i=0; i < finalRows; i++) {
            if (subscriptionPage.getPackageNameInRow(i).equals(pkgName)) {
                found = true;
                break;
            }
        }
        Assertions.assertTrue(found, "Newly created package should be in the list");
        
        // Save for the next test & cleanup
        createdPackageName = pkgName;
    }

    @Test
    @Order(2)
    @DisplayName("[Happy Path] Test Case 2.2: Update existing package")
    public void testUpdatePackage() {
        Assumptions.assumeTrue(createdPackageName != null, "Test 2.1 must pass and set createdPackageName");
        
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminSubscriptionPage subscriptionPage = new AdminSubscriptionPage(driver);
        subscriptionPage.navigate();

        subscriptionPage.clickEditForPackage(createdPackageName);
        
        AdminPackageFormPage formPage = new AdminPackageFormPage(driver);
        String newPrice = "450000";
        // Assuming price field can be cleared and edited
        formPage.fillFormAndSubmit(null, null, newPrice, null);
        
        formPage.waitForUrlContains("packages");
        
        // Locate the row of our package again to check the updated price
        int rows = subscriptionPage.getRowsCount();
        String updatedPrice = "";
        for (int i=0; i < rows; i++) {
            if (subscriptionPage.getPackageNameInRow(i).equals(createdPackageName)) {
                updatedPrice = subscriptionPage.getPackagePriceInRow(i);
                break;
            }
        }
        
        Assertions.assertTrue(updatedPrice.contains("450"), "Package price should be updated");
    }

    @Test
    @Order(3)
    @DisplayName("[Unhappy Path] Test Case 2.3: Empty mandatory fields")
    public void testEmptyMandatoryFields() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminSubscriptionPage subscriptionPage = new AdminSubscriptionPage(driver);
        subscriptionPage.navigate();
        subscriptionPage.clickCreatePackage();
        
        AdminPackageFormPage formPage = new AdminPackageFormPage(driver);
        formPage.submitForm();
        
        // Assert we are still on the form page, not redirected to packages list
        Assertions.assertTrue(driver.getCurrentUrl().contains("action=add"), "Should stay on form page due to validation");
    }

    @Test
    @Order(4)
    @DisplayName("[Unhappy Path] Test Case 2.4: Invalid negative values")
    public void testNegativeValues() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminSubscriptionPage subscriptionPage = new AdminSubscriptionPage(driver);
        subscriptionPage.navigate();
        subscriptionPage.clickCreatePackage();
        
        AdminPackageFormPage formPage = new AdminPackageFormPage(driver);
        formPage.fillFormAndSubmit("Invalid Package", "-1", "-50000", "Desc");
        
        // Assert validation prevents submission
        Assertions.assertTrue(driver.getCurrentUrl().contains("action=add"), "Should stay on form page due to validation");
    }

    @Test
    @Order(5)
    @DisplayName("[Happy Path] Test Case 2.5: Delete (Soft-Delete) Package")
    public void testDeletePackage() {
        Assumptions.assumeTrue(createdPackageName != null, "Test 2.1 must pass to run deletion");

        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigate();
        loginPage.login(ConfigReader.getAdminEmail(), ConfigReader.getAdminPassword());
        loginPage.waitForLoginSuccess();

        AdminSubscriptionPage subscriptionPage = new AdminSubscriptionPage(driver);
        subscriptionPage.navigate();

        int initialRows = subscriptionPage.getRowsCount();
        
        subscriptionPage.clickDeleteForPackage(createdPackageName);
        subscriptionPage.confirmDelete();
        
        subscriptionPage.waitForUrlContains("packages");
        
        // Verify it's either removed from the active list or marked as deleted.
        // If it's still in the list, verify the badge says "Đã xóa mềm"
        boolean foundActive = false;
        int rows = subscriptionPage.getRowsCount();
        for (int i = 0; i < rows; i++) {
            if (subscriptionPage.getPackageNameInRow(i).equals(createdPackageName)) {
                foundActive = true;
                break;
            }
        }
        Assertions.assertFalse(foundActive, "Package should no longer be active in the list");
        System.out.println("Successfully deleted package via UI: " + createdPackageName);
    }
}

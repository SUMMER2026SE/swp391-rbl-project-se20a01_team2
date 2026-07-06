package com.ieltsflow.automation.utils;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 * Lớp tiện ích giúp các thành viên khác dễ dàng gọi hàm Login nhanh
 * mà không cần viết lại nhiều lần trong kịch bản của họ.
 */
public class LoginHelper {

    private final WebDriver driver;
    private final WaitHelper waitHelper;

    public LoginHelper(WebDriver driver) {
        this.driver = driver;
        this.waitHelper = new WaitHelper(driver);
    }

    /**
     * Hàm hỗ trợ đăng nhập nhanh qua giao diện UI.
     * Cần cập nhật đúng locators (id, cssSelector) theo mã nguồn Frontend thực tế.
     */
    public void loginViaUI(String email, String password) {
        // TODO: Sửa lại đường dẫn (URL) tới trang Login thực tế của dự án
        driver.get("http://localhost:8080/IELTSFLOW/login");

        // TODO: Cập nhật Locators (Bộ định vị) cho khớp với HTML của trang web
        By emailLocator = By.id("email"); 
        By passwordLocator = By.id("password"); 
        By loginButtonLocator = By.id("btnLogin"); 

        // 1. Chờ input email hiển thị và nhập liệu
        WebElement emailField = waitHelper.waitForElementVisible(emailLocator);
        emailField.clear();
        emailField.sendKeys(email);

        // 2. Nhập mật khẩu
        WebElement passwordField = driver.findElement(passwordLocator);
        passwordField.clear();
        passwordField.sendKeys(password);

        // 3. Chờ nút Login có thể click và bấm đăng nhập
        WebElement loginBtn = waitHelper.waitForElementClickable(loginButtonLocator);
        loginBtn.click();
        
        // 4. (Tùy chọn) Chờ cho đến khi chuyển trang thành công
        // waitHelper.waitForElementVisible(By.id("dashboard-id"));
    }
}

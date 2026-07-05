package automation.utils;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class AuthHelper {
    private WebDriver driver;
    private WaitHelper waitHelper;

    public AuthHelper(WebDriver driver) {
        this.driver = driver;
        this.waitHelper = new WaitHelper(driver);
    }

    /**
     * Hàm hỗ trợ đăng nhập nhanh qua giao diện để các Test Case khác (Mock Test, Learning...) dùng chung
     * mà không phải viết lại code nhập email/password.
     */
    public void quickLogin(String email, String password) {
        // Mở trang đăng nhập (Thay URL tùy vào lúc project chạy thật)
        driver.get("http://localhost:8080/IELTSFLOW/login");
        
        // Chờ và nhập email, password (Locator By.id, By.cssSelector... có thể đổi sau)
        WebElement emailInput = waitHelper.waitForElementVisible(By.name("email"));
        emailInput.clear();
        emailInput.sendKeys(email);
        
        WebElement passInput = driver.findElement(By.name("password"));
        passInput.clear();
        passInput.sendKeys(password);
        
        WebElement loginBtn = waitHelper.waitForElementClickable(By.cssSelector("button[type='submit']"));
        loginBtn.click();
        
        // Đợi một chút để chuyển trang xong (Có thể bắt sự kiện thanh điều hướng)
        // waitHelper.waitForElementVisible(By.id("dashboard-navbar"));
    }
}

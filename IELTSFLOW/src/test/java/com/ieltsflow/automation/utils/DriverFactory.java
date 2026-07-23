package com.ieltsflow.automation.utils;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;

import java.time.Duration;

/**
 * DriverFactory sử dụng ThreadLocal để quản lý WebDriver.
 * Đảm bảo an toàn khi chạy Parallel (nhiều luồng test cùng lúc).
 */
public class DriverFactory {

    private static ThreadLocal<WebDriver> driverThreadLocal = new ThreadLocal<>();

    private DriverFactory() {
        // Private constructor để tránh khởi tạo
    }

    public static WebDriver initDriver() {
        String browser = ConfigReader.getBrowser().toLowerCase();
        boolean isHeadless = ConfigReader.isHeadless();
        WebDriver driver;

        switch (browser) {
            case "firefox":
                FirefoxOptions firefoxOptions = new FirefoxOptions();
                if (isHeadless) firefoxOptions.addArguments("--headless");
                driver = new FirefoxDriver(firefoxOptions);
                break;
                
            case "edge":
                EdgeOptions edgeOptions = new EdgeOptions();
                if (isHeadless) edgeOptions.addArguments("--headless");
                driver = new EdgeDriver(edgeOptions);
                break;
                
            case "chrome":
            default:
                ChromeOptions chromeOptions = new ChromeOptions();
                if (isHeadless) chromeOptions.addArguments("--headless=new");
                chromeOptions.addArguments("--start-maximized");
                chromeOptions.addArguments("--disable-notifications");
                
                // Tự động cấp quyền Micro để tránh lỗi màn hình trắng (Permission check failed)
                chromeOptions.addArguments("--use-fake-ui-for-media-stream");
                chromeOptions.addArguments("--use-fake-device-for-media-stream");
                
                String chromeBinary = ConfigReader.getChromeBinaryPath();
                if (chromeBinary != null && !chromeBinary.isEmpty()) {
                    chromeOptions.setBinary(chromeBinary);
                }
                
                // Tắt popup cảnh báo mật khẩu
                chromeOptions.addArguments("--disable-features=PasswordLeakDetection");
                java.util.Map<String, Object> prefs = new java.util.HashMap<>();
                prefs.put("credentials_enable_service", false);
                prefs.put("profile.password_manager_enabled", false);
                prefs.put("profile.default_content_setting_values.media_stream_mic", 1); // Cấp quyền micro mặc định
                chromeOptions.setExperimentalOption("prefs", prefs);

                driver = new ChromeDriver(chromeOptions);
                break;
        }

        // Cấu hình chung cho WebDriver
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        
        // Đưa driver vào ThreadLocal
        driverThreadLocal.set(driver);
        return getDriver();
    }

    public static WebDriver getDriver() {
        return driverThreadLocal.get();
    }

    public static void quitDriver() {
        if (driverThreadLocal.get() != null) {
            driverThreadLocal.get().quit();
            driverThreadLocal.remove();
        }
    }
}

package com.ieltsflow.automation.base;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.Status;
import com.ieltsflow.automation.utils.ExtentReportManager;
import com.ieltsflow.automation.utils.TestConfig;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.TestInfo;
import org.junit.jupiter.api.extension.AfterTestExecutionCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.TestWatcher;
import org.junit.jupiter.api.extension.RegisterExtension;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.util.Optional;

public class BaseTest {

    protected WebDriver driver;
    protected static ExtentReports extent;
    protected ExtentTest test;

    @BeforeAll
    public static void setupReport() {
        extent = ExtentReportManager.getInstance();
    }

    @BeforeEach
    public void setupDriver(TestInfo testInfo) {
        // Init ExtentTest
        String testName = testInfo.getDisplayName();
        if (testInfo.getTestMethod().isPresent()) {
            testName = testInfo.getTestMethod().get().getName();
        }
        test = extent.createTest(testName);

        // Khởi tạo WebDriver (Chrome)
        ChromeOptions options = new ChromeOptions();
        // options.addArguments("--headless"); // Bỏ comment nếu muốn chạy ngầm không hiện UI
        options.addArguments("--start-maximized");
        options.addArguments("--disable-notifications");
        
        String chromeBinary = TestConfig.getChromeBinaryPath();
        if (chromeBinary != null && !chromeBinary.isEmpty()) {
            options.setBinary(chromeBinary);
        }
        // Tắt popup cảnh báo mật khẩu bị lộ của Chrome (tránh bị chặn trong test)
        options.addArguments("--disable-features=PasswordLeakDetection");
        java.util.Map<String, Object> prefs = new java.util.HashMap<>();
        prefs.put("credentials_enable_service", false);
        prefs.put("profile.password_manager_enabled", false);
        options.setExperimentalOption("prefs", prefs);

        driver = new ChromeDriver(options);
        // Thiết lập Implicit Wait (Khuyên dùng Explicit Wait trong các bài test cụ thể)
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @AfterAll
    public static void flushReport() {
        if (extent != null) {
            extent.flush();
        }
    }

    // Cơ chế chụp màn hình khi test Fail (Chạy trước @AfterEach để giữ WebDriver sống)
    @RegisterExtension
    AfterTestExecutionCallback callback = new AfterTestExecutionCallback() {
        @Override
        public void afterTestExecution(ExtensionContext context) throws Exception {
            if (context.getExecutionException().isPresent()) {
                test.log(Status.FAIL, "Test Failed: " + context.getExecutionException().get().getMessage());
                takeScreenshot(context.getDisplayName());
            } else {
                test.log(Status.PASS, "Test Passed");
            }
        }
    };

    private void takeScreenshot(String testName) {
        if (driver instanceof TakesScreenshot) {
            File source = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            String fileName = testName.replaceAll("[^a-zA-Z0-9.-]", "_") + "_" + System.currentTimeMillis() + ".png";
            Path destination = Paths.get(System.getProperty("user.dir"), "screenshots", fileName);
            try {
                Files.createDirectories(destination.getParent());
                Files.copy(source.toPath(), destination, StandardCopyOption.REPLACE_EXISTING);
                test.addScreenCaptureFromPath("screenshots/" + fileName);
            } catch (IOException e) {
                System.out.println("Exception while taking screenshot: " + e.getMessage());
            }
        }
    }
}

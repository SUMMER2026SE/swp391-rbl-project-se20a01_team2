package com.ieltsflow.automation.base;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.Status;
import com.ieltsflow.automation.utils.ExtentReportManager;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.TestInfo;
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

    // Cơ chế chụp màn hình khi test Fail (Sử dụng JUnit 5 TestWatcher)
    @RegisterExtension
    TestWatcher watcher = new TestWatcher() {
        @Override
        public void testFailed(ExtensionContext context, Throwable cause) {
            test.log(Status.FAIL, "Test Failed: " + cause.getMessage());
            takeScreenshot(context.getDisplayName());
        }

        @Override
        public void testSuccessful(ExtensionContext context) {
            test.log(Status.PASS, "Test Passed");
        }

        @Override
        public void testAborted(ExtensionContext context, Throwable cause) {
            test.log(Status.SKIP, "Test Aborted");
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

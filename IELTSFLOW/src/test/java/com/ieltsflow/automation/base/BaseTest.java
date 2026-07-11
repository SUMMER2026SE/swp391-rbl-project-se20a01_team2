package com.ieltsflow.automation.base;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.Duration;

public class BaseTest {
    protected WebDriver driver;

    @BeforeEach
    public void setUp() {
        System.out.println("[LOG] Starting setUp: Initializing WebDriver...");
        // Explicitly set the geckodriver path to bypass Selenium Manager's automatic download,
        // which gets confused by Waterfox's version string.
        System.setProperty("webdriver.gecko.driver", "/usr/bin/geckodriver");
        
        FirefoxOptions options = new FirefoxOptions();
        // Pointing to the Waterfox binary. Update this path if it's installed somewhere else (e.g., /usr/bin/waterfox-G)
        options.setBinary("/usr/bin/waterfox"); 
        
        // For local testing headless can be omitted, but for remote agents we might need it if X server is not present.
        options.addArguments("--headless");
        options.setCapability(org.openqa.selenium.remote.CapabilityType.UNHANDLED_PROMPT_BEHAVIOUR, org.openqa.selenium.UnexpectedAlertBehaviour.IGNORE);
        
        System.out.println("[LOG] Launching FirefoxDriver...");
        driver = new FirefoxDriver(options);
        System.out.println("[LOG] FirefoxDriver launched successfully.");
        
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(2));
        System.out.println("[LOG] setUp complete.");
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    protected void takeScreenshot(String testName) {
        if (driver instanceof TakesScreenshot) {
            File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            try {
                Path destDir = Paths.get("screenshots");
                if (!Files.exists(destDir)) {
                    Files.createDirectories(destDir);
                }
                Path destFile = destDir.resolve(testName + "_" + System.currentTimeMillis() + ".png");
                Files.copy(screenshot.toPath(), destFile, StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Screenshot saved to " + destFile.toString());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

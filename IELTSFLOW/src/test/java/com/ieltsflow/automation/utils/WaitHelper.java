package com.ieltsflow.automation.utils;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * Lớp tiện ích hỗ trợ Explicit Wait.
 * Thay thế hoàn toàn cho Thread.sleep()
 */
public class WaitHelper {

    private final WebDriverWait wait;

    public WaitHelper(WebDriver driver) {
        // Mặc định chờ tối đa 10 giây
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    public WaitHelper(WebDriver driver, int timeoutInSeconds) {
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(timeoutInSeconds));
    }

    // Chờ cho đến khi phần tử xuất hiện trên DOM và hiển thị trên màn hình
    public WebElement waitForElementVisible(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    // Chờ cho đến khi phần tử có thể click được (không bị disable, không bị che khuất)
    public WebElement waitForElementClickable(By locator) {
        return wait.until(ExpectedConditions.elementToBeClickable(locator));
    }
    
    // Chờ cho đến khi phần tử biến mất (Rất hữu ích khi chờ Loading Spinner ẩn đi)
    public boolean waitForElementInvisible(By locator) {
        return wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }
}

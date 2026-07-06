package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;

public class DummyExampleTest extends BaseTest {

    @Test
    public void testOpenGoogleAndPass() {
        // Step 1: Mở trang web
        driver.get("https://www.google.com");

        // Step 2: Ghi log vào file Report HTML
        test.info("Đã mở trang chủ Google");

        // Step 3: Kiểm tra Title
        String title = driver.getTitle();
        Assertions.assertTrue(title.contains("Google"), "Title không đúng");
    }

}

package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import org.junit.jupiter.api.Assertions;

public class MockTestFlowTest extends BaseTest {

    // Helper: Click bằng JavaScript để xuyên qua mọi popup/overlay
    private void jsClick(WebElement el) {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", el);
    }

    @Test
    public void testMockTestTimer() {
        test.info("Bắt đầu test luồng Mock Test từ đăng nhập đến phòng thi");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

        // ── BƯỚC 1: ĐĂNG NHẬP ──────────────────────────────────────────────
        driver.get("http://localhost:8080/IELTSFLOW/auth");
        WebElement emailInput = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("loginEmail")));
        emailInput.sendKeys("test1@gmail.com");
        driver.findElement(By.id("loginPassword")).sendKeys("Admin1234");
        // Dùng JS click để tránh popup Chrome chặn
        jsClick(driver.findElement(By.cssSelector("#loginForm button[type='submit']")));

        // Chờ đăng nhập xong
        wait.until(ExpectedConditions.urlContains("/candidate/"));
        System.out.println("====== BƯỚC 1 OK: Đăng nhập thành công ======");

        // ── BƯỚC 2: VÀO TRANG THÔNG TIN ĐỀ THI ──────────────────────────
        driver.get("http://localhost:8080/IELTSFLOW/candidate/mock-test");
        
        // ── BƯỚC 3: CLICK "Bắt đầu thi ngay" BẰNG JAVASCRIPT ────────────
        // Dùng JS submit form trực tiếp để popup Chrome không chặn được
        WebElement btnStartMock = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("btn-start-mock-test")));
        System.out.println("====== BƯỚC 3: Tìm thấy nút, đang submit form... ======");
        // Submit form cha của nút thay vì click nút (tránh bị popup chặn)
        ((JavascriptExecutor) driver).executeScript(
            "arguments[0].closest('form').submit();", btnStartMock
        );

        // ── BƯỚC 4: CHỜ VÀO PHÒNG THI & CLICK KÍCH HOẠT BẢO MẬT ────────
        // Chờ nút btn-start-exam xuất hiện (trang take.jsp đã load)
        WebElement btnStartExam = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("btn-start-exam")));
        System.out.println("====== BƯỚC 4 OK: Đã vào phòng thi! URL: " + driver.getCurrentUrl() + " ======");
        jsClick(btnStartExam);
        System.out.println("====== BƯỚC 4 OK: Đã kích hoạt bảo mật ======");

        // ── BƯỚC 5: KIỂM TRA ĐỒNG HỒ ĐẾM NGƯỢC ─────────────────────────
        WebElement dongHo = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("timer")));
        try { Thread.sleep(2000); } catch (InterruptedException e) {}

        String thoiGian = dongHo.getText();
        System.out.println("====== THỜI GIAN ĐANG CHẠY LÀ: " + thoiGian + " ======");

        Assertions.assertNotNull(thoiGian, "Đồng hồ không hiển thị!");
        Assertions.assertFalse(thoiGian.equals("00:00:00"), "Đồng hồ bị đứng im ở 00:00:00!");
        test.pass("✅ Đồng hồ hoạt động tốt, hiển thị: " + thoiGian);

        try { Thread.sleep(5000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    @Test
    public void testFocusModeViolation() {
        test.info("Bắt đầu test chức năng chống gian lận (Focus Mode)");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

        // ── BƯỚC 1: ĐĂNG NHẬP VÀ VÀO PHÒNG THI ─────────────────────────────
        driver.get("http://localhost:8080/IELTSFLOW/auth");
        WebElement emailInput = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("loginEmail")));
        emailInput.sendKeys("test1@gmail.com");
        driver.findElement(By.id("loginPassword")).sendKeys("Admin1234");
        jsClick(driver.findElement(By.cssSelector("#loginForm button[type='submit']")));
        wait.until(ExpectedConditions.urlContains("/candidate/"));

        driver.get("http://localhost:8080/IELTSFLOW/candidate/mock-test");
        WebElement btnStartMock = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("btn-start-mock-test")));
        ((JavascriptExecutor) driver).executeScript("arguments[0].closest('form').submit();", btnStartMock);

        WebElement btnStartExam = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("btn-start-exam")));
        jsClick(btnStartExam);
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("timer")));
        System.out.println("====== Đã vào phòng thi và đếm giờ ======");

        // ── BƯỚC 2: GIẢ LẬP VI PHẠM (ĐỔI TAB/THU NHỎ) LẦN 1 ────────────────
        System.out.println("====== Giả lập chuyển tab lần 1 ======");
        simulateTabSwitch();
        
        // Chờ overlay cảnh báo hiện ra
        WebElement violationOverlay = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("violation-overlay")));
        WebElement vioCount = driver.findElement(By.id("vio-count"));
        Assertions.assertEquals("1", vioCount.getText(), "Số lần vi phạm phải là 1");
        test.pass("✅ Hiển thị cảnh báo vi phạm lần 1 thành công");
        
        // Bấm quay lại thi
        jsClick(driver.findElement(By.id("btn-back-focus")));
        wait.until(ExpectedConditions.invisibilityOf(violationOverlay));
        
        // ── BƯỚC 3: GIẢ LẬP VI PHẠM LẦN 2 ──────────────────────────────────
        try { Thread.sleep(1000); } catch (Exception e) {}
        System.out.println("====== Giả lập chuyển tab lần 2 ======");
        simulateTabSwitch();
        
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("violation-overlay")));
        vioCount = driver.findElement(By.id("vio-count"));
        Assertions.assertEquals("2", vioCount.getText(), "Số lần vi phạm phải là 2");
        test.pass("✅ Hiển thị cảnh báo vi phạm lần 2 thành công");
        
        jsClick(driver.findElement(By.id("btn-back-focus")));
        wait.until(ExpectedConditions.invisibilityOf(violationOverlay));

        // ── BƯỚC 4: GIẢ LẬP VI PHẠM LẦN 3 -> BỊ BUỘC NỘP BÀI ───────────────
        try { Thread.sleep(1000); } catch (Exception e) {}
        System.out.println("====== Giả lập chuyển tab lần 3 (Quá giới hạn) ======");
        simulateTabSwitch();
        
        // Vì code JS của trang gọi document.getElementById('exam-form').submit(); 
        // ngay lập tức khi cheated = true, trang sẽ chuyển đi rất nhanh.
        // Việc chờ forced-overlay hiển thị có thể gây lỗi NoSuchElementException do DOM đã bị hủy.
        // Do đó, ta sẽ kiểm tra trực tiếp việc URL thay đổi (thoát khỏi phòng thi).
        wait.until(ExpectedConditions.not(ExpectedConditions.urlContains("action=take")));
        System.out.println("====== Bài thi đã bị nộp tự động thành công! ======");
        test.pass("✅ Đã khóa bài và hệ thống tự động nộp bài do vi phạm quá 3 lần");
    }

    // Hàm giả lập việc thí sinh thu nhỏ trình duyệt hoặc đổi sang tab khác
    private void simulateTabSwitch() {
        // Selenium không thể kích hoạt event visibilitychange một cách ổn định ở cấp OS,
        // Nên ta gọi trực tiếp hàm xử lý vi phạm của trang web (triggerViolation)
        ((JavascriptExecutor) driver).executeScript("triggerViolation('tab');");
    }
}

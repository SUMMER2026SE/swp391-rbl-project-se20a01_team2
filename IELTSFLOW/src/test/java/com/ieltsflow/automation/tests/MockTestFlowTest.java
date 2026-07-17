package com.ieltsflow.automation.tests;

import com.ieltsflow.automation.base.BaseTest;
import com.ieltsflow.automation.pages.LoginPage;
import com.ieltsflow.automation.pages.MockTestPage;
import com.ieltsflow.automation.utils.ConfigReader;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class MockTestFlowTest extends BaseTest {

    @Test
    public void testMockTestTimer() {
        test.info("Bắt đầu test luồng Mock Test từ đăng nhập đến phòng thi");

        LoginPage loginPage = new LoginPage(driver);
        MockTestPage mockTestPage = new MockTestPage(driver);

        // ── BƯỚC 1: ĐĂNG NHẬP ──────────────────────────────────────────────
        loginPage.login(ConfigReader.getCandidateEmail(), ConfigReader.getCandidatePassword());
        loginPage.waitForLoginSuccess();
        System.out.println("====== BƯỚC 1 OK: Đăng nhập thành công ======");

        // ── BƯỚC 2: VÀO TRANG THÔNG TIN ĐỀ THI ──────────────────────────
        mockTestPage.navigateToMockTestInfo();
        
        // ── BƯỚC 3: CLICK "Bắt đầu thi ngay" ────────────────────────────
        System.out.println("====== BƯỚC 3: Tìm thấy nút, đang submit form... ======");
        mockTestPage.clickStartMockTest();

        // ── BƯỚC 4: CHỜ VÀO PHÒNG THI & CLICK KÍCH HOẠT BẢO MẬT ────────
        mockTestPage.clickStartExamSecurity();
        System.out.println("====== BƯỚC 4 OK: Đã kích hoạt bảo mật ======");

        // ── BƯỚC 5: KIỂM TRA ĐỒNG HỒ ĐẾM NGƯỢC ─────────────────────────
        mockTestPage.waitForTimerToAppear();
        try { Thread.sleep(2000); } catch (InterruptedException e) {}

        String thoiGian = mockTestPage.getTimerText();
        System.out.println("====== THỜI GIAN ĐANG CHẠY LÀ: " + thoiGian + " ======");

        Assertions.assertNotNull(thoiGian, "Đồng hồ không hiển thị!");
        Assertions.assertFalse(thoiGian.equals("00:00:00"), "Đồng hồ bị đứng im ở 00:00:00!");
        test.pass("✅ Đồng hồ hoạt động tốt, hiển thị: " + thoiGian);

        try { Thread.sleep(5000); } catch (InterruptedException e) {}
    }

    @Test
    public void testFocusModeViolation() {
        test.info("Bắt đầu test chức năng chống gian lận (Focus Mode)");

        LoginPage loginPage = new LoginPage(driver);
        MockTestPage mockTestPage = new MockTestPage(driver);

        // ── BƯỚC 1: ĐĂNG NHẬP VÀ VÀO PHÒNG THI ─────────────────────────────
        loginPage.login(ConfigReader.getCandidateEmail(), ConfigReader.getCandidatePassword());
        loginPage.waitForLoginSuccess();

        mockTestPage.navigateToMockTestInfo();
        mockTestPage.clickStartMockTest();
        mockTestPage.clickStartExamSecurity();
        mockTestPage.waitForTimerToAppear();
        System.out.println("====== Đã vào phòng thi và đếm giờ ======");

        // ── BƯỚC 2: GIẢ LẬP VI PHẠM (ĐỔI TAB/THU NHỎ) LẦN 1 ────────────────
        System.out.println("====== Giả lập chuyển tab lần 1 ======");
        mockTestPage.triggerTabSwitchViolation();
        
        mockTestPage.waitForViolationOverlay();
        Assertions.assertEquals("1", mockTestPage.getViolationCount(), "Số lần vi phạm phải là 1");
        test.pass("✅ Hiển thị cảnh báo vi phạm lần 1 thành công");
        
        mockTestPage.clickBackToExam();
        mockTestPage.waitForViolationOverlayToDisappear();
        
        // ── BƯỚC 3: GIẢ LẬP VI PHẠM LẦN 2 ──────────────────────────────────
        try { Thread.sleep(1000); } catch (Exception e) {}
        System.out.println("====== Giả lập chuyển tab lần 2 ======");
        mockTestPage.triggerTabSwitchViolation();
        
        mockTestPage.waitForViolationOverlay();
        Assertions.assertEquals("2", mockTestPage.getViolationCount(), "Số lần vi phạm phải là 2");
        test.pass("✅ Hiển thị cảnh báo vi phạm lần 2 thành công");
        
        mockTestPage.clickBackToExam();
        mockTestPage.waitForViolationOverlayToDisappear();

        // ── BƯỚC 4: GIẢ LẬP VI PHẠM LẦN 3 -> BỊ BUỘC NỘP BÀI ───────────────
        try { Thread.sleep(1000); } catch (Exception e) {}
        System.out.println("====== Giả lập chuyển tab lần 3 (Quá giới hạn) ======");
        mockTestPage.triggerTabSwitchViolation();
        
        mockTestPage.waitForExamToAutoSubmit();
        System.out.println("====== Bài thi đã bị nộp tự động thành công! ======");
        test.pass("✅ Đã khóa bài và hệ thống tự động nộp bài do vi phạm quá 3 lần");
    }
}

package automation.tests;

import automation.base.BaseTest;
import automation.utils.TestListener;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.assertTrue;

// Phải gắn @ExtendWith này vào tất cả các class Test để kích hoạt tự động chụp ảnh khi fail
@ExtendWith(TestListener.class)
public class SampleE2ETest extends BaseTest {

    @Test
    public void testGoogleSearchTitle() {
        getTest().info("Mở trang web Google");
        driver.get("https://www.google.com");
        
        getTest().info("Lấy tiêu đề trang");
        String title = driver.getTitle();
        
        // Test này sẽ PASS (xanh)
        assertTrue(title.contains("Google"), "Tiêu đề trang không khớp!");
    }

    @Test
    public void testFailureTriggerScreenshot() {
        getTest().info("Mở trang web Example");
        driver.get("https://example.com");
        
        // Cố tình tạo ra lỗi (Assertion Error) để kiểm tra xem hệ thống có 
        // chụp màn hình và lưu vào thư mục /screenshots/ hay không.
        assertTrue(driver.getTitle().contains("IELTSFLOW"), "Tiêu đề trang không chứa IELTSFLOW (Cố tình gây lỗi)");
    }
}

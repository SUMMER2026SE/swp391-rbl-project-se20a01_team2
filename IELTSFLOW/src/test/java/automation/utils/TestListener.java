package automation.utils;

import automation.base.BaseTest;
import com.aventstack.extentreports.Status;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.TestWatcher;

public class TestListener implements TestWatcher {

    @Override
    public void testSuccessful(ExtensionContext context) {
        Object testInstance = context.getRequiredTestInstance();
        if (testInstance instanceof BaseTest) {
            ((BaseTest) testInstance).getTest().log(Status.PASS, "Test Passed");
        }
    }

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        Object testInstance = context.getRequiredTestInstance();
        if (testInstance instanceof BaseTest) {
            BaseTest baseTest = (BaseTest) testInstance;
            String testName = context.getDisplayName();
            
            // Log lỗi vào file report HTML
            baseTest.getTest().log(Status.FAIL, "Test Failed: " + cause.getMessage());
            
            // Tự động chụp ảnh màn hình khi có Exception / Assertion Error
            String screenshotPath = baseTest.takeScreenshot(testName);
            if (screenshotPath != null) {
                // Đính kèm ảnh vào Extent Report
                baseTest.getTest().addScreenCaptureFromPath(screenshotPath, "Screenshot of Failure");
            }
        }
    }
}

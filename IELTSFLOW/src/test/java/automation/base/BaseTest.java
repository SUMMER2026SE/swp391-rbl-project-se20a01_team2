package automation.base;

import automation.utils.ReportManager;
import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.TestInfo;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.Duration;

public class BaseTest {
    protected WebDriver driver;
    protected static ExtentReports extent;
    protected ExtentTest test;

    @BeforeAll
    public static void setUpReport() {
        extent = ReportManager.getInstance();
    }

    @BeforeEach
    public void setUp(TestInfo testInfo) {
        // Khởi tạo báo cáo cho test case hiện tại
        test = extent.createTest(testInfo.getDisplayName());

        // Cấu hình Chrome
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--remote-allow-origins=*");
        // Thêm --headless nếu muốn chạy ngầm không hiện giao diện UI (dành cho server CI/CD)
        // options.addArguments("--headless"); 

        driver = new ChromeDriver(options);
        driver.manage().window().maximize();
        
        // Cấu hình Implicit Wait mặc định
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @AfterAll
    public static void tearDownReport() {
        if (extent != null) {
            extent.flush(); // Bắt buộc gọi để xuất file HTML
        }
    }

    public WebDriver getDriver() {
        return driver;
    }

    public ExtentTest getTest() {
        return test;
    }

    // Hàm tiện ích tự động chụp ảnh màn hình
    public String takeScreenshot(String testName) {
        if (driver == null) return null;
        
        File source = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        String fileName = testName.replaceAll("[^a-zA-Z0-9.-]", "_") + "_" + System.currentTimeMillis() + ".png";
        String destinationPath = System.getProperty("user.dir") + "/screenshots/" + fileName;
        File finalDestination = new File(destinationPath);
        
        finalDestination.getParentFile().mkdirs(); // Tự động tạo thư mục screenshots nếu chưa có
        
        try {
            Files.copy(source.toPath(), finalDestination.toPath(), StandardCopyOption.REPLACE_EXISTING);
            return "screenshots/" + fileName; // Trả về đường dẫn tương đối để gắn vào report html
        } catch (IOException e) {
            System.out.println("Lỗi lưu ảnh chụp màn hình: " + e.getMessage());
            return null;
        }
    }
}

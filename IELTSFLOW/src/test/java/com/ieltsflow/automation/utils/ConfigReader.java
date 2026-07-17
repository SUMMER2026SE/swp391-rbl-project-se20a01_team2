package com.ieltsflow.automation.utils;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.InputStream;
import java.util.Properties;

/**
 * Đọc cấu hình theo ưu tiên: System Property > .env > {env}.properties > OS Env > Default
 */
public class ConfigReader {
    private static Properties properties;
    private static Dotenv dotenv;

    static {
        // 1. Tải .env file (Ưu tiên các biến bảo mật, API keys)
        try {
            dotenv = Dotenv.configure()
                    .directory(System.getProperty("user.dir") + "/src/main/webapp/WEB-INF/")
                    .ignoreIfMissing()
                    .load();
        } catch (Exception e) {
            System.out.println("Could not load .env file or dotenv is missing.");
        }

        // 2. Xác định môi trường (Lấy từ tham số Maven: mvn test -Denv=staging)
        String env = System.getProperty("env");
        if (env == null || env.isEmpty()) {
            env = "dev"; // Mặc định là dev
        }

        // 3. Tải file properties của môi trường tương ứng
        properties = new Properties();
        try {
            String propertyFilePath = "/config/" + env + ".properties";
            InputStream is = ConfigReader.class.getResourceAsStream(propertyFilePath);
            if (is != null) {
                properties.load(is);
            } else {
                System.out.println("⚠️ Không tìm thấy file cấu hình: " + propertyFilePath);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getProperty(String key, String defaultValue) {
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.isEmpty()) return sysProp;

        if (dotenv != null) {
            String envVar = dotenv.get(key);
            if (envVar != null && !envVar.isEmpty()) return envVar;
        }

        String prop = properties.getProperty(key);
        if (prop != null && !prop.isEmpty()) return prop;

        String osEnv = System.getenv(key);
        if (osEnv != null && !osEnv.isEmpty()) return osEnv;

        return defaultValue;
    }

    public static String getProperty(String key) {
        return getProperty(key, null);
    }

    // --- Các hàm cấu hình chung ---
    public static String getBrowser() {
        return getProperty("browser", "chrome"); // chrome, firefox, edge
    }

    public static boolean isHeadless() {
        return Boolean.parseBoolean(getProperty("headless", "false"));
    }

    public static String getChromeBinaryPath() {
        return getProperty("TEST_CHROME_BINARY_PATH", "");
    }

    public static String getBaseUrl() {
        return getProperty("TEST_BASE_URL", "https://ieltsflow.tanmanh350.ovh");
    }

    // Các hàm tài khoản (thay thế cho ConfigReader cũ)
    public static String getAdminEmail() {
        return getProperty("TEST_ADMIN_EMAIL", "admin@tanmanh350.ovh");
    }

    public static String getAdminPassword() {
        return getProperty("TEST_ADMIN_PASSWORD", "Alonept2");
    }

    public static String getCandidateEmail() {
        return getProperty("TEST_CANDIDATE_EMAIL", "Candidate@tanmanh350.ovh");
    }

    public static String getCandidatePassword() {
        return getProperty("TEST_CANDIDATE_PASSWORD", "Alonept2");
    }

    public static String getMentorEmail() {
        return getProperty("TEST_MENTOR_EMAIL", "mentor@tanmanh350.ovh");
    }

    public static String getMentorPassword() {
        return getProperty("TEST_MENTOR_PASSWORD", "Alonept2");
    }
}

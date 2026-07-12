package com.ieltsflow.automation.utils;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class TestConfig {
    private static Properties properties;

    static {
        properties = new Properties();
        try {
            // Priority 1: Check system environment variables (useful for CI/CD)
            // Priority 2: Check local .env file in the webapp folder
            String envPath = System.getProperty("user.dir") + "/src/main/webapp/WEB-INF/.env";
            try (InputStream input = new FileInputStream(envPath)) {
                properties.load(input);
            }
        } catch (Exception e) {
            System.out.println("No local .env file found or error reading it. Relying on System Properties/Env Vars.");
        }
    }

    public static String getProperty(String key, String defaultValue) {
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.isEmpty()) return sysProp;

        String envVar = System.getenv(key);
        if (envVar != null && !envVar.isEmpty()) return envVar;

        return properties.getProperty(key, defaultValue);
    }

    public static String getBaseUrl() {
        return getProperty("TEST_BASE_URL", "http://localhost:8080/IELTSFLOW");
    }

    public static String getAdminEmail() {
        return getProperty("TEST_ADMIN_EMAIL", "admin@gmail.com");
    }

    public static String getAdminPassword() {
        return getProperty("TEST_ADMIN_PASSWORD", "admin123");
    }

    public static String getCandidateEmail() {
        return getProperty("TEST_CANDIDATE_EMAIL", "candidate1@gmail.com");
    }

    public static String getCandidatePassword() {
        return getProperty("TEST_CANDIDATE_PASSWORD", "12345678");
    }

    public static String getMentorEmail() {
        return getProperty("TEST_MENTOR_EMAIL", "mentor1@gmail.com");
    }

    public static String getMentorPassword() {
        return getProperty("TEST_MENTOR_PASSWORD", "12345678");
    }

    public static String getChromeBinaryPath() {
        return getProperty("TEST_CHROME_BINARY_PATH", "");
    }
}

package com.ieltsflow.automation.utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Properties;
import java.io.FileInputStream;

public class MockPaymentHelper {

    private static String getEnvValue(String key) {
        try {
            // Read from .env file
            String envPath = System.getProperty("user.dir") + "/src/main/webapp/WEB-INF/.env";
            Properties props = new Properties();
            props.load(new FileInputStream(envPath));
            return props.getProperty(key);
        } catch (Exception e) {
            return null;
        }
    }

    public static boolean sendMockWebhook(String transactionIdStr, int amount) {
        try {
            // Generate mock SePay JSON payload
            String payload = "{\n" +
                    "  \"id\": " + System.currentTimeMillis() + ",\n" +
                    "  \"gateway\": \"TPBank\",\n" +
                    "  \"transactionDate\": \"2026-07-11 15:00:00\",\n" +
                    "  \"accountNumber\": \"13570999999\",\n" +
                    "  \"subAccount\": null,\n" +
                    "  \"code\": \"IF" + transactionIdStr + "\",\n" +
                    "  \"content\": \"TKPSIF IF" + transactionIdStr + "\",\n" +
                    "  \"transferType\": \"in\",\n" +
                    "  \"transferAmount\": " + amount + ",\n" +
                    "  \"accumulated\": 1000000,\n" +
                    "  \"referenceCode\": \"REF" + System.currentTimeMillis() + "\",\n" +
                    "  \"description\": \"Thanh toan goi pro\"\n" +
                    "}";

            // Get secret from .env
            String secret = getEnvValue("SEPAY_WEBHOOK_SECRET");
            if (secret == null) {
                secret = "whsec_J5QRPOXksOtdkSQH8RRxCuDw7SjFJphV"; // default
            }

            // Calculate HMAC-SHA256 signature (assuming this is how SePay signs)
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            
            // Just for completeness - SePay might send Authorization: Apikey ... or Signature: ...
            // We will just send it as Authorization header
            String signature = bytesToHex(sha256_HMAC.doFinal(payload.getBytes(StandardCharsets.UTF_8)));

            // Send HTTP POST request
            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(ConfigReader.getBaseUrl() + "/webhook/sepay"))
                    .header("Content-Type", "application/json")
                    // .header("Signature", signature) // Uncomment if backend requires
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("Webhook Response Code: " + response.statusCode());
            System.out.println("Webhook Response Body: " + response.body());
            
            return response.statusCode() == 200;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
}

package util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import model.Transaction;

public class SePayUtil {

    private SePayUtil() {
    }

    public static String generateQRUrl(Transaction transaction) {
        String bankAcc = System.getProperty("SEPAY_BANK_ACC", "");
        String bankName = System.getProperty("SEPAY_BANK_NAME", "");
        
        String amount = String.valueOf(transaction.getAmount().intValue());
        String content = "TKPIF0 IF" + String.format("%02d", transaction.getTransactionId());
        
        return "https://qr.sepay.vn/img?acc=" + bankAcc + "&bank=" + bankName + "&amount=" + amount + "&des=" + content + "&template=compact";
    }

    public static boolean verifyHmacSignature(String rawBody, String signature) {
        String secretKey = System.getProperty("SEPAY_WEBHOOK_SECRET", "");
        if (secretKey.isEmpty()) {
            System.err.println("SePayUtil: Secret Key is missing!");
            return false;
        }
        
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            
            byte[] hash = sha256_HMAC.doFinal(rawBody.getBytes(StandardCharsets.UTF_8));
            
            // Hex encode
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString().equalsIgnoreCase(signature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

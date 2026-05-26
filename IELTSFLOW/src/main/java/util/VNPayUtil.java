package util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Utility class for building the VNPay payment URL and verifying
 * the HMAC-SHA512 checksum returned by VNPay.
 */
public final class VNPayUtil {

    private static final DateTimeFormatter VNP_FMT =
            DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private static final ZoneId VN_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private VNPayUtil() {}

    // ─────────────────────────────────────────────────────────────────────────
    //  Public API
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Builds the full redirect URL that sends the customer to VNPay.
     *
     * @param orderId     DB-generated order id (used as vnp_TxnRef)
     * @param amountVnd   Order total in VND (integer, no decimals)
     * @param orderInfo   Short ASCII description, e.g. "Thanh toan don hang #42"
     * @param ipAddress   Customer's remote IP address
     * @param returnUrl   Absolute URL VNPay redirects back to after payment
     * @return Full VNPay payment URL with secure hash appended
     */
    public static String buildPaymentUrl(int orderId,
                                         long amountVnd,
                                         String orderInfo,
                                         String ipAddress,
                                         String returnUrl) {

        LocalDateTime now    = LocalDateTime.now(VN_ZONE);
        LocalDateTime expire = now.plusMinutes(VNPayConfig.EXPIRE_MINUTES);

        // Collect all required params (vnp_SecureHash is added later)
        Map<String, String> params = new TreeMap<>();   // TreeMap sorts by key ascending
        params.put("vnp_Version",    VNPayConfig.VERSION);
        params.put("vnp_Command",    VNPayConfig.COMMAND);
        params.put("vnp_TmnCode",    VNPayConfig.TMN_CODE);
        params.put("vnp_Amount",     String.valueOf(amountVnd * 100L));  // x100 to remove decimals
        params.put("vnp_CreateDate", now.format(VNP_FMT));
        params.put("vnp_CurrCode",   VNPayConfig.CURR_CODE);
        params.put("vnp_IpAddr",     ipAddress);
        params.put("vnp_Locale",     VNPayConfig.LOCALE);
        params.put("vnp_OrderInfo",  orderInfo);
        params.put("vnp_OrderType",  VNPayConfig.ORDER_TYPE);
        params.put("vnp_ReturnUrl",  returnUrl);
        params.put("vnp_TxnRef",     String.valueOf(orderId));
        params.put("vnp_ExpireDate", expire.format(VNP_FMT));

        // Build hash-data string and query string simultaneously
        StringBuilder hashData  = new StringBuilder();
        StringBuilder queryStr  = new StringBuilder();

        Iterator<Map.Entry<String, String>> it = params.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, String> entry = it.next();
            String encodedKey   = urlEncode(entry.getKey());
            String encodedValue = urlEncode(entry.getValue());

            hashData.append(encodedKey).append('=').append(encodedValue);
            queryStr.append(encodedKey).append('=').append(encodedValue);

            if (it.hasNext()) {
                hashData.append('&');
                queryStr.append('&');
            }
        }

        // Compute and append secure hash
        String secureHash = hmacSHA512(VNPayConfig.HASH_SECRET, hashData.toString());
        queryStr.append("&vnp_SecureHash=").append(secureHash);

        return VNPayConfig.PAY_URL + "?" + queryStr;
    }

    /**
     * Verifies that the params returned by VNPay have a valid checksum.
     *
     * @param params All request parameters (including vnp_SecureHash)
     * @return {@code true} if the signature is valid
     */
    public static boolean verifyChecksum(Map<String, String[]> params) {
        String receivedHash = getSingleParam(params, "vnp_SecureHash");
        if (receivedHash == null) return false;

        // Re-build sorted param map excluding the hash fields
        Map<String, String> data = new TreeMap<>();
        for (Map.Entry<String, String[]> entry : params.entrySet()) {
            String key = entry.getKey();
            if ("vnp_SecureHash".equals(key) || "vnp_SecureHashType".equals(key)) continue;
            if (key.startsWith("vnp_")) {
                data.put(key, entry.getValue()[0]);
            }
        }

        StringBuilder hashData = new StringBuilder();
        Iterator<Map.Entry<String, String>> it = data.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, String> entry = it.next();
            hashData.append(urlEncode(entry.getKey()))
                    .append('=')
                    .append(urlEncode(entry.getValue()));
            if (it.hasNext()) hashData.append('&');
        }

        String expectedHash = hmacSHA512(VNPayConfig.HASH_SECRET, hashData.toString());
        return expectedHash.equalsIgnoreCase(receivedHash);
    }

    /** Convenience: extract a single-value request parameter. */
    public static String getSingleParam(Map<String, String[]> params, String name) {
        String[] vals = params.get(name);
        return (vals != null && vals.length > 0) ? vals[0] : null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    //  Internals
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Computes HMAC-SHA512 of {@code data} with the given {@code key}.
     * Returns a lowercase hex string.
     */
    public static String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(hash.length * 2);
            for (byte b : hash) sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("HMAC-SHA512 failed", e);
        }
    }

    /** URL-encodes a string using UTF-8 (same behaviour as PHP urlencode). */
    private static String urlEncode(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}

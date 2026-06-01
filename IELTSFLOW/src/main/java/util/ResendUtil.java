package util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Low-level Resend helper using standard Java HttpURLConnection.
 * Provides custom 3-second timeouts to avoid blocking application threads.
 */
public class ResendUtil {

    private ResendUtil() {}

    private static String getApiKey() {
        String key = System.getProperty("RESEND_API_KEY");
        return (key != null && !key.isEmpty()) ? key : "";
    }

    /**
     * Sends an HTML email via Resend API using standard HttpURLConnection.
     *
     * @param from    Full sender string, e.g. "IELTS Flow <noreply@email.tanmanh350.ovh>"
     * @param to      Recipient email address
     * @param subject Email subject line
     * @param htmlBody HTML body of the email
     * @return true if the email was accepted, false on error
     */
    public static boolean sendMail(String from, String to, String subject, String htmlBody) {
        String apiKey = getApiKey();
        if (apiKey.isEmpty()) {
            System.err.println("ResendUtil: API Key is missing!");
            return false;
        }

        try {
            URL url = new URL("https://api.resend.com/emails");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            
            // Set 3-second connect and read timeouts to prevent hanging threads
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);

            // Escape JSON strings
            String escapedFrom = escapeJson(from);
            String escapedTo = escapeJson(to);
            String escapedSubject = escapeJson(subject);
            String escapedHtml = escapeJson(htmlBody);

            String jsonPayload = "{"
                    + "\"from\":\"" + escapedFrom + "\","
                    + "\"to\":\"" + escapedTo + "\","
                    + "\"subject\":\"" + escapedSubject + "\","
                    + "\"html\":\"" + escapedHtml + "\""
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            if (code >= 200 && code < 300) {
                System.out.println("ResendUtil: email sent successfully via HTTP to " + to);
                return true;
            } else {
                System.err.println("ResendUtil: HTTP error response code = " + code);
                return false;
            }

        } catch (Exception e) {
            System.err.println("ResendUtil: failed to send email to " + to + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static String escapeJson(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            switch (ch) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (ch < ' ') {
                        String t = "000" + java.lang.Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }
}

package util;

import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;

/**
 * Low-level Resend helper.
 * Exposes a single unified sendMail method that all higher-level services
 * should use instead of calling the Resend SDK directly.
 *
 * Configuration (set as System properties by AppContextListener):
 *   RESEND_API_KEY  – Resend secret key
 */
public class ResendUtil {

    private ResendUtil() {}

    private static String getApiKey() {
        String key = System.getProperty("RESEND_API_KEY");
        return (key != null && !key.isEmpty()) ? key : "";
    }

    /**
     * Sends an HTML email via Resend.
     *
     * @param from    Full RFC-5322 sender string, e.g. {@code "RubyTech <noreply@example.com>"}
     * @param to      Recipient email address
     * @param subject Email subject line
     * @param htmlBody HTML body of the email
     * @return {@code true} if the email was accepted by Resend, {@code false} on error
     */
    public static boolean sendMail(String from, String to, String subject, String htmlBody) {
        Resend resend = new Resend(getApiKey());

        CreateEmailOptions params = CreateEmailOptions.builder()
                .from(from)
                .to(to)
                .subject(subject)
                .html(htmlBody)
                .build();

        try {
            CreateEmailResponse response = resend.emails().send(params);
            System.out.println("ResendUtil: email sent id=" + response.getId()
                    + " to=" + to + " subject=" + subject);
            return true;
        } catch (ResendException e) {
            System.err.println("ResendUtil: failed to send email to " + to + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

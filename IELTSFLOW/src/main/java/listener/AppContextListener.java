package listener;

import io.github.cdimascio.dotenv.Dotenv;
import util.JpaHelper;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Arrays;
import java.util.List;

/**
 * Loads configuration from WEB-INF/.env at startup,
 * then closes the JPA EntityManagerFactory on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final List<String> SUPPORTED_KEYS = Arrays.asList(
            "RESEND_API_KEY",
            "RESEND_SEND_DOMAIN",
            "DB_URL",
            "DB_HOST",
            "DB_PORT",
            "DB_NAME",
            "DB_USER",
            "DB_PASSWORD",
            "DB_ENCRYPT",
            "DB_TRUST_SERVER_CERT",
            "DB_EXTRA_PARAMS"
    );

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Load .env from WEB-INF and publish supported values as System properties.
        String webInfPath = sce.getServletContext().getRealPath("/WEB-INF");
        if (webInfPath != null) {
            try {
                Dotenv dotenv = Dotenv.configure()
                        .directory(webInfPath)
                        .filename(".env")
                        .ignoreIfMissing()
                        .load();

                for (String key : SUPPORTED_KEYS) {
                    String value = dotenv.get(key);
                    if (value != null && !value.isBlank()) {
                        System.setProperty(key, value);
                    }
                }

                System.out.println("AppContextListener: .env loaded from " + webInfPath);
            } catch (Exception e) {
                System.err.println("AppConte"
                        + ""
                        + ""
                        + ""
                        + ""
                        + "xtListener: failed to load .env - " + e.getMessage());
            }
        }

        // Warm up JPA after .env load; continue startup if DB is temporarily unavailable.
        try {
            JpaHelper.getEntityManager().close();
        } catch (Exception e) {
            System.err.println("AppContextListener: could not warm up JPA - " + e.getMessage());
        }
        System.out.println("Application started. JPA EntityManagerFactory initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JpaHelper.close();
        System.out.println("Application stopped. JPA EntityManagerFactory closed.");
    }
}

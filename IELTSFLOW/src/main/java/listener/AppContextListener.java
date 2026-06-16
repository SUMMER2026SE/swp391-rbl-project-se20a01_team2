package listener;

import io.github.cdimascio.dotenv.Dotenv;
import util.JpaHelper;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Arrays;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.time.LocalDateTime;
import dao.UserLessonProgressDAO;
import services.NotificationService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import services.TransactionService;
import services.TransactionServiceImpl;

/**
 * Loads configuration from WEB-INF/.env at startup,
 * then closes the JPA EntityManagerFactory on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private Timer reminderTimer;

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
            "DB_EXTRA_PARAMS",
            "VNPAY_TMN_CODE",
            "VNPAY_HASH_SECRET",
            "SPEECH_KEY",
            "SPEECH_REGION",
            "GEMINI_API_KEYS",
            "GOOGLE_CLIENT_ID",
            "SEPAY_BANK_ACC",
            "SEPAY_BANK_NAME",
            "SEPAY_BANK_ACCOUNT_NAME",
            "SEPAY_WEBHOOK_SECRET"
    );

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
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
                System.err.println("AppContextListener: failed to load .env - " + e.getMessage());
            }
        }

        try {
            JpaHelper.getEntityManager().close();
        } catch (Exception e) {
            System.err.println("AppContextListener: could not warm up JPA - " + e.getMessage());
        }
        
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                TransactionService transactionService = new TransactionServiceImpl();
                transactionService.expireOldTransactions(1);
            } catch (Exception e) {
                System.err.println("AppContextListener: Error expiring transactions - " + e.getMessage());
            }
        }, 5, 10, TimeUnit.MINUTES);
        
        System.out.println("Application started. JPA initialized.");

        // Start background job for study reminders
        reminderTimer = new Timer(true);
        reminderTimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    System.out.println("Running automatic study reminder task...");
                    UserLessonProgressDAO progressDAO = new UserLessonProgressDAO();
                    NotificationService notifService = new NotificationService();
                    
                    // Find users who haven't studied for 3 days
                    LocalDateTime threeDaysAgo = LocalDateTime.now().minusDays(3);
                    List<Integer> inactiveUsers = progressDAO.findInactiveUsers(threeDaysAgo);
                    
                    for (Integer userId : inactiveUsers) {
                        try {
                            notifService.createReminder(userId, "Nhắc nhở học tập", 
                                "Đã 3 ngày bạn chưa luyện tập IELTS. Hãy dành chút thời gian vào ôn tập nhé để đạt được mục tiêu!");
                        } catch (Exception ignored) { }
                    }
                } catch (Exception e) {
                    System.err.println("Error in reminder task: " + e.getMessage());
                }
            }
        }, 60000, 86400000L); // Delay 1 min, run every 24h
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (reminderTimer != null) {
            reminderTimer.cancel();
        }
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        JpaHelper.close();
        System.out.println("Application stopped.");
    }
}
package listener;

import dao.UploadSessionDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;
import java.sql.Timestamp;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class UploadCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private final UploadSessionDAO sessionDAO = new UploadSessionDAO();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        String tempDirPath = sce.getServletContext().getRealPath("/material/temp");
        
        // Run every 3 hours
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("[UploadCleanupListener] Running scheduled cleanup of abandoned chunk files...");
                long thresholdMs = System.currentTimeMillis() - (3 * 60 * 60 * 1000); // 3 hours
                Timestamp thresholdTimestamp = new Timestamp(thresholdMs);
                
                // Cleanup DB
                sessionDAO.deleteOlderThan(thresholdTimestamp);
                
                // Cleanup Files
                if (tempDirPath != null) {
                    File tempDir = new File(tempDirPath);
                    if (tempDir.exists() && tempDir.isDirectory()) {
                        File[] files = tempDir.listFiles((dir, name) -> name.endsWith(".part"));
                        if (files != null) {
                            for (File f : files) {
                                if (f.lastModified() < thresholdMs) {
                                    f.delete();
                                    System.out.println("[UploadCleanupListener] Deleted abandoned chunk: " + f.getName());
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("[UploadCleanupListener] Error during cleanup: " + e.getMessage());
            }
        }, 1, 3, TimeUnit.HOURS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
    }
}

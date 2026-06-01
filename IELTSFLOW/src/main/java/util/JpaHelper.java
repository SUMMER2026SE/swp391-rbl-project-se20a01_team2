package util;

import jakarta.persistence.*;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 * Trợ giúp JPA với khởi tạo lazy (trì hoãn) để đảm bảo
 * AppContextListener đã load .env vào System properties trước khi kết nối DB.
 */
public class JpaHelper {

    // Dùng Initialization-on-demand holder pattern để lazy + thread-safe
    private static class Holder {
        static final EntityManagerFactory FACTORY =
                Persistence.createEntityManagerFactory("IELTSFLOW", buildJpaOverrides());
    }

    private static Map<String, String> buildJpaOverrides() {
        Map<String, String> overrides = new HashMap<>();

        // Ưu tiên System property (được set bởi AppContextListener từ .env)
        String jdbcUrl = readConfig("DB_URL", null);
        if (jdbcUrl == null || jdbcUrl.isBlank()) {
            jdbcUrl = buildDefaultJdbcUrl();
        }
        String jdbcUser     = readConfig("DB_USER",     "sa");
        String jdbcPassword = readConfig("DB_PASSWORD", "123456");

        overrides.put("jakarta.persistence.jdbc.url",      jdbcUrl);
        overrides.put("jakarta.persistence.jdbc.user",     jdbcUser);
        overrides.put("jakarta.persistence.jdbc.password", jdbcPassword);

        System.out.println("[JpaHelper] Connecting to: " + jdbcUrl + " (user=" + jdbcUser + ")");
        return overrides;
    }

    private static String buildDefaultJdbcUrl() {
        String host    = readConfig("DB_HOST",             "localhost");
        String port    = readConfig("DB_PORT",             "1433");
        String dbName  = readConfig("DB_NAME",             "IELTSFlow");
        String encrypt = readConfig("DB_ENCRYPT",          "True");
        String trust   = readConfig("DB_TRUST_SERVER_CERT","True");
        String extra   = readConfig("DB_EXTRA_PARAMS",
                "sendStringParametersAsUnicode=true;characterEncoding=UTF-8");

        return "jdbc:sqlserver://" + host + ":" + port
                + ";databaseName=" + dbName
                + ";Encrypt=" + encrypt
                + ";TrustServerCertificate=" + trust
                + ";" + extra;
    }

    private static String readConfig(String key, String defaultValue) {
        String val = System.getProperty(key);
        if (val != null && !val.isBlank()) {
            return val;
        }
        return defaultValue;
    }

    /** Lấy EntityManagerFactory (lazy init) */
    public static EntityManagerFactory getFactory() {
        return Holder.FACTORY;
    }

    /** Tạo một EntityManager mới */
    public static EntityManager getEntityManager() {
        return Holder.FACTORY.createEntityManager();
    }

    /** Thực thi một thao tác ghi (INSERT, UPDATE, DELETE) trong transaction */
    public static void execute(Consumer<EntityManager> action) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            action.accept(em);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /** Thực thi một thao tác đọc (SELECT) */
    public static <R> R query(Function<EntityManager, R> action) {
        EntityManager em = getEntityManager();
        try {
            return action.apply(em);
        } finally {
            em.close();
        }
    }

    /** Đóng EntityManagerFactory khi ứng dụng shutdown */
    public static void close() {
        if (Holder.FACTORY != null && Holder.FACTORY.isOpen()) {
            Holder.FACTORY.close();
        }
    }
}

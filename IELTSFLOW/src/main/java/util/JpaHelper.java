package util;

import jakarta.persistence.*;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;

public class JpaHelper {

    private static final EntityManagerFactory factory =
            Persistence.createEntityManagerFactory("IELTSFLOW", buildJpaOverrides());

    private static Map<String, String> buildJpaOverrides() {
        Map<String, String> overrides = new HashMap<>();

        String jdbcUrl = readConfig("DB_URL", buildDefaultJdbcUrl());
        String jdbcUser = readConfig("DB_USER", "sa");
        String jdbcPassword = readConfig("DB_PASSWORD", "Alonept2");

        overrides.put("jakarta.persistence.jdbc.url", jdbcUrl);
        overrides.put("jakarta.persistence.jdbc.user", jdbcUser);
        overrides.put("jakarta.persistence.jdbc.password", jdbcPassword);

        return overrides;
    }

    private static String buildDefaultJdbcUrl() {
        String host = readConfig("DB_HOST", "localhost");
        String port = readConfig("DB_PORT", "1433");
        String dbName = readConfig("DB_NAME", "IELTSFLOW");
        String encrypt = readConfig("DB_ENCRYPT", "True");
        String trust = readConfig("DB_TRUST_SERVER_CERT", "True");
        String extra = readConfig("DB_EXTRA_PARAMS", "sendStringParametersAsUnicode=true;characterEncoding=UTF-8");

        return "jdbc:sqlserver://" + host + ":" + port
                + ";databaseName=" + dbName
                + ";Encrypt=" + encrypt
                + ";TrustServerCertificate=" + trust
                + ";" + extra;
    }

    private static String readConfig(String key, String defaultValue) {
        String fromProperty = System.getProperty(key);
        if (fromProperty != null && !fromProperty.isBlank()) {
            return fromProperty;
        }

        return defaultValue;
    }

    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

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

    public static <R> R query(Function<EntityManager, R> action) {
        EntityManager em = getEntityManager();
        try {
            return action.apply(em);
        } finally {
            em.close();
        }
    }

    public static void close() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}

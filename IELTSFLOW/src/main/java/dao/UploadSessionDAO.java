package dao;

import model.UploadSession;
import util.JpaHelper;

import java.sql.Timestamp;

public class UploadSessionDAO {

    public UploadSession save(UploadSession session) {
        try {
            JpaHelper.execute(em -> em.persist(session));
            return session;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public UploadSession findById(String uploadId) {
        try {
            return JpaHelper.query(em -> em.find(UploadSession.class, uploadId));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void delete(String uploadId) {
        try {
            JpaHelper.execute(em -> {
                UploadSession session = em.find(UploadSession.class, uploadId);
                if (session != null) {
                    em.remove(session);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteOlderThan(Timestamp timestamp) {
        try {
            JpaHelper.execute(em -> {
                em.createQuery("DELETE FROM UploadSession u WHERE u.createdAt < :timestamp")
                  .setParameter("timestamp", timestamp)
                  .executeUpdate();
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package dao;

import jakarta.persistence.TypedQuery;
import model.SubscriptionPackage;
import util.JpaHelper;

import java.util.List;

public class SubscriptionPackageDAO {

    public List<SubscriptionPackage> getAllActivePackages() {
        return JpaHelper.query(em -> {
            TypedQuery<SubscriptionPackage> query = em.createQuery(
                    "SELECT p FROM SubscriptionPackage p WHERE p.deleted = false", SubscriptionPackage.class);
            return query.getResultList();
        });
    }

    public List<SubscriptionPackage> getAllPackages() {
        return JpaHelper.query(em -> {
            TypedQuery<SubscriptionPackage> query = em.createQuery(
                    "SELECT p FROM SubscriptionPackage p", SubscriptionPackage.class);
            return query.getResultList();
        });
    }

    public SubscriptionPackage getPackageById(int id) {
        return JpaHelper.query(em -> em.find(SubscriptionPackage.class, id));
    }

    public void addPackage(SubscriptionPackage pkg) {
        JpaHelper.execute(em -> em.persist(pkg));
    }

    public void updatePackage(SubscriptionPackage pkg) {
        JpaHelper.execute(em -> em.merge(pkg));
    }

    public void softDeletePackage(int id) {
        JpaHelper.execute(em -> {
            SubscriptionPackage pkg = em.find(SubscriptionPackage.class, id);
            if (pkg != null) {
                pkg.setDeleted(true);
                em.merge(pkg);
            }
        });
    }

    public void restorePackage(int id) {
        JpaHelper.execute(em -> {
            SubscriptionPackage pkg = em.find(SubscriptionPackage.class, id);
            if (pkg != null) {
                pkg.setDeleted(false);
                em.merge(pkg);
            }
        });
    }
}

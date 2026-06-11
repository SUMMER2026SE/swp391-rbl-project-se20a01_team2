package dao;

import jakarta.persistence.TypedQuery;
import model.SubscriptionPackage;
import util.JpaHelper;

import java.util.List;

public class SubscriptionPackageDAO {

    public List<SubscriptionPackage> getActivePackagesPaginated(int offset, int limit) {
        return getPackagesPaginated(offset, limit, "active", "");
    }

    public long getTotalActivePackagesCount() {
        return getTotalPackagesCount("active");
    }

    public List<SubscriptionPackage> getPackagesPaginated(int offset, int limit, String statusFilter, String sortOption) {
        return JpaHelper.query(em -> {
            String jpql = "SELECT p FROM SubscriptionPackage p WHERE 1=1 ";
            
            if ("active".equals(statusFilter)) {
                jpql += " AND p.deleted = false ";
            } else if ("deleted".equals(statusFilter)) {
                jpql += " AND p.deleted = true ";
            }
            
            if ("price_asc".equals(sortOption)) {
                jpql += " ORDER BY p.price ASC ";
            } else if ("price_desc".equals(sortOption)) {
                jpql += " ORDER BY p.price DESC ";
            } else if ("duration_asc".equals(sortOption)) {
                jpql += " ORDER BY p.durationMonths ASC ";
            } else if ("duration_desc".equals(sortOption)) {
                jpql += " ORDER BY p.durationMonths DESC ";
            } else {
                jpql += " ORDER BY p.packageId DESC ";
            }

            TypedQuery<SubscriptionPackage> query = em.createQuery(jpql, SubscriptionPackage.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.getResultList();
        });
    }

    public long getTotalPackagesCount(String statusFilter) {
        return JpaHelper.query(em -> {
            String jpql = "SELECT COUNT(p) FROM SubscriptionPackage p WHERE 1=1 ";
            
            if ("active".equals(statusFilter)) {
                jpql += " AND p.deleted = false ";
            } else if ("deleted".equals(statusFilter)) {
                jpql += " AND p.deleted = true ";
            }

            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            return query.getSingleResult();
        });
    }

    public List<SubscriptionPackage> getAllPackages() {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT p FROM SubscriptionPackage p", SubscriptionPackage.class).getResultList()
        );
    }
    
    public SubscriptionPackage getPackageById(int id) {
        return JpaHelper.query(em -> em.find(SubscriptionPackage.class, id));
    }

    public void addPackage(SubscriptionPackage pkg) {
        JpaHelper.execute(em -> em.persist(pkg));
    }
    
    public void createPackage(SubscriptionPackage pkg) {
        addPackage(pkg);
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
    
    public void deletePackage(int id) {
        softDeletePackage(id);
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

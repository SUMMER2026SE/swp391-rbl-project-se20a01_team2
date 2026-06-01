package services;

import dao.SubscriptionPackageDAO;
import model.SubscriptionPackage;

import java.util.List;

public class SubscriptionService {
    
    private final SubscriptionPackageDAO dao;

    public SubscriptionService() {
        this.dao = new SubscriptionPackageDAO();
    }

    public List<SubscriptionPackage> getActivePackagesPaginated(int offset, int limit) {
        return dao.getActivePackagesPaginated(offset, limit);
    }

    public long getTotalActivePackagesCount() {
        return dao.getTotalActivePackagesCount();
    }

    public List<SubscriptionPackage> getPackagesPaginated(int offset, int limit, String statusFilter, String sortOption) {
        return dao.getPackagesPaginated(offset, limit, statusFilter, sortOption);
    }

    public long getTotalPackagesCount(String statusFilter) {
        return dao.getTotalPackagesCount(statusFilter);
    }

    public SubscriptionPackage getPackageById(int id) {
        return dao.getPackageById(id);
    }

    public void addPackage(SubscriptionPackage pkg) {
        dao.addPackage(pkg);
    }

    public void updatePackage(SubscriptionPackage pkg) {
        dao.updatePackage(pkg);
    }

    public void softDeletePackage(int id) {
        dao.softDeletePackage(id);
    }

    public void restorePackage(int id) {
        dao.restorePackage(id);
    }
}

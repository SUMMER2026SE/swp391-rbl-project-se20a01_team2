package services;

import dao.SubscriptionPackageDAO;
import dao.UserSubscriptionDAO;
import model.SubscriptionPackage;
import model.UserSubscription;
import model.Transaction;
import java.util.Calendar;
import java.util.Date;

import java.util.List;

public class SubscriptionService {
    
    private final SubscriptionPackageDAO dao;
    private final UserSubscriptionDAO userSubDao;

    public SubscriptionService() {
        this.dao = new SubscriptionPackageDAO();
        this.userSubDao = new UserSubscriptionDAO();
    }

    public List<SubscriptionPackage> getActivePackagesPaginated(int offset, int limit) {
        return dao.getActivePackagesPaginated(offset, limit);
    }

    public UserSubscription getActiveSubscriptionByUserId(int userId) {
        return userSubDao.getActiveSubscriptionByUserId(userId);
    }

    public boolean hasAnySubscription(int userId) {
        return userSubDao.hasAnySubscription(userId);
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

    public void processSuccessfulTransaction(Transaction t) {
        if (t == null || t.getSubscriptionPackage() == null) return;
        
        int userId = t.getUserId();
        SubscriptionPackage pkg = t.getSubscriptionPackage();
        int months = pkg.getDurationMonths();
        
        UserSubscription existingSub = userSubDao.getActiveSubscriptionByUserId(userId);
        if (existingSub != null) {
            // Extend existing subscription
            Calendar cal = Calendar.getInstance();
            cal.setTime(existingSub.getEndDate());
            cal.add(Calendar.MONTH, months);
            existingSub.setEndDate(cal.getTime());
            userSubDao.update(existingSub);
        } else {
            // Create new subscription
            UserSubscription newSub = new UserSubscription();
            newSub.setUserId(userId);
            newSub.setSubscriptionPackage(pkg);
            newSub.setStartDate(new Date());
            
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.MONTH, months);
            newSub.setEndDate(cal.getTime());
            newSub.setStatus("Active");
            
            userSubDao.create(newSub);
        }
    }
}

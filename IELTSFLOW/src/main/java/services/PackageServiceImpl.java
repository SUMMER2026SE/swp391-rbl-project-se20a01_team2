package services;

import dao.SubscriptionPackageDAO;
import model.SubscriptionPackage;
import services.PackageService;

import java.util.List;

public class PackageServiceImpl implements PackageService {
    private SubscriptionPackageDAO packageDAO;

    public PackageServiceImpl() {
        this.packageDAO = new SubscriptionPackageDAO();
    }

    @Override
    public SubscriptionPackage getPackageById(int id) {
        return packageDAO.getPackageById(id);
    }

    @Override
    public void deletePackage(int id) {
        packageDAO.deletePackage(id);
    }

    @Override
    public void restorePackage(int id) {
        packageDAO.restorePackage(id);
    }

    @Override
    public List<SubscriptionPackage> getAllPackages() {
        return packageDAO.getAllPackages();
    }

    @Override
    public void createPackage(SubscriptionPackage pkg) {
        packageDAO.createPackage(pkg);
    }

    @Override
    public void updatePackage(SubscriptionPackage pkg) {
        packageDAO.updatePackage(pkg);
    }
}

package services;

import model.SubscriptionPackage;
import java.util.List;

public interface PackageService {
    SubscriptionPackage getPackageById(int id);
    void deletePackage(int id);
    void restorePackage(int id);
    List<SubscriptionPackage> getAllPackages();
    void createPackage(SubscriptionPackage pkg);
    void updatePackage(SubscriptionPackage pkg);
}

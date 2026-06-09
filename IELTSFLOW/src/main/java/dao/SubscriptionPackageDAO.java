/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ntpho
 */
import model.SubscriptionPackage;
import util.JpaHelper;
import java.util.List;

public class SubscriptionPackageDAO {
    
    // Lấy toàn bộ danh sách gói
    public List<SubscriptionPackage> getAllPackages() {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT p FROM SubscriptionPackage p", SubscriptionPackage.class).getResultList()
        );
    }
    
    // Lấy một gói theo ID
    public SubscriptionPackage getPackageById(int id) {
        return JpaHelper.query(em -> em.find(SubscriptionPackage.class, id));
    }
    
    // Tạo gói mới
    public void createPackage(SubscriptionPackage pkg) {
        JpaHelper.execute(em -> em.persist(pkg));
    }
    
    // Cập nhật thông tin gói
    public void updatePackage(SubscriptionPackage pkg) {
        JpaHelper.execute(em -> em.merge(pkg));
    }
    
    // Xóa mềm gói
    public void deletePackage(int id) {
        JpaHelper.execute(em -> {
            SubscriptionPackage pkg = em.find(SubscriptionPackage.class, id);
            if (pkg != null) {
                pkg.setDeleted(true);
                em.merge(pkg);
            }
        });
    }
    
    // Khôi phục gói (ẩn -> hiện)
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
package dao;

import model.UserSubscription;
import util.JpaHelper;
import java.util.List;

public class UserSubscriptionDAO {
    
    public void create(UserSubscription subscription) {
        JpaHelper.execute(em -> em.persist(subscription));
    }
    
    public void update(UserSubscription subscription) {
        JpaHelper.execute(em -> em.merge(subscription));
    }
    
    public UserSubscription getActiveSubscriptionByUserId(int userId) {
        return JpaHelper.query(em -> {
            List<UserSubscription> list = em.createQuery(
                "SELECT u FROM UserSubscription u WHERE u.userId = :uid AND u.status = 'Active' AND u.endDate > CURRENT_TIMESTAMP ORDER BY u.endDate DESC", 
                UserSubscription.class)
                .setParameter("uid", userId)
                .setMaxResults(1)
                .getResultList();
            return list.isEmpty() ? null : list.get(0);
        });
    }
}

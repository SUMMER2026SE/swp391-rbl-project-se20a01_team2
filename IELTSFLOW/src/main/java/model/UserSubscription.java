package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserSubscriptions")
public class UserSubscription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserSubID")
    private int userSubId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "PackageID", nullable = false)
    private SubscriptionPackage subscriptionPackage;

    @Column(name = "StartDate", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;

    @Column(name = "EndDate", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;

    @Column(name = "Status", length = 50)
    private String status = "Active";

    public UserSubscription() {
    }

    public int getUserSubId() { return userSubId; }
    public void setUserSubId(int userSubId) { this.userSubId = userSubId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public SubscriptionPackage getSubscriptionPackage() { return subscriptionPackage; }
    public void setSubscriptionPackage(SubscriptionPackage subscriptionPackage) { this.subscriptionPackage = subscriptionPackage; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

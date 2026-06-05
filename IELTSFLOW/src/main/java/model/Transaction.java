/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ntpho
 */
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "Transactions")
public class Transaction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TransactionID")
    private int transactionId;

    // Ánh xạ khóa ngoại UserID dạng cột Integer để độc lập với class User
    @Column(name = "UserID", nullable = false)
    private int userId;

    // Khóa ngoại trỏ sang gói SubscriptionPackage
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "PackageID", nullable = false)
    private SubscriptionPackage subscriptionPackage;

    @Column(name = "Amount", nullable = false, precision = 18, scale = 2)
    private BigDecimal amount;

    @Column(name = "PaymentMethod", length = 50)
    private String paymentMethod;

    @Column(name = "GatewayTransactionID", length = 100)
    private String gatewayTransactionId;

    @Column(name = "GatewayPayload", columnDefinition = "NVARCHAR(MAX)")
    private String gatewayPayload;

    @Column(name = "Status", length = 50)
    private String status = "Pending";

    @Column(name = "PaymentDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentDate;

    // Cột này Database tự động set (DEFAULT GETDATE()) nên không cần insert/update từ JPA
    @Column(name = "CreatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    // Constructors
    public Transaction() {
    }

    // Getters and Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public SubscriptionPackage getSubscriptionPackage() { return subscriptionPackage; }
    public void setSubscriptionPackage(SubscriptionPackage subscriptionPackage) { this.subscriptionPackage = subscriptionPackage; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getGatewayTransactionId() { return gatewayTransactionId; }
    public void setGatewayTransactionId(String gatewayTransactionId) { this.gatewayTransactionId = gatewayTransactionId; }

    public String getGatewayPayload() { return gatewayPayload; }
    public void setGatewayPayload(String gatewayPayload) { this.gatewayPayload = gatewayPayload; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public Date getCreatedAt() { return createdAt; }
}
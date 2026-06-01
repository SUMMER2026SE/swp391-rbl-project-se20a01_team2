package model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "SubscriptionPackages")
public class SubscriptionPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PackageID")
    private int packageId;

    @Column(name = "Name", nullable = false, length = 100)
    private String name;

    @Column(name = "DurationMonths", nullable = false)
    private int durationMonths;

    @Column(name = "Price", nullable = false, precision = 18, scale = 2)
    private BigDecimal price;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "Deleted")
    private boolean deleted = false;

    public SubscriptionPackage() {
    }

    public SubscriptionPackage(String name, int durationMonths, BigDecimal price, String description) {
        this.name = name;
        this.durationMonths = durationMonths;
        this.price = price;
        this.description = description;
        this.deleted = false;
    }

    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDurationMonths() {
        return durationMonths;
    }

    public void setDurationMonths(int durationMonths) {
        this.durationMonths = durationMonths;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }
}

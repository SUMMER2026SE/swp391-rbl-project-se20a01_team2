package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Pathways")
public class Pathway {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PathwayID")
    private int pathwayId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @Column(name = "PlacementTestID")
    private Integer placementTestId;

    @Column(name = "TargetBand", nullable = false)
    private BigDecimal targetBand;

    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;

    public Pathway() {}

    public int getPathwayId() { return pathwayId; }
    public void setPathwayId(int pathwayId) { this.pathwayId = pathwayId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public Integer getPlacementTestId() { return placementTestId; }
    public void setPlacementTestId(Integer placementTestId) { this.placementTestId = placementTestId; }
    public BigDecimal getTargetBand() { return targetBand; }
    public void setTargetBand(BigDecimal targetBand) { this.targetBand = targetBand; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

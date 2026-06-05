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
import java.util.Date;

@Entity
@Table(name = "SystemLogs")
public class SystemLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "LogID")
    private int logId;

    @Column(name = "UserID")
    private Integer userId;

    @Column(name = "Action", nullable = false, length = 100)
    private String action;

    @Column(name = "Entity", length = 50)
    private String entity;

    @Column(name = "Details", columnDefinition = "NVARCHAR(MAX)")
    private String details;

    @Column(name = "CreatedAt", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    // Constructors
    public SystemLog() {
    }

    public SystemLog(Integer userId, String action, String entity, String details) {
        this.userId = userId;
        this.action = action;
        this.entity = entity;
        this.details = details;
    }

    // Getters and Setters
    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getEntity() { return entity; }
    public void setEntity(String entity) { this.entity = entity; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public Date getCreatedAt() { return createdAt; }
}
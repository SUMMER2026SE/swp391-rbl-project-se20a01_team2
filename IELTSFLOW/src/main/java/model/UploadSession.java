package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.sql.Timestamp;

@Entity
@Table(name = "upload_sessions")
public class UploadSession {

    @Id
    @Column(name = "upload_id")
    private String uploadId;

    @Column(name = "file_name")
    private String fileName;

    @Column(name = "total_chunks")
    private int totalChunks;

    @Column(name = "created_at")
    private Timestamp createdAt;

    public UploadSession() {
    }

    public UploadSession(String uploadId, String fileName, int totalChunks) {
        this.uploadId = uploadId;
        this.fileName = fileName;
        this.totalChunks = totalChunks;
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = new Timestamp(System.currentTimeMillis());
        }
    }

    public String getUploadId() {
        return uploadId;
    }

    public void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public int getTotalChunks() {
        return totalChunks;
    }

    public void setTotalChunks(int totalChunks) {
        this.totalChunks = totalChunks;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.sql.Timestamp;

@Entity
@Table(name = "UploadedFiles")
public class UploadedFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FileID")
    private int fileId;

    @Column(name = "OriginalName")
    private String originalName;

    @Column(name = "SavedPath")
    private String savedPath;

    @Column(name = "FileType")
    private String fileType;

    @Column(name = "UploadedBy")
    private int uploadedBy;

    @Column(name = "UploadedAt")
    private Timestamp uploadedAt;

    public UploadedFile() {
    }

    public UploadedFile(String originalName, String savedPath, String fileType, int uploadedBy) {
        this.originalName = originalName;
        this.savedPath = savedPath;
        this.fileType = fileType;
        this.uploadedBy = uploadedBy;
    }

    @PrePersist
    protected void onCreate() {
        if (uploadedAt == null) {
            uploadedAt = new Timestamp(System.currentTimeMillis());
        }
    }

    public int getFileId() {
        return fileId;
    }

    public void setFileId(int fileId) {
        this.fileId = fileId;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public String getSavedPath() {
        return savedPath;
    }

    public void setSavedPath(String savedPath) {
        this.savedPath = savedPath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public int getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(int uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}

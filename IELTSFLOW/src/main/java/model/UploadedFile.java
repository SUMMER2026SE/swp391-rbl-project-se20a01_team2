package model;

import java.sql.Timestamp;

public class UploadedFile {
    private int fileId;
    private String originalName;
    private String savedPath;
    private String fileType;
    private int uploadedBy;
    private Timestamp uploadedAt;

    public UploadedFile() {
    }

    public UploadedFile(String originalName, String savedPath, String fileType, int uploadedBy) {
        this.originalName = originalName;
        this.savedPath = savedPath;
        this.fileType = fileType;
        this.uploadedBy = uploadedBy;
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

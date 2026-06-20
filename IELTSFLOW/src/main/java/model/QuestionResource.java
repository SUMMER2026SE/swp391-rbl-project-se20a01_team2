package model;

import jakarta.persistence.*;

@Entity
@Table(name = "QuestionResource")
public class QuestionResource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ResourceID")
    private int resourceId;

    @Column(name = "ResourceText", columnDefinition = "NVARCHAR(MAX)")
    private String resourceText;

    @Column(name = "ResourceAudioURL")
    private String resourceAudioUrl;

    @Column(name = "ResourceImageURL")
    private String resourceImageUrl;

    @Column(name = "Type", nullable = false)
    private String type; // Passage, Audio

    @Column(name = "CreatedBy")
    private Integer createdBy;

    @Column(name = "Deleted")
    private boolean deleted = false;

    public QuestionResource() {}

    public int getResourceId() { return resourceId; }
    public void setResourceId(int resourceId) { this.resourceId = resourceId; }
    public String getResourceText() { return resourceText; }
    public void setResourceText(String resourceText) { this.resourceText = resourceText; }
    public String getResourceAudioUrl() { return resourceAudioUrl; }
    public void setResourceAudioUrl(String resourceAudioUrl) { this.resourceAudioUrl = resourceAudioUrl; }
    public String getResourceImageUrl() { return resourceImageUrl; }
    public void setResourceImageUrl(String resourceImageUrl) { this.resourceImageUrl = resourceImageUrl; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public boolean isDeleted() { return deleted; }
    public void setDeleted(boolean deleted) { this.deleted = deleted; }
}

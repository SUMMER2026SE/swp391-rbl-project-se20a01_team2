package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Tags")
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TagID")
    private int tagId;

    @Column(name = "Name", nullable = false)
    private String name;

    @Column(name = "Type")
    private String type; // Topic, Grammar, Vocabulary...

    @Column(name = "Deleted")
    private boolean deleted;

    public Tag() {}

    public int getTagId() { return tagId; }
    public void setTagId(int tagId) { this.tagId = tagId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public boolean isDeleted() { return deleted; }
    public void setDeleted(boolean deleted) { this.deleted = deleted; }
}

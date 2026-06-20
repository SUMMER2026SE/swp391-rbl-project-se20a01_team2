package services;

import dao.TagDAO;
import model.Tag;
import java.util.List;

public class TagService {

    private final TagDAO tagDAO = new TagDAO();

    public List<Tag> getAllTags() {
        return tagDAO.findAll();
    }

    public Tag getTagById(int id) {
        return tagDAO.findById(id);
    }

    public void createTag(Tag tag) throws Exception {
        validate(tag);
        if (tagDAO.findByNameAndType(tag.getName(), tag.getType(), null) != null)
            throw new Exception("Tag \"" + tag.getName() + "\" với loại này đã tồn tại");
        tag.setDeleted(false);
        tagDAO.save(tag);
    }

    public void updateTag(Tag tag) throws Exception {
        Tag existing = tagDAO.findById(tag.getTagId());
        if (existing == null)
            throw new Exception("Không tìm thấy tag #" + tag.getTagId());
        validate(tag);
        if (tagDAO.findByNameAndType(tag.getName(), tag.getType(), tag.getTagId()) != null)
            throw new Exception("Tag \"" + tag.getName() + "\" với loại này đã tồn tại");

        existing.setName(tag.getName());
        existing.setType(tag.getType());
        tagDAO.update(existing);
    }

    public void deleteTag(int id) throws Exception {
        Tag existing = tagDAO.findById(id);
        if (existing == null)
            throw new Exception("Không tìm thấy tag #" + id);
        tagDAO.softDelete(id);
    }

    private void validate(Tag tag) throws Exception {
        if (tag.getName() == null || tag.getName().isBlank())
            throw new Exception("Tên tag không được để trống");
    }
}

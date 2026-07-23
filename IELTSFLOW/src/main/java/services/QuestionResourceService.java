package services;

import dao.QuestionResourceDAO;
import model.QuestionResource;
import java.util.List;

public class QuestionResourceService {

    private final QuestionResourceDAO resourceDAO = new QuestionResourceDAO();

    public List<QuestionResource> getAllResources() {
        return resourceDAO.findAll();
    }

    public util.PaginatedList<QuestionResource> searchResources(String keyword, String type, String sortOrder, int page, int pageSize) {
        return resourceDAO.searchPaginated(keyword, type, sortOrder, page, pageSize);
    }

    public QuestionResource getResourceById(int id) {
        return resourceDAO.findById(id);
    }

    public void createResource(QuestionResource resource) throws Exception {
        if (resource.getType() == null || resource.getType().trim().isEmpty()) {
            throw new Exception("Loại tài nguyên không được để trống.");
        }
        resourceDAO.save(resource);
    }

    public void updateResource(QuestionResource resource) throws Exception {
        if (resource.getType() == null || resource.getType().trim().isEmpty()) {
            throw new Exception("Loại tài nguyên không được để trống.");
        }
        QuestionResource existing = resourceDAO.findById(resource.getResourceId());
        if (existing == null) {
            throw new Exception("Không tìm thấy tài nguyên để cập nhật.");
        }
        
        existing.setType(resource.getType());
        existing.setResourceName(resource.getResourceName());
        existing.setResourceText(resource.getResourceText());
        existing.setResourceAudioUrl(resource.getResourceAudioUrl());
        existing.setResourceImageUrl(resource.getResourceImageUrl());
        
        resourceDAO.update(existing);
    }

    public void deleteResource(int id) {
        resourceDAO.softDelete(id);
    }
}

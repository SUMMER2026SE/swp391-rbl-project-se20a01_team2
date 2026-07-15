package dao;

import model.QuestionResource;
import util.JpaHelper;
import java.util.List;

public class QuestionResourceDAO {

    public List<QuestionResource> findAll() {
        return JpaHelper.query(em ->
                em.createQuery("SELECT r FROM QuestionResource r WHERE r.deleted = false ORDER BY r.resourceId DESC", QuestionResource.class)
                        .getResultList()
        );
    }

    public util.PaginatedList<QuestionResource> searchPaginated(String keyword, String type, String sortOrder, int page, int pageSize) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasType = type != null && !type.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT r FROM QuestionResource r WHERE r.deleted = false");
        StringBuilder countStr = new StringBuilder("SELECT COUNT(r) FROM QuestionResource r WHERE r.deleted = false");
        
        StringBuilder conditions = new StringBuilder();
        if (hasType) conditions.append(" AND r.type = :type");
        if (hasKeyword) {
            conditions.append(" AND (LOWER(r.resourceName) LIKE :kw OR LOWER(r.resourceText) LIKE :kw)");
        }
        
        queryStr.append(conditions);
        countStr.append(conditions);
        
        if ("oldest".equalsIgnoreCase(sortOrder)) {
            queryStr.append(" ORDER BY r.resourceId ASC");
        } else {
            queryStr.append(" ORDER BY r.resourceId DESC");
        }

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<Long> countQuery = em.createQuery(countStr.toString(), Long.class);
            if (hasType) countQuery.setParameter("type", type);
            if (hasKeyword) countQuery.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            long totalItems = countQuery.getSingleResult();

            jakarta.persistence.TypedQuery<QuestionResource> query = em.createQuery(queryStr.toString(), QuestionResource.class);
            if (hasType) query.setParameter("type", type);
            if (hasKeyword) query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            
            List<QuestionResource> items = query.getResultList();
            return new util.PaginatedList<>(items, page, totalItems, pageSize);
        });
    }

    public QuestionResource findById(int id) {
        return JpaHelper.query(em -> {
            QuestionResource r = em.find(QuestionResource.class, id);
            return (r != null && !r.isDeleted()) ? r : null;
        });
    }

    public void save(QuestionResource resource) {
        JpaHelper.execute(em -> em.persist(resource));
    }

    public void update(QuestionResource resource) {
        JpaHelper.execute(em -> em.merge(resource));
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            QuestionResource r = em.find(QuestionResource.class, id);
            if (r != null) {
                r.setDeleted(true);
                em.merge(r);
            }
        });
    }
}

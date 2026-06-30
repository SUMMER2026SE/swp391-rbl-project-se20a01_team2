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

    public List<QuestionResource> search(String keyword, String type) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasType = type != null && !type.trim().isEmpty();

        StringBuilder queryStr = new StringBuilder("SELECT r FROM QuestionResource r WHERE r.deleted = false");
        if (hasType) queryStr.append(" AND r.type = :type");
        if (hasKeyword) {
            queryStr.append(" AND (LOWER(r.resourceName) LIKE :kw OR LOWER(r.resourceText) LIKE :kw)");
        }
        queryStr.append(" ORDER BY r.resourceId DESC");

        return JpaHelper.query(em -> {
            jakarta.persistence.TypedQuery<QuestionResource> query = em.createQuery(queryStr.toString(), QuestionResource.class);
            if (hasType) query.setParameter("type", type);
            if (hasKeyword) query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            return query.getResultList();
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

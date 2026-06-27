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

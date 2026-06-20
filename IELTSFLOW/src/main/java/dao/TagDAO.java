package dao;

import model.Tag;
import util.JpaHelper;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class TagDAO {

    public List<Tag> findAll() {
        return JpaHelper.query(em ->
                em.createQuery("SELECT t FROM Tag t WHERE t.deleted = false ORDER BY t.type, t.name", Tag.class)
                        .getResultList()
        );
    }

    public Tag findById(int id) {
        return JpaHelper.query(em -> {
            Tag t = em.find(Tag.class, id);
            return (t != null && !t.isDeleted()) ? t : null;
        });
    }

    /**
     * Looks up a non-deleted tag with the same name and type.
     * Pass excludeId = the tag's own id during update so it doesn't flag itself.
     */
    public Tag findByNameAndType(String name, String type, Integer excludeId) {
        boolean hasType = type != null && !type.isBlank();

        StringBuilder jpql = new StringBuilder(
                "SELECT t FROM Tag t WHERE t.deleted = false AND LOWER(t.name) = LOWER(:name)");
        jpql.append(hasType ? " AND t.type = :type" : " AND t.type IS NULL");
        if (excludeId != null) jpql.append(" AND t.tagId <> :excludeId");
        String finalJpql = jpql.toString();

        return JpaHelper.query(em -> {
            TypedQuery<Tag> q = em.createQuery(finalJpql, Tag.class).setParameter("name", name);
            if (hasType) q.setParameter("type", type);
            if (excludeId != null) q.setParameter("excludeId", excludeId);
            List<Tag> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        });
    }

    public void save(Tag tag) {
        JpaHelper.execute(em -> em.persist(tag));
    }

    public void update(Tag tag) {
        JpaHelper.execute(em -> em.merge(tag));
    }

    public void softDelete(int id) {
        JpaHelper.execute(em -> {
            Tag t = em.find(Tag.class, id);
            if (t != null) { t.setDeleted(true); em.merge(t); }
        });
    }
}

package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.CandidateTarget;
import util.JpaHelper;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

/**
 * DAO xử lý dữ liệu mục tiêu IELTS của học viên (CandidateTargets)
 */
public class CandidateTargetDAO {

    /**
     * Lấy mục tiêu đang active của user
     */
    public Optional<CandidateTarget> findActiveByUserId(int userId) {
        return JpaHelper.query(em -> findActiveByUserIdWithEm(em, userId));
    }

    /**
     * Lưu hoặc cập nhật mục tiêu của user.
     * Nếu đã có bản ghi active thì update, chưa có thì insert mới.
     */
    public void saveOrUpdate(int userId, BigDecimal currentBand, BigDecimal targetBand, LocalDate examDate) {
        JpaHelper.execute(em -> {
            Optional<CandidateTarget> existing = findActiveByUserIdWithEm(em, userId);
            if (existing.isPresent()) {
                CandidateTarget target = existing.get();
                target.setCurrentBand(currentBand);
                target.setTargetBand(targetBand);
                target.setExamDate(examDate);
                em.merge(target);
            } else {
                CandidateTarget target = new CandidateTarget(userId, targetBand, currentBand, examDate);
                em.persist(target);
            }
        });
    }

    /**
     * Cập nhật chỉ currentBand (gọi sau khi user hoàn thành bài test)
     */
    public void updateCurrentBand(int userId, BigDecimal newBand) {
        JpaHelper.execute(em -> {
            Optional<CandidateTarget> existing = findActiveByUserIdWithEm(em, userId);
            if (existing.isPresent()) {
                CandidateTarget t = existing.get();
                t.setCurrentBand(newBand);
                em.merge(t);
            } else {
                CandidateTarget target = new CandidateTarget(userId, newBand, newBand, null);
                em.persist(target);
            }
        });
    }

    private Optional<CandidateTarget> findActiveByUserIdWithEm(EntityManager em, int userId) {
        try {
            TypedQuery<CandidateTarget> query = em.createQuery(
                "SELECT t FROM CandidateTarget t WHERE t.userId = :uid AND t.isActive = true",
                CandidateTarget.class);
            query.setParameter("uid", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
}

package dao;

import model.Ticket;
import util.JpaHelper;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * DAO xử lý truy vấn ticket hỗ trợ (Ticket)
 */
public class TicketDAO {

    /**
     * Lấy tất cả ticket của một user, mới nhất trước
     */
    public List<Ticket> findByUserId(int userId) {
        return JpaHelper.query(em -> {
            List<Ticket> tickets = em.createQuery(
                "SELECT t FROM Ticket t WHERE t.user.userId = :userId ORDER BY t.createdAt DESC",
                Ticket.class)
              .setParameter("userId", userId)
              .getResultList();
            for (Ticket t : tickets) {
                t.getReplies().size(); // force init
            }
            return tickets;
        });
    }

    /**
     * Lấy tất cả ticket (Admin)
     */
    public List<Ticket> findAll() {
        return JpaHelper.query(em -> {
            List<Ticket> tickets = em.createQuery("SELECT t FROM Ticket t ORDER BY t.createdAt DESC", Ticket.class)
              .getResultList();
            for (Ticket t : tickets) {
                t.getReplies().size(); // force init
            }
            return tickets;
        });
    }

    /**
     * Tìm ticket theo ID
     */
    public Optional<Ticket> findById(int ticketId) {
        return JpaHelper.query(em -> {
            Ticket t = em.find(Ticket.class, ticketId);
            if (t != null) {
                t.getReplies().size(); // force init
                t.getReplies().sort((r1, r2) -> r1.getCreatedAt().compareTo(r2.getCreatedAt()));
            }
            return Optional.ofNullable(t);
        });
    }

    /**
     * Tạo ticket mới
     */
    public int create(Ticket ticket) {
        JpaHelper.execute(em -> em.persist(ticket));
        return ticket.getTicketId();
    }

    /**
     * Cập nhật trạng thái ticket
     */
    public boolean updateStatus(int ticketId, String status) {
        try {
            JpaHelper.execute(em -> {
                Ticket ticket = em.find(Ticket.class, ticketId);
                if (ticket != null) ticket.setStatus(status);
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Thêm phản hồi vào ticket
     */
    public boolean addReply(int ticketId, model.User sender, String message, String newStatus) {
        try {
            JpaHelper.execute(em -> {
                Ticket ticket = em.find(Ticket.class, ticketId);
                if (ticket != null) {
                    model.TicketReply reply = new model.TicketReply(ticket, sender, message);
                    em.persist(reply);
                    if (newStatus != null) {
                        ticket.setStatus(newStatus);
                    }
                }
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đếm số ticket theo trạng thái
     */
    public long countByStatus(String status) {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(t) FROM Ticket t WHERE t.status = :status", Long.class)
              .setParameter("status", status)
              .getSingleResult()
        );
    }
}

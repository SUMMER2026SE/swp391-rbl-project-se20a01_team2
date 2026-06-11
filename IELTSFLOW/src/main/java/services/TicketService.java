package services;

import dao.TicketDAO;
import dao.UserDAO;
import model.Ticket;
import model.User;

import java.util.List;

/**
 * Service xử lý business logic cho ticket hỗ trợ (Support Ticket)
 */
public class TicketService {

    private final TicketDAO ticketDAO;
    private final UserDAO userDAO;

    public TicketService() {
        this.ticketDAO = new TicketDAO();
        this.userDAO = new UserDAO();
    }

    /**
     * Lấy danh sách ticket của user
     */
    public List<Ticket> getUserTickets(int userId) {
        return ticketDAO.findByUserId(userId);
    }

    /**
     * Lấy tất cả ticket (Admin)
     */
    public List<Ticket> getAllTickets() {
        return ticketDAO.findAll();
    }

    /**
     * Lấy chi tiết một ticket
     */
    public Ticket getTicketById(int ticketId, int userId) throws Exception {
        Ticket ticket = ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));

        // User chỉ xem được ticket của mình (Admin quyền xem tất cả - userId=-1)
        if (userId != -1 && ticket.getUser().getUserId() != userId) {
            throw new Exception("Không có quyền truy cập ticket này");
        }
        return ticket;
    }

    /**
     * Tạo ticket mới
     */
    public Ticket createTicket(int userId, String subject, String content) throws Exception {
        if (subject == null || subject.trim().isEmpty()) {
            throw new Exception("Tiêu đề không được để trống");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new Exception("Nội dung không được để trống");
        }

        User user = userDAO.findById(userId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));

        Ticket ticket = new Ticket(user, subject.trim(), content.trim());
        ticketDAO.create(ticket);
        return ticket;
    }

    /**
     * Admin trả lời ticket
     */
    public void replyTicket(int ticketId, String reply) throws Exception {
        if (reply == null || reply.trim().isEmpty()) {
            throw new Exception("Nội dung phản hồi không được để trống");
        }
        ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));
        ticketDAO.reply(ticketId, reply.trim());
    }

    /**
     * Đóng ticket
     */
    public void closeTicket(int ticketId, int userId) throws Exception {
        Ticket ticket = ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));

        if (ticket.getUser().getUserId() != userId) {
            throw new Exception("Không có quyền đóng ticket này");
        }

        ticketDAO.updateStatus(ticketId, "Closed");
    }
}

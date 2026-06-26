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
     * Lấy danh sách ticket cho Mentor
     */
    public List<Ticket> getTicketsForMentor(int mentorId) {
        return ticketDAO.findTicketsForMentor(mentorId);
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
        return createTicket(userId, subject, content, null);
    }

    public Ticket createTicket(int userId, String subject, String content, Integer assignedMentorId) throws Exception {
        if (subject == null || subject.trim().isEmpty()) {
            throw new Exception("Tiêu đề không được để trống");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new Exception("Nội dung không được để trống");
        }

        User user = userDAO.findById(userId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));

        Ticket ticket = new Ticket(user, subject.trim());
        if (assignedMentorId != null) {
            User mentor = userDAO.findById(assignedMentorId).orElse(null);
            ticket.setAssignedTo(mentor);
        }

        int ticketId = ticketDAO.create(ticket);
        ticketDAO.addReply(ticketId, user, content.trim(), "Open");
        
        return ticketDAO.findById(ticketId).orElse(ticket);
    }

    /**
     * Mentor/Admin trả lời ticket
     */
    public void replyTicket(int ticketId, int adminId, String reply) throws Exception {
        if (reply == null || reply.trim().isEmpty()) {
            throw new Exception("Nội dung phản hồi không được để trống");
        }
        User admin = userDAO.findById(adminId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng admin/mentor"));
        Ticket ticket = ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));
            
        if ("Closed".equals(ticket.getStatus())) {
            throw new Exception("Không thể phản hồi vì ticket đã đóng");
        }

        // Tự động claim ticket nếu chưa ai nhận
        if (ticket.getAssignedTo() == null && (admin.getRoleId() == 2 || admin.getRoleId() == 1)) {
            ticketDAO.assignTicket(ticketId, adminId);
        } else if (ticket.getAssignedTo() != null && ticket.getAssignedTo().getUserId() != adminId && admin.getRoleId() != 1) {
            throw new Exception("Ticket này đã được nhận bởi Mentor khác.");
        }
            
        ticketDAO.addReply(ticketId, admin, reply.trim(), "Resolved");
    }

    /**
     * Mentor claim ticket (nhận hỗ trợ)
     */
    public void claimTicket(int ticketId, int mentorId) throws Exception {
        Ticket ticket = ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));
        if (ticket.getAssignedTo() != null && ticket.getAssignedTo().getUserId() != mentorId) {
            throw new Exception("Ticket này đã được gán cho Mentor khác.");
        }
        ticketDAO.assignTicket(ticketId, mentorId);
    }

    /**
     * User (Candidate) trả lời ticket
     */
    public void candidateReply(int ticketId, int userId, String reply) throws Exception {
        if (reply == null || reply.trim().isEmpty()) {
            throw new Exception("Nội dung phản hồi không được để trống");
        }
        User user = userDAO.findById(userId)
            .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));
        Ticket ticket = ticketDAO.findById(ticketId)
            .orElseThrow(() -> new Exception("Không tìm thấy ticket #" + ticketId));
            
        if (ticket.getUser().getUserId() != userId) {
            throw new Exception("Không có quyền phản hồi ticket này");
        }
        
        if ("Closed".equals(ticket.getStatus())) {
            throw new Exception("Không thể phản hồi vì ticket đã đóng");
        }
        
        ticketDAO.addReply(ticketId, user, reply.trim(), "Open");
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

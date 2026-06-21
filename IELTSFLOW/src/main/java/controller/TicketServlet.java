package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Ticket;
import services.TicketService;

import java.io.IOException;
import java.util.List;

/**
 * Servlet quản lý ticket hỗ trợ của người dùng.
 * URL: /tickets
 * - GET                 → Hiển thị danh sách ticket
 * - GET ?id=X           → Xem chi tiết một ticket
 * - POST action=create  → Tạo ticket mới
 * - POST action=close   → Đóng ticket
 */
@WebServlet(name = "TicketServlet", urlPatterns = {"/candidate/tickets"})
public class TicketServlet extends HttpServlet {

    private TicketService ticketService;

    @Override
    public void init() throws ServletException {
        ticketService = new TicketService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String ticketIdStr = req.getParameter("id");
        
        try {
            int roleId = session.getAttribute("roleId") != null ? (int) session.getAttribute("roleId") : 3;
            
            if (ticketIdStr != null && !ticketIdStr.isBlank()) {
                // Xem chi tiết một ticket
                int ticketId = Integer.parseInt(ticketIdStr);
                int queryUserId = roleId == 2 ? -1 : userId; // Mentor bypasses owner check
                Ticket ticket = ticketService.getTicketById(ticketId, queryUserId);
                req.setAttribute("ticket", ticket);
                req.getRequestDispatcher("/jsp/candidate/ticket-detail.jsp").forward(req, resp);
            } else {
                // Danh sách ticket
                List<Ticket> tickets = roleId == 2 ? ticketService.getAllTickets() : ticketService.getUserTickets(userId);
                req.setAttribute("tickets", tickets);
                req.getRequestDispatcher("/jsp/candidate/tickets.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/candidate/tickets.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            
        // Đảm bảo nhận dữ liệu tiếng Việt có dấu từ form một cách chính xác
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int roleId = session.getAttribute("roleId") != null ? (int) session.getAttribute("roleId") : 3;
        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                String subject = req.getParameter("subject");
                String content = req.getParameter("content");
                Ticket ticket = ticketService.createTicket(userId, subject, content);
                
                // Đã sửa lại chuỗi thông báo tiếng Việt trên URL
                resp.sendRedirect(req.getContextPath() + "/candidate/tickets?id=" + ticket.getTicketId() + "&success=" + java.net.URLEncoder.encode("Gửi ticket thành công", "UTF-8"));
            } else if ("close".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                ticketService.closeTicket(ticketId, userId);
                
                // Đã sửa lại chuỗi thông báo tiếng Việt trên URL
                resp.sendRedirect(req.getContextPath() + "/candidate/tickets?id=" + ticketId + "&success=" + java.net.URLEncoder.encode("Đã đóng ticket", "UTF-8"));
            } else if ("reply".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                String replyContent = req.getParameter("replyContent");
                if (roleId == 2) {
                    ticketService.replyTicket(ticketId, userId, replyContent);
                    resp.sendRedirect(req.getContextPath() + "/candidate/tickets?id=" + ticketId + "&success=" + java.net.URLEncoder.encode("Đã gửi phản hồi", "UTF-8"));
                } else {
                    ticketService.candidateReply(ticketId, userId, replyContent);
                    resp.sendRedirect(req.getContextPath() + "/candidate/tickets?id=" + ticketId);
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/candidate/tickets");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            List<Ticket> tickets = roleId == 2 ? ticketService.getAllTickets() : ticketService.getUserTickets(userId);
            req.setAttribute("tickets", tickets);
            req.getRequestDispatcher("/jsp/candidate/tickets.jsp").forward(req, resp);
        }
    }
}

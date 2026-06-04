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
@WebServlet(name = "TicketServlet", urlPatterns = {"/tickets"})
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
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String ticketIdStr = req.getParameter("id");
        
        try {
            if (ticketIdStr != null && !ticketIdStr.isBlank()) {
                // Xem chi tiết một ticket
                int ticketId = Integer.parseInt(ticketIdStr);
                Ticket ticket = ticketService.getTicketById(ticketId, userId);
                req.setAttribute("ticket", ticket);
                req.getRequestDispatcher("/jsp/ticket-detail.jsp").forward(req, resp);
            } else {
                // Danh sách ticket
                List<Ticket> tickets = ticketService.getUserTickets(userId);
                req.setAttribute("tickets", tickets);
                req.getRequestDispatcher("/jsp/tickets.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/tickets.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            
        // Đảm bảo nhận dữ liệu tiếng Việt có dấu từ form một cách chính xác
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                String subject = req.getParameter("subject");
                String content = req.getParameter("content");
                Ticket ticket = ticketService.createTicket(userId, subject, content);
                
                // Đã sửa lại chuỗi thông báo tiếng Việt trên URL
                resp.sendRedirect(req.getContextPath() + "/tickets?id=" + ticket.getTicketId() + "&success=Gửi+ticket+thành+công");
            } else if ("close".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                ticketService.closeTicket(ticketId, userId);
                
                // Đã sửa lại chuỗi thông báo tiếng Việt trên URL
                resp.sendRedirect(req.getContextPath() + "/tickets?success=Đã+đóng+ticket");
            } else {
                resp.sendRedirect(req.getContextPath() + "/tickets");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            List<Ticket> tickets = ticketService.getUserTickets(userId);
            req.setAttribute("tickets", tickets);
            req.getRequestDispatcher("/jsp/tickets.jsp").forward(req, resp);
        }
    }
}
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Ticket;
import services.TicketService;

import java.io.IOException;

@WebServlet("/mentor/tickets/*")
public class MentorTicketServlet extends HttpServlet {

    private final TicketService ticketService = new TicketService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                int mentorId = (int) session.getAttribute("userId");
                req.setAttribute("tickets", ticketService.getTicketsForMentor(mentorId));
                req.getRequestDispatcher("/jsp/mentor/tickets.jsp").forward(req, resp);
            } else {
                int ticketId = Integer.parseInt(pathInfo.substring(1));
                // Lấy ticket với quyền Admin/Mentor (pass userId = -1)
                Ticket ticket = ticketService.getTicketById(ticketId, -1);
                req.setAttribute("ticket", ticket);
                req.getRequestDispatcher("/jsp/mentor/ticket-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ");
            int mentorId = (int) session.getAttribute("userId");
            req.setAttribute("tickets", ticketService.getTicketsForMentor(mentorId));
            req.getRequestDispatcher("/jsp/mentor/tickets.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            int mentorId = (int) session.getAttribute("userId");
            req.setAttribute("tickets", ticketService.getTicketsForMentor(mentorId));
            req.getRequestDispatcher("/jsp/mentor/tickets.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        int mentorId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        try {
            if ("reply".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                String replyContent = req.getParameter("content");
                ticketService.replyTicket(ticketId, mentorId, replyContent);
                resp.sendRedirect(req.getContextPath() + "/mentor/tickets/" + ticketId + "?success=Phản+hồi+thành+công");
            } else if ("claim".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                ticketService.claimTicket(ticketId, mentorId);
                resp.sendRedirect(req.getContextPath() + "/mentor/tickets/" + ticketId + "?success=Đã+nhận+hỗ+trợ+ticket+này");
            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/tickets");
            }

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req)
            throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return false;
        }
        Integer roleId = (Integer) session.getAttribute("roleId");
        if (roleId == null || (roleId != 1 && roleId != 2)) {
            resp.sendRedirect(req.getContextPath() + "/?error=forbidden");
            return false;
        }
        return true;
    }
}

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

/**
 * Servlet for the Candidate Dashboard.
 * URL: /candidate/dashboard
 */
@WebServlet(name = "CandidateDashboardServlet", urlPatterns = {"/candidate/dashboard"})
public class CandidateDashboardServlet extends HttpServlet {

    private UserService userService;
    private dao.CandidateDashboardDAO candidateDashboardDAO;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        candidateDashboardDAO = new dao.CandidateDashboardDAO();
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

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
            
            // Fetch real candidate stats from DB
            java.util.Map<String, Object> stats = candidateDashboardDAO.getCandidateStats(userId);
            req.setAttribute("stats", stats);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin người dùng: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/candidate/dashboard.jsp").forward(req, resp);
    }
}

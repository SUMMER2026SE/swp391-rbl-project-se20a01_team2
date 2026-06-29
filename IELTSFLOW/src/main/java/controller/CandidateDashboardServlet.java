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
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
            
            dao.CandidateTargetDAO targetDAO = new dao.CandidateTargetDAO();
            java.util.Optional<model.CandidateTarget> targetOpt = targetDAO.findActiveByUserId(userId);
            if (targetOpt.isPresent()) {
                req.setAttribute("target", targetOpt.get());
            }

            // Fetch real candidate stats from DB
            java.util.Map<String, Object> stats = candidateDashboardDAO.getCandidateStats(userId);
            req.setAttribute("stats", stats);

            // Fetch real lessons for the dashboard
            services.LessonService ls = new services.LessonService();
            java.util.List<model.Lesson> allLessons = ls.getAllLessons();
            req.setAttribute("lessonsJson", generateLessonsJson(allLessons));
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin người dùng: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/candidate/dashboard.jsp").forward(req, resp);
    }

    private String generateLessonsJson(java.util.List<model.Lesson> lessons) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < lessons.size(); i++) {
            model.Lesson l = lessons.get(i);
            String type = (l.getVideoUrl() != null && !l.getVideoUrl().isEmpty()) ? "Video" : "Document";
            String color = "blue";
            String icon = "🎧";
            if ("Reading".equals(l.getSkill())) { color = "green"; icon = "📚"; }
            else if ("Writing".equals(l.getSkill())) { color = "orange"; icon = "✍️"; }
            else if ("Speaking".equals(l.getSkill())) { color = "purple"; icon = "🎙️"; }
            
            sb.append(String.format("{\"id\":%d,\"title\":\"%s\",\"type\":\"%s\",\"skill\":\"%s\",\"color\":\"%s\",\"icon\":\"%s\"}",
                l.getLessonId(), l.getTitle().replace("\"", "\\\"").replace("\n", ""), type, l.getSkill(), color, icon));
            if (i < lessons.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}

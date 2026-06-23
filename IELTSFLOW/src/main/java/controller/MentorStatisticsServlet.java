package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MentorSkillStat;
import model.User;
import services.AIEvaluationService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/mentor/statistics")
public class MentorStatisticsServlet extends HttpServlet {

    private final AIEvaluationService aiEvaluationService = new AIEvaluationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, jakarta.servlet.ServletException {

        User mentor = (User) req.getSession().getAttribute("user");
        if (mentor == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Map<String, MentorSkillStat> stats = aiEvaluationService.getMentorStats(mentor.getUserId());
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/WEB-INF/views/mentor/statistics.jsp").forward(req, resp);
    }
}

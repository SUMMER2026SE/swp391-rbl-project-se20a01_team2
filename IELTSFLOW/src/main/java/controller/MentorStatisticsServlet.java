package controller;

import dao.MentorDashboardDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MentorSkillStat;
import model.User;
import services.AIEvaluationService;

import java.io.IOException;
import java.util.Map;

/**
 * Controller tổng hợp dữ liệu cho Mentor Dashboard.
 * Ánh xạ cả /mentor/dashboard (trang chính) lẫn /mentor/statistics (giữ tương thích).
 */
@WebServlet({"/mentor/dashboard", "/mentor/statistics"})
public class MentorStatisticsServlet extends HttpServlet {

    private final AIEvaluationService aiEvaluationService = new AIEvaluationService();
    private final MentorDashboardDAO  mentorDashboardDAO  = new MentorDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, jakarta.servlet.ServletException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int mentorId = (int) session.getAttribute("userId");

        // --- Thống kê tổng quan ---
        long questionCountTotal   = mentorDashboardDAO.countTotalQuestions();
        long questionCountPersonal = mentorDashboardDAO.countPersonalQuestions(mentorId);
        
        long lessonCountTotal     = mentorDashboardDAO.countTotalLessons();
        long lessonCountPersonal  = mentorDashboardDAO.countPersonalLessons(mentorId);
        
        long examCountTotal       = mentorDashboardDAO.countTotalExams();
        long examCountPersonal    = mentorDashboardDAO.countPersonalExams(mentorId);
        
        long submissionCount      = mentorDashboardDAO.countSubmissionsForMentor(mentorId);

        // --- AI Skill Stats (Writing / Speaking) ---
        Map<String, MentorSkillStat> stats = aiEvaluationService.getMentorStats(mentorId);

        // --- Top 5 Open Tickets ---
        req.setAttribute("recentTickets", mentorDashboardDAO.getRecentOpenTickets(5));

        req.setAttribute("questionCountTotal",   questionCountTotal);
        req.setAttribute("questionCountPersonal", questionCountPersonal);
        
        req.setAttribute("lessonCountTotal",     lessonCountTotal);
        req.setAttribute("lessonCountPersonal",  lessonCountPersonal);
        
        req.setAttribute("examCountTotal",       examCountTotal);
        req.setAttribute("examCountPersonal",    examCountPersonal);
        
        req.setAttribute("submissionCount",      submissionCount);
        req.setAttribute("stats",                stats);

        req.getRequestDispatcher("/jsp/mentor/dashboard.jsp").forward(req, resp);
    }
}

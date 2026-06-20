package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TestSubmission;
import model.User;
import services.ExamHistoryService;
import services.ExamHistoryServiceImpl;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for Candidate feature pages.
 * Maps multiple URLs to their corresponding JSPs.
 */
@WebServlet(name = "CandidatePagesServlet", urlPatterns = {
    "/candidate/weekly-plan",
    "/candidate/lessons",
    "/candidate/redo-exercises"
})
public class CandidatePagesServlet extends HttpServlet {

    private UserService userService;
    private ExamHistoryService examHistoryService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        examHistoryService = new ExamHistoryServiceImpl();
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
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin người dùng: " + e.getMessage());
        }

        String path = req.getServletPath();
        String jspPath = "/jsp/candidate/dashboard.jsp"; // Default fallback

        if ("/candidate/weekly-plan".equals(path)) {
            jspPath = "/jsp/candidate/weekly-plan.jsp";
        } else if ("/candidate/lessons".equals(path)) {
            jspPath = "/jsp/candidate/lessons.jsp";
        } else if ("/candidate/redo-exercises".equals(path)) {
            loadExamHistoryData(req, userId);
            jspPath = "/jsp/candidate/redo-exercises.jsp";
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    /**
     * Load dữ liệu lịch sử bài thi và tính toán mảng cho biểu đồ Chart.js.
     */
    private void loadExamHistoryData(HttpServletRequest req, int userId) {
        try {
            // Toàn bộ lịch sử (mới nhất trước) → cho bảng lịch sử
            List<TestSubmission> submissions = examHistoryService.getSubmissionsByUser(userId);
            req.setAttribute("submissions", submissions);

            // Danh sách đã hoàn thành (cũ nhất trước) → cho biểu đồ
            List<TestSubmission> completed = examHistoryService.getCompletedSubmissionsForChart(userId);
            req.setAttribute("totalTests", (long) completed.size());
            req.setAttribute("avgBand", Math.round(examHistoryService.getAverageBand(completed) * 2) / 2.0);
            req.setAttribute("maxBand", examHistoryService.getMaxBand(completed));

            // Xây dựng mảng JSON cho Chart.js
            StringBuilder labels        = new StringBuilder("[");
            StringBuilder listeningArr  = new StringBuilder("[");
            StringBuilder readingArr    = new StringBuilder("[");
            StringBuilder writingArr    = new StringBuilder("[");
            StringBuilder speakingArr   = new StringBuilder("[");
            StringBuilder overallArr    = new StringBuilder("[");

            for (int i = 0; i < completed.size(); i++) {
                TestSubmission s = completed.get(i);
                labels.append("\"Bài ").append(i + 1).append("\"");
                listeningArr.append(s.getListeningBand() != null ? s.getListeningBand() : "null");
                readingArr  .append(s.getReadingBand()   != null ? s.getReadingBand()   : "null");
                writingArr  .append(s.getWritingBand()   != null ? s.getWritingBand()   : "null");
                speakingArr .append(s.getSpeakingBand()  != null ? s.getSpeakingBand()  : "null");
                overallArr  .append(s.getOverallBand()   != null ? s.getOverallBand()   : "null");
                if (i < completed.size() - 1) {
                    labels.append(","); listeningArr.append(","); readingArr.append(",");
                    writingArr.append(","); speakingArr.append(","); overallArr.append(",");
                }
            }
            labels.append("]"); listeningArr.append("]"); readingArr.append("]");
            writingArr.append("]"); speakingArr.append("]"); overallArr.append("]");

            req.setAttribute("chartLabels",    labels.toString());
            req.setAttribute("chartListening", listeningArr.toString());
            req.setAttribute("chartReading",   readingArr.toString());
            req.setAttribute("chartWriting",   writingArr.toString());
            req.setAttribute("chartSpeaking",  speakingArr.toString());
            req.setAttribute("chartOverall",   overallArr.toString());

        } catch (Exception e) {
            req.setAttribute("historyError", "Không thể tải lịch sử bài thi: " + e.getMessage());
            req.setAttribute("submissions", java.util.Collections.emptyList());
            req.setAttribute("totalTests", 0L);
            req.setAttribute("avgBand", 0.0);
            req.setAttribute("maxBand", 0.0);
            req.setAttribute("chartLabels", "[]");
            req.setAttribute("chartListening", "[]");
            req.setAttribute("chartReading", "[]");
            req.setAttribute("chartWriting", "[]");
            req.setAttribute("chartSpeaking", "[]");
            req.setAttribute("chartOverall", "[]");
        }
    }
}


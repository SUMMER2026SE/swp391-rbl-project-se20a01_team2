package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TestSubmission;
import model.SubmissionDetail;
import dao.MockSubmissionDAO;
import dao.SubmissionDetailsDAO;
import dao.AIEvaluationDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/mentor/submissions/*")
public class MentorSubmissionServlet extends HttpServlet {

    private final MockSubmissionDAO submissionDAO = new MockSubmissionDAO();
    private final SubmissionDetailsDAO detailsDAO = new SubmissionDetailsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String pathInfo = req.getPathInfo();
        try {
            if (pathInfo != null && pathInfo.length() > 1) {
                int submissionId = Integer.parseInt(pathInfo.substring(1));
                TestSubmission submission = submissionDAO.getSubmissionById(submissionId);
                if (submission == null) {
                    resp.sendError(404, "Không tìm thấy bài nộp");
                    return;
                }
                
                List<SubmissionDetail> details = detailsDAO.getDetailsBySubmissionId(submissionId);
                
                req.setAttribute("submission", submission);
                req.setAttribute("details", details);
                req.getRequestDispatcher("/jsp/mentor/submission-detail.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/students");
            }
        } catch (NumberFormatException e) {
            resp.sendError(400, "ID không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String action = req.getParameter("action");
        try {
            if ("override".equals(action)) {
                int detailId = Integer.parseInt(req.getParameter("detailId"));
                int submissionId = Integer.parseInt(req.getParameter("submissionId"));
                double mentorScore = Double.parseDouble(req.getParameter("mentorScore"));
                String mentorFeedback = req.getParameter("mentorFeedback");

                detailsDAO.updateMentorOverride(detailId, mentorScore, mentorFeedback);

                resp.sendRedirect(req.getContextPath() + "/mentor/submissions/" + submissionId + "?success=Đã lưu đánh giá của Mentor");
            } else {
                resp.sendError(400, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Có lỗi xảy ra: " + e.getMessage());
        }
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req) throws IOException {
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

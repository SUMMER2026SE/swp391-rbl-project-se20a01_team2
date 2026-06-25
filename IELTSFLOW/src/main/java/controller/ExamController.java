package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Exam;
import services.ExamService;

import java.io.IOException;

/**
 * ExamController - SSR refactored:
 *   GET /admin/exams          : Tìm kiếm/Xem đề thi và forward to JSP
 *   POST /admin/exams         : Thêm/Sửa/Xóa đề thi qua form parameter
 */
@WebServlet({"/admin/exams/*", "/mentor/exams/*"})
public class ExamController extends HttpServlet {

    private final ExamService examService = new ExamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        boolean isMentor = req.getServletPath().startsWith("/mentor");
        String jspPath = isMentor ? "/jsp/mentor/" : "/jsp/admin/";

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String action = req.getParameter("action");
                if ("new".equals(action)) {
                    req.getRequestDispatcher(jspPath + "exam-detail.jsp").forward(req, resp);
                    return;
                }

                String keyword    = req.getParameter("keyword");
                String skillFocus = req.getParameter("skill");
                String type       = req.getParameter("type");
                req.setAttribute("exams", examService.searchExams(keyword, skillFocus, type));
                req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Exam exam = examService.getExamById(id);
                if (exam == null) {
                    req.setAttribute("error", "Exam not found");
                    req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("exam", exam);
                req.getRequestDispatcher(jspPath + "exam-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid ID format");
            req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        boolean isMentor = req.getServletPath().startsWith("/mentor");
        String redirectPrefix = isMentor ? "/mentor/exams" : "/admin/exams";

        try {
            if ("create".equals(action)) {
                Exam exam = buildFromRequest(req);
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute("userId") != null) {
                    exam.setMentorId((Integer) session.getAttribute("userId"));
                }
                examService.createExam(exam);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Exam exam = buildFromRequest(req);
                exam.setExamId(id);
                examService.updateExam(exam);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                examService.deleteExam(id);
            }
            resp.sendRedirect(req.getContextPath() + redirectPrefix);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private Exam buildFromRequest(HttpServletRequest req) {
        Exam exam = new Exam();
        exam.setTitle(req.getParameter("title"));
        exam.setType(req.getParameter("type"));
        String skill = req.getParameter("skill");
        exam.setSkillFocus((skill == null || skill.isBlank()) ? "All" : skill);
        String durationParam = req.getParameter("duration");
        if (durationParam != null && !durationParam.isBlank()) {
            exam.setDuration(Integer.parseInt(durationParam));
        }
        return exam;
    }
}

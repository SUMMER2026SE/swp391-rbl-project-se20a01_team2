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
@WebServlet("/admin/exams/*")
public class ExamController extends HttpServlet {

    private final ExamService examService = new ExamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String keyword    = req.getParameter("keyword");
                String skillFocus = req.getParameter("skill");
                String type       = req.getParameter("type");
                req.setAttribute("exams", examService.searchExams(keyword, skillFocus, type));
                req.getRequestDispatcher("/jsp/admin/exams.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Exam exam = examService.getExamById(id);
                if (exam == null) {
                    req.setAttribute("error", "Exam not found");
                    req.getRequestDispatcher("/jsp/admin/exams.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("exam", exam);
                req.getRequestDispatcher("/jsp/admin/exam-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid ID format");
            req.getRequestDispatcher("/jsp/admin/exams.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/exams.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                Exam exam = new Exam();
                // populate
                // examService.createExam(exam);
            } else if ("update".equals(action)) {
                Exam exam = new Exam();
                // populate
                // examService.updateExam(exam);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                examService.deleteExam(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/exams");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}

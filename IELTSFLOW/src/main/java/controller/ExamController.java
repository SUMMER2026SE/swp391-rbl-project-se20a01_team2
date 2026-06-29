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
                
                int page = 1;
                int pageSize = 20;

                try { if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
                try { if (req.getParameter("limit") != null) pageSize = Integer.parseInt(req.getParameter("limit")); } catch (Exception ignored) {}
                
                util.PaginatedList<model.Exam> examsPage = examService.searchExams(keyword, skillFocus, type, page, pageSize);
                req.setAttribute("examsPage", examsPage);
                req.setAttribute("exams", examsPage.getItems());
                req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
            } else {
                String[] parts = pathInfo.split("/");
                int id = Integer.parseInt(parts[1]);
                Exam exam = examService.getExamById(id);
                if (exam == null) {
                    req.setAttribute("error", "Exam not found");
                    req.getRequestDispatcher(jspPath + "exams.jsp").forward(req, resp);
                    return;
                }

                if (parts.length > 4 && "sections".equals(parts[2]) && "add-questions".equals(parts[4])) {
                    int sectionId = Integer.parseInt(parts[3]);
                    model.ExamSection section = examService.getSectionById(sectionId);
                    if (section == null) {
                        resp.sendRedirect(req.getContextPath() + (isMentor ? "/mentor/exams/" : "/admin/exams/") + id);
                        return;
                    }
                    String keyword = req.getParameter("keyword");
                    String resourceIdStr = req.getParameter("resourceId");
                    Integer resourceId = (resourceIdStr != null && !resourceIdStr.isBlank()) ? Integer.parseInt(resourceIdStr) : null;
                    
                    services.QuestionService qs = new services.QuestionService();
                    java.util.List<model.Question> questions = qs.searchQuestions(keyword, section.getSkill(), resourceId);
                    req.setAttribute("exam", exam);
                    req.setAttribute("section", section);
                    req.setAttribute("questions", questions);
                    req.setAttribute("allResources", new services.QuestionResourceService().getAllResources());
                    req.getRequestDispatcher(jspPath + "exam-add-questions.jsp").forward(req, resp);
                    return;
                }

                req.setAttribute("exam", exam);
                req.setAttribute("sections", examService.getExamSections(id));
                req.setAttribute("allResources", new services.QuestionResourceService().getAllResources());
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
                resp.sendRedirect(req.getContextPath() + redirectPrefix);
                return;

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Exam exam = buildFromRequest(req);
                exam.setExamId(id);
                examService.updateExam(exam);
                resp.sendRedirect(req.getContextPath() + redirectPrefix);
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                examService.deleteExam(id);
                resp.sendRedirect(req.getContextPath() + redirectPrefix);
                return;

            } else if ("addSection".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                model.ExamSection sec = new model.ExamSection();
                sec.setExamId(examId);
                sec.setSectionName(req.getParameter("sectionName"));
                sec.setSkill(req.getParameter("skill"));
                sec.setOrderIndex(Integer.parseInt(req.getParameter("orderIndex")));
                examService.addSection(sec);
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;

            } else if ("updateSection".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                int sectionId = Integer.parseInt(req.getParameter("sectionId"));
                model.ExamSection sec = examService.getSectionById(sectionId);
                if (sec != null) {
                    sec.setSectionName(req.getParameter("sectionName"));
                    sec.setSkill(req.getParameter("skill"));
                    sec.setOrderIndex(Integer.parseInt(req.getParameter("orderIndex")));
                    examService.updateSection(sec);
                }
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;

            } else if ("updateSectionResource".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                int sectionId = Integer.parseInt(req.getParameter("sectionId"));
                model.ExamSection sec = examService.getSectionById(sectionId);
                if (sec != null) {
                    String resourceIdStr = req.getParameter("resourceId");
                    if (resourceIdStr != null && !resourceIdStr.trim().isEmpty()) {
                        sec.setResourceId(Integer.parseInt(resourceIdStr));
                    } else {
                        sec.setResourceId(null);
                    }
                    examService.updateSection(sec);
                }
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;

            } else if ("deleteSection".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                int sectionId = Integer.parseInt(req.getParameter("sectionId"));
                examService.deleteSection(sectionId);
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;

            } else if ("removeQuestion".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                int sectionId = Integer.parseInt(req.getParameter("sectionId"));
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                examService.removeQuestionFromSection(sectionId, questionId);
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;

            } else if ("addQuestions".equals(action)) {
                int examId = Integer.parseInt(req.getParameter("examId"));
                int sectionId = Integer.parseInt(req.getParameter("sectionId"));
                String[] qIds = req.getParameterValues("questionIds");
                if (qIds != null) {
                    for (String qIdStr : qIds) {
                        examService.addQuestionToSection(sectionId, Integer.parseInt(qIdStr));
                    }
                }
                resp.sendRedirect(req.getContextPath() + redirectPrefix + "/" + examId);
                return;
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

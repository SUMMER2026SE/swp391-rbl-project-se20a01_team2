package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Lesson;
import services.LessonService;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/mentor/lessons/*")
public class MentorLessonServlet extends HttpServlet {

    private final LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        int mentorId = (int) session.getAttribute("userId");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // List: show only this mentor's lessons, support keyword+skill filter
                String keyword = req.getParameter("keyword");
                String skill   = req.getParameter("skill");
                boolean hasFilter = (keyword != null && !keyword.isBlank())
                        || (skill   != null && !skill.isBlank());
                req.setAttribute("lessons",
                        hasFilter
                                ? lessonService.searchLessons(keyword, skill)
                                : lessonService.getLessonsByMentor(mentorId));
                req.getRequestDispatcher("/jsp/mentor/lessons.jsp").forward(req, resp);

            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Lesson lesson = lessonService.getLessonById(id);
                if (lesson == null) {
                    req.setAttribute("error", "Không tìm thấy bài học");
                    req.getRequestDispatcher("/jsp/mentor/lessons.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("lesson", lesson);
                req.getRequestDispatcher("/jsp/mentor/lesson-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ");
            req.getRequestDispatcher("/jsp/mentor/lessons.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/mentor/lessons.jsp").forward(req, resp);
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
            if ("create".equals(action)) {
                Lesson lesson = buildFromRequest(req);
                if (lesson.getTitle() == null || lesson.getTitle().isBlank())
                    throw new Exception("Tiêu đề không được để trống");
                if (lesson.getSkill() == null || lesson.getSkill().isBlank())
                    throw new Exception("Kỹ năng không được để trống");
                lesson.setCreatedBy(mentorId);
                lesson.setCreatedAt(LocalDateTime.now());
                lesson.setDeleted(false);
                lessonService.createLesson(lesson);
                resp.sendRedirect(req.getContextPath() + "/mentor/lessons?success=Tạo+bài+học+thành+công");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("lessonId"));
                Lesson existing = lessonService.getLessonById(id);
                if (existing == null)
                    throw new Exception("Không tìm thấy bài học #" + id);
                if (!existing.getCreatedBy().equals(mentorId))
                    throw new Exception("Bạn không có quyền chỉnh sửa bài học này");

                Lesson updated = buildFromRequest(req);
                if (updated.getTitle() == null || updated.getTitle().isBlank())
                    throw new Exception("Tiêu đề không được để trống");
                if (updated.getSkill() == null || updated.getSkill().isBlank())
                    throw new Exception("Kỹ năng không được để trống");
                updated.setLessonId(id);
                lessonService.updateLesson(updated);
                resp.sendRedirect(req.getContextPath() + "/mentor/lessons?success=Cập+nhật+thành+công");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("lessonId"));
                Lesson existing = lessonService.getLessonById(id);
                if (existing == null)
                    throw new Exception("Không tìm thấy bài học #" + id);
                if (!existing.getCreatedBy().equals(mentorId))
                    throw new Exception("Bạn không có quyền xóa bài học này");
                lessonService.deleteLesson(id);
                resp.sendRedirect(req.getContextPath() + "/mentor/lessons?success=Xóa+bài+học+thành+công");

            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/lessons");
            }

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private Lesson buildFromRequest(HttpServletRequest req) {
        Lesson lesson = new Lesson();
        lesson.setTitle(req.getParameter("title"));
        lesson.setContent(req.getParameter("content"));
        lesson.setVideoUrl(req.getParameter("videoUrl"));
        lesson.setDocumentUrl(req.getParameter("documentUrl"));
        lesson.setSkill(req.getParameter("skill"));
        return lesson;
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req)
            throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return false;
        }
        return true;
    }
}

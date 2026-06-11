package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Lesson;
import services.LessonService;

import java.io.IOException;
import java.util.List;

/**
 * LessonController - SSR refactored:
 *   GET /admin/lessons          : Tìm kiếm/Xem bài học và forward to JSP
 *   POST /admin/lessons         : Thêm/Sửa/Xóa bài học qua form parameter
 */
@WebServlet("/admin/lessons/*")
public class LessonController extends HttpServlet {

    private final LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String keyword = req.getParameter("keyword");
                String skill   = req.getParameter("skill");
                List<Lesson> lessons = lessonService.searchLessons(keyword, skill);
                req.setAttribute("lessons", lessons);
                req.getRequestDispatcher("/jsp/admin/lessons.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Lesson lesson = lessonService.getLessonById(id);
                if (lesson == null) {
                    req.setAttribute("error", "Lesson not found");
                    req.getRequestDispatcher("/jsp/admin/lessons.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("lesson", lesson);
                req.getRequestDispatcher("/jsp/admin/lesson-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid ID format");
            req.getRequestDispatcher("/jsp/admin/lessons.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/lessons.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                Lesson lesson = new Lesson();
                // To be fully implemented with parameter mapping
                // lessonService.createLesson(lesson);
            } else if ("update".equals(action)) {
                Lesson lesson = new Lesson();
                // To be fully implemented with parameter mapping
                // lessonService.updateLesson(lesson);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                lessonService.deleteLesson(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/lessons");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}

package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Lesson;
import services.LessonService;

import java.io.IOException;
import java.util.List;

/**
 * LessonController - xử lý các chức năng:
 *   #21 Tìm kiếm bài học : GET /api/lessons?keyword=...&skill=...
 *   #22 Xem bài học       : GET /api/lessons/{id}
 */
@WebServlet("/api/lessons/*")
public class LessonController extends HttpServlet {

    private final LessonService lessonService = new LessonService();
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // #21 Tìm kiếm bài học
                String keyword = req.getParameter("keyword");
                String skill   = req.getParameter("skill");
                List<Lesson> lessons = lessonService.searchLessons(keyword, skill);
                mapper.writeValue(resp.getWriter(), lessons);
            } else {
                // #22 Xem chi tiết bài học
                int id = Integer.parseInt(pathInfo.substring(1));
                Lesson lesson = lessonService.getLessonById(id);
                if (lesson == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\":\"Lesson not found\"}");
                    return;
                }
                mapper.writeValue(resp.getWriter(), lesson);
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid ID format\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            Lesson lesson = mapper.readValue(req.getReader(), Lesson.class);
            lessonService.createLesson(lesson);
            resp.setStatus(HttpServletResponse.SC_CREATED);
            mapper.writeValue(resp.getWriter(), lesson);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            Lesson lesson = mapper.readValue(req.getReader(), Lesson.class);
            lessonService.updateLesson(lesson);
            mapper.writeValue(resp.getWriter(), lesson);
        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            lessonService.deleteLesson(Integer.parseInt(pathInfo.substring(1)));
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}

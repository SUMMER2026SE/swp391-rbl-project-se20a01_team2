package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Exam;
import services.ExamService;

import java.io.IOException;

/**
 * ExamController - xử lý các chức năng:
 *   #24 Làm lại bài luyện tập : GET /api/exams/{id}  (lấy đề để làm lại)
 *   #28 Tìm kiếm đề thi       : GET /api/exams?keyword=...&skill=...&type=...
 */
@WebServlet("/api/exams/*")
public class ExamController extends HttpServlet {

    private final ExamService examService = new ExamService();
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // #28 Tìm kiếm đề thi
                String keyword    = req.getParameter("keyword");
                String skillFocus = req.getParameter("skill");
                String type       = req.getParameter("type");
                mapper.writeValue(resp.getWriter(),
                        examService.searchExams(keyword, skillFocus, type));
            } else {
                // #24 Lấy chi tiết đề thi để làm lại
                int id = Integer.parseInt(pathInfo.substring(1));
                Exam exam = examService.getExamById(id);
                if (exam == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\":\"Exam not found\"}");
                    return;
                }
                mapper.writeValue(resp.getWriter(), exam);
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
            Exam exam = mapper.readValue(req.getReader(), Exam.class);
            examService.createExam(exam);
            resp.setStatus(HttpServletResponse.SC_CREATED);
            mapper.writeValue(resp.getWriter(), exam);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            Exam exam = mapper.readValue(req.getReader(), Exam.class);
            examService.updateExam(exam);
            mapper.writeValue(resp.getWriter(), exam);
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
            examService.deleteExam(Integer.parseInt(pathInfo.substring(1)));
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}

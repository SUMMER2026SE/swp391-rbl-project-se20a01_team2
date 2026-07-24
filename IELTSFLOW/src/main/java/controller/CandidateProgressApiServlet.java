package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.UserLessonProgressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserLessonProgress;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/progress")
public class CandidateProgressApiServlet extends HttpServlet {

    private UserLessonProgressDAO userLessonProgressDAO;
    private ObjectMapper mapper;

    @Override
    public void init() throws ServletException {
        userLessonProgressDAO = new UserLessonProgressDAO();
        mapper = new ObjectMapper();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"Unauthorized\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        String lessonIdStr = req.getParameter("lessonId");

        if (lessonIdStr == null || action == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing parameters\"}");
            return;
        }

        int lessonId;
        try {
            lessonId = Integer.parseInt(lessonIdStr);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Invalid lessonId\"}");
            return;
        }

        try {
            UserLessonProgress progress = userLessonProgressDAO.findByUserAndLesson(userId, lessonId);
            boolean isNew = false;
            
            if (progress == null) {
                progress = new UserLessonProgress();
                progress.setUserId(userId);
                progress.setLessonId(lessonId);
                progress.setCompleted(false);
                progress.setBookmarked(false);
                progress.setLastAccessed(LocalDateTime.now());
                isNew = true;
            } else {
                progress.setLastAccessed(LocalDateTime.now());
            }

            boolean currentState = false;

            if ("toggle_lesson_progress".equals(action)) {
                progress.setCompleted(!progress.isCompleted());
                currentState = progress.isCompleted();
            } else if ("toggle_lesson_bookmark".equals(action)) {
                progress.setBookmarked(!progress.isBookmarked());
                currentState = progress.isBookmarked();
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\": \"Invalid action\"}");
                return;
            }

            if (isNew) {
                userLessonProgressDAO.save(progress);
            } else {
                userLessonProgressDAO.update(progress);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("currentState", currentState);
            result.put("lessonId", lessonId);
            out.write(mapper.writeValueAsString(result));

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Internal server error\"}");
        }
    }
}

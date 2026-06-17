package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Answer;
import model.Question;
import services.QuestionService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/mentor/questions/*")
public class MentorQuestionServlet extends HttpServlet {

    private final QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isAuthenticated(session, req, resp)) return;

        int mentorId = (int) session.getAttribute("userId");
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String keyword = req.getParameter("keyword");
                String skill   = req.getParameter("skill");
                boolean hasFilter = (keyword != null && !keyword.isBlank())
                        || (skill   != null && !skill.isBlank());
                req.setAttribute("questions",
                        hasFilter
                                ? questionService.searchQuestions(keyword, skill)
                                : questionService.getQuestionsByMentor(mentorId));
                req.getRequestDispatcher("/jsp/mentor/questions.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Question question = questionService.getQuestionWithTags(id);
                if (question == null) {
                    req.setAttribute("error", "Không tìm thấy câu hỏi");
                    req.getRequestDispatcher("/jsp/mentor/questions.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("question", question);
                req.setAttribute("allTags", questionService.getAllTags());
                req.getRequestDispatcher("/jsp/mentor/question-detail.jsp").forward(req, resp);
                }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ");
            req.getRequestDispatcher("/jsp/mentor/questions.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/mentor/questions.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isAuthenticated(session, req, resp)) return;

        int mentorId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                Question question = buildQuestionFromRequest(req);
                question.setCreatedBy(mentorId);
                questionService.createQuestion(question, buildAnswersFromRequest(req));
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=Tạo+câu+hỏi+thành+công");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("questionId"));
                Question existing = questionService.getQuestionById(id);
                if (existing == null)
                    throw new Exception("Không tìm thấy câu hỏi #" + id);
                if (!existing.getCreatedBy().equals(mentorId))
                    throw new Exception("Bạn không có quyền chỉnh sửa câu hỏi này");
                Question question = buildQuestionFromRequest(req);
                question.setQuestionId(id);
                questionService.updateQuestion(question, buildAnswersFromRequest(req));
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=Cập+nhật+thành+công");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("questionId"));
                questionService.deleteQuestion(id, mentorId);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=Xóa+câu+hỏi+thành+công");

            } else if ("addTag".equals(action)) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                int tagId      = Integer.parseInt(req.getParameter("tagId"));
                questionService.addTagToQuestion(questionId, tagId, mentorId);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions/" + questionId + "?success=Gắn+tag+thành+công");

            } else if ("removeTag".equals(action)) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                int tagId = Integer.parseInt(req.getParameter("tagId"));
                questionService.removeTagFromQuestion(questionId, tagId, mentorId);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions/" + questionId + "?success=Xóa+tag+thành+công");
            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/questions");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private Question buildQuestionFromRequest(HttpServletRequest req) {
        Question q = new Question();
        q.setContent(req.getParameter("content"));
        q.setQuestionType(req.getParameter("questionType"));
        q.setSkill(req.getParameter("skill"));
        q.setDifficulty(req.getParameter("difficulty"));
        q.setExplanation(req.getParameter("explanation"));
        q.setContentJson(req.getParameter("contentJson"));
        String resourceIdStr = req.getParameter("resourceId");
        if (resourceIdStr != null && !resourceIdStr.isBlank())
            q.setResourceId(Integer.parseInt(resourceIdStr));
        String orderStr = req.getParameter("orderInResource");
        if (orderStr != null && !orderStr.isBlank())
            q.setOrderInResource(Integer.parseInt(orderStr));
        return q;
    }

    private List<Answer> buildAnswersFromRequest(HttpServletRequest req) {
        List<Answer> answers = new ArrayList<>();
        String countStr = req.getParameter("answerCount");
        if (countStr == null || countStr.isBlank()) return answers;
        int count = Integer.parseInt(countStr);
        for (int i = 0; i < count; i++) {
            String content = req.getParameter("answerContent_" + i);
            if (content == null || content.isBlank()) continue;
            Answer answer = new Answer();
            answer.setContent(content.trim());
            String cj = req.getParameter("answerContentJson_" + i);
            answer.setContentJson(cj != null && !cj.isBlank() ? cj : "{}");
            answer.setCorrect("true".equals(req.getParameter("answerIsCorrect_" + i)));
            answers.add(answer);
        }
        return answers;
    }

    private boolean isAuthenticated(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return false;
        }
        return true;
    }
}

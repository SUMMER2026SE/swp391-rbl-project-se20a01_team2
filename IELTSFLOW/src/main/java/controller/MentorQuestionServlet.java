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
                String action = req.getParameter("action");
                if ("new".equals(action)) {
                    req.setAttribute("allTags", questionService.getAllTags());
                    req.setAttribute("allResources", new services.QuestionResourceService().getAllResources());
                    req.getRequestDispatcher("/jsp/mentor/question-detail.jsp").forward(req, resp);
                    return;
                }

                String keyword = req.getParameter("keyword");
                String skill   = req.getParameter("skill");
                String difficulty = req.getParameter("difficulty");
                String type    = req.getParameter("type");

                int page = 1;
                int pageSize = 20;

                try { if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
                try { if (req.getParameter("limit") != null) pageSize = Integer.parseInt(req.getParameter("limit")); } catch (Exception ignored) {}

                util.PaginatedList<model.Question> questionsPage = questionService.searchQuestions(keyword, skill, difficulty, type, page, pageSize);
                req.setAttribute("questionsPage", questionsPage);
                req.setAttribute("questions", questionsPage.getItems());
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
                req.setAttribute("allResources", new services.QuestionResourceService().getAllResources());
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
                questionService.createQuestion(question, buildAnswersFromRequest(req), extractTagIds(req));
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=" + java.net.URLEncoder.encode("Tạo câu hỏi thành công", "UTF-8"));

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("questionId"));
                Question existing = questionService.getQuestionById(id);
                if (existing == null)
                    throw new Exception("Không tìm thấy câu hỏi #" + id);
                Question question = buildQuestionFromRequest(req);
                question.setQuestionId(id);
                questionService.updateQuestion(question, buildAnswersFromRequest(req), extractTagIds(req));
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=" + java.net.URLEncoder.encode("Cập nhật thành công", "UTF-8"));

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("questionId"));
                questionService.deleteQuestion(id);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions?success=" + java.net.URLEncoder.encode("Xóa câu hỏi thành công", "UTF-8"));

            } else if ("addTag".equals(action)) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                int tagId      = Integer.parseInt(req.getParameter("tagId"));
                questionService.addTagToQuestion(questionId, tagId);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions/" + questionId + "?success=" + java.net.URLEncoder.encode("Gắn tag thành công", "UTF-8"));

            } else if ("removeTag".equals(action)) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                int tagId = Integer.parseInt(req.getParameter("tagId"));
                questionService.removeTagFromQuestion(questionId, tagId);
                resp.sendRedirect(req.getContextPath() + "/mentor/questions/" + questionId + "?success=" + java.net.URLEncoder.encode("Xóa tag thành công", "UTF-8"));
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

    private List<Integer> extractTagIds(HttpServletRequest req) {
        List<Integer> tagIds = new ArrayList<>();
        String[] ids = req.getParameterValues("tagIds");
        if (ids != null) {
            for (String id : ids) {
                try {
                    tagIds.add(Integer.parseInt(id));
                } catch (NumberFormatException ignored) {}
            }
        }
        return tagIds;
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
            resp.sendRedirect(req.getContextPath() + "/auth");
            return false;
        }
        return true;
    }
}

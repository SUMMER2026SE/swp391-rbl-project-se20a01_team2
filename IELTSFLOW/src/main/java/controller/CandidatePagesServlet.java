package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TestSubmission;
import model.User;
import services.ExamHistoryService;
import services.ExamHistoryServiceImpl;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import dao.CandidateTargetDAO;
import dao.SubmissionDetailsDAO;
import services.PathwayService;
import services.AIPathwayService;
import model.Pathway;
import model.WeeklyPlan;

/**
 * Servlet for Candidate feature pages.
 * Maps multiple URLs to their corresponding JSPs.
 */
@WebServlet(name = "CandidatePagesServlet", urlPatterns = {
    "/candidate/weekly-plan",
    "/candidate/lessons",
    "/candidate/redo-exercises",
    "/candidate/lesson-detail"
})
public class CandidatePagesServlet extends HttpServlet {

    private UserService userService;
    private ExamHistoryService examHistoryService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        examHistoryService = new ExamHistoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin người dùng: " + e.getMessage());
        }

        String path = req.getServletPath();
        String jspPath = "/jsp/candidate/dashboard.jsp"; // Default fallback

        // Kiểm tra subscription
        services.SubscriptionService subService = new services.SubscriptionService();
        boolean hasActiveSub = (subService.getActiveSubscriptionByUserId(userId) != null);

        if (("/candidate/weekly-plan".equals(path) || 
             "/candidate/lessons".equals(path) || 
             "/candidate/lesson-detail".equals(path) || 
             "/candidate/redo-exercises".equals(path)) && !hasActiveSub) {
            resp.sendRedirect(req.getContextPath() + "/subscription?error=premium_required");
            return;
        }

        if ("/candidate/weekly-plan".equals(path)) {
            String action = req.getParameter("action");
            
            // API Endpoint kiểm tra trạng thái sinh lộ trình
            if ("check-status".equals(action)) {
                resp.setContentType("application/json");
                try {
                    CandidateTargetDAO targetDAO = new CandidateTargetDAO();
                    java.util.Optional<model.CandidateTarget> targetOpt = targetDAO.findActiveByUserId(userId);
                    
                    if (targetOpt.isPresent()) {
                        TestSubmission latestTest = examHistoryService.getLatestCompletedPlacementTest(userId);
                        if (latestTest != null) {
                            PathwayService pwService = new PathwayService();
                            List<Pathway> existingPathways = pwService.getPathwaysByUser(userId);
                            boolean hasPathway = existingPathways.stream()
                                    .anyMatch(p -> p.getPlacementTestId() != null && p.getPlacementTestId().equals(latestTest.getSubmissionId()));
                            if (hasPathway) {
                                resp.getWriter().write("{\"status\":\"ready\"}");
                                return;
                            }
                        }
                    }
                } catch (Exception e) {}
                
                String errorMsg = (String) session.getAttribute("pathwayGeneratingError_" + userId);
                if (errorMsg != null) {
                    // Escape double quotes if any
                    errorMsg = errorMsg.replace("\"", "\\\"");
                    resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + errorMsg + "\"}");
                    return;
                }
                
                resp.getWriter().write("{\"status\":\"pending\"}");
                return;
            }
            
            try {
                CandidateTargetDAO targetDAO = new CandidateTargetDAO();
                java.util.Optional<model.CandidateTarget> targetOpt = targetDAO.findActiveByUserId(userId);
                
                if (targetOpt.isEmpty()) {
                    req.setAttribute("needsTarget", true);
                } else {
                    TestSubmission latestTest = examHistoryService.getLatestCompletedPlacementTest(userId);
                    
                    if (latestTest == null) {
                        req.setAttribute("hasNoPlacementTest", true);
                    } else {
                        boolean isExpired = latestTest.getEndTime() == null || 
                            ChronoUnit.DAYS.between(latestTest.getEndTime(), LocalDateTime.now()) > 30;
                            
                        PathwayService pwService = new PathwayService();
                        List<Pathway> existingPathways = pwService.getPathwaysByUser(userId);
                        
                        Pathway currentPathway = existingPathways.stream()
                                .filter(p -> p.getPlacementTestId() != null && p.getPlacementTestId().equals(latestTest.getSubmissionId()))
                                .findFirst()
                                .orElse(null);
                        
                        if (currentPathway == null) {
                            if (isExpired) {
                                req.setAttribute("hasNoPlacementTest", true);
                            } else {
                                req.setAttribute("canGeneratePathway", true);
                                req.setAttribute("submissionId", latestTest.getSubmissionId());
                                req.setAttribute("targetBand", targetOpt.get().getTargetBand());
                                
                                Boolean isGenerating = (Boolean) session.getAttribute("pathwayGenerating_" + userId);
                                if (Boolean.TRUE.equals(isGenerating)) {
                                    req.setAttribute("isGenerating", true);
                                }
                                
                                String genError = (String) session.getAttribute("pathwayGeneratingError_" + userId);
                                if (genError != null) {
                                    req.setAttribute("generationError", genError);
                                    session.removeAttribute("pathwayGeneratingError_" + userId);
                                }
                            }
                        } else {
                            if (currentPathway.getTargetBand() != null && currentPathway.getTargetBand().compareTo(targetOpt.get().getTargetBand()) != 0) {
                                req.setAttribute("targetBandMismatched", true);
                                req.setAttribute("submissionId", latestTest.getSubmissionId());
                                req.setAttribute("targetBand", targetOpt.get().getTargetBand());
                                req.setAttribute("oldTargetBand", currentPathway.getTargetBand());
                            }
                            
                            List<WeeklyPlan> plans = pwService.getWeeklyPlans(currentPathway.getPathwayId());
                            req.setAttribute("weeklyPlans", plans);
                            req.setAttribute("pathway", currentPathway);
                            if (isExpired) {
                                req.setAttribute("isPathwayExpired", true);
                            }
                            session.removeAttribute("pathwayGenerating_" + userId);
                        }
                    }
                }
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi tải lộ trình: " + e.getMessage());
            }
            
            jspPath = "/jsp/candidate/weekly-plan.jsp";
        } else if ("/candidate/lessons".equals(path)) {
            services.LessonService ls = new services.LessonService();
            req.setAttribute("lessonsJson", generateLessonsJson(ls.getAllLessons()));
            jspPath = "/jsp/candidate/lessons.jsp";
        } else if ("/candidate/lesson-detail".equals(path)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                services.LessonService ls = new services.LessonService();
                model.Lesson lesson = ls.getLessonById(id);
                if (lesson != null) {
                    req.setAttribute("lesson", lesson);
                    jspPath = "/jsp/candidate/lesson-detail.jsp";
                } else {
                    resp.sendRedirect(req.getContextPath() + "/candidate/lessons");
                    return;
                }
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/candidate/lessons");
                return;
            }
        } else if ("/candidate/redo-exercises".equals(path)) {
            loadExamHistoryData(req, userId);
            jspPath = "/jsp/candidate/redo-exercises.jsp";
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String path = req.getServletPath();
        String action = req.getParameter("action");

        if ("/candidate/weekly-plan".equals(path) && "generate".equals(action)) {
            try {
                int submissionId = Integer.parseInt(req.getParameter("submissionId"));
                java.math.BigDecimal targetBand = new java.math.BigDecimal(req.getParameter("targetBand"));
                
                // Set cờ isGenerating
                session.setAttribute("pathwayGenerating_" + userId, true);
                
                // Lấy thông tin bài test
                services.MockTestService mockService = new services.MockTestService();
                TestSubmission submission = mockService.getSubmissionById(submissionId);
                
                // Lấy wrongTagsCount
                SubmissionDetailsDAO sdDao = new SubmissionDetailsDAO();
                java.util.Map<String, Integer> wrongTagsCount = sdDao.getWrongTagsCountBySubmissionId(submissionId);
                
                AIPathwayService aiService = new AIPathwayService();
                PathwayService pwService = new PathwayService();
                
                final boolean isRegeneratingOldTest = "true".equals(req.getParameter("useOldTest"));
                
                aiService.generatePathwayAsync(submission, targetBand, wrongTagsCount)
                    .thenAccept(weeklyPlans -> {
                        if (weeklyPlans != null && !weeklyPlans.isEmpty()) {
                            
                            // Delete old pathway if regenerating with old test
                            if (isRegeneratingOldTest) {
                                List<Pathway> existing = pwService.getPathwaysByUser(userId);
                                existing.stream()
                                    .filter(p -> p.getPlacementTestId() != null && p.getPlacementTestId().equals(submission.getSubmissionId()))
                                    .findFirst()
                                    .ifPresent(p -> {
                                        try {
                                            pwService.deletePathway(p.getPathwayId());
                                        } catch (Exception ignored) {}
                                    });
                            }
                            
                            Pathway newPathway = new Pathway();
                            newPathway.setUserId(userId);
                            newPathway.setPlacementTestId(submission.getSubmissionId());
                            newPathway.setTargetBand(targetBand);
                            newPathway.setCreatedAt(LocalDateTime.now());
                            
                            try {
                                pwService.createPathway(newPathway, weeklyPlans);
                                System.out.println("Đã lưu Lộ trình vào Database thành công cho User " + userId);
                                
                                // Send notification
                                services.NotificationService notifService = new services.NotificationService();
                                notifService.sendPlanGeneratedNotification(userId);
                                
                                session.removeAttribute("pathwayGeneratingError_" + userId);
                                
                            } catch (Exception e) {
                                System.err.println("Lỗi khi lưu lộ trình DB: " + e.getMessage());
                            }
                        } else {
                            System.err.println("Sinh lộ trình AI thất bại hoặc rỗng cho User " + userId);
                            session.setAttribute("pathwayGeneratingError_" + userId, "Có lỗi xảy ra trong quá trình sinh lộ trình. Vui lòng thử lại sau.");
                            session.removeAttribute("pathwayGenerating_" + userId);
                        }
                    }).exceptionally(ex -> {
                        System.err.println("Exception khi sinh lộ trình AI: " + ex.getMessage());
                        session.setAttribute("pathwayGeneratingError_" + userId, "Có lỗi xảy ra trong quá trình sinh lộ trình. Vui lòng thử lại sau.");
                        session.removeAttribute("pathwayGenerating_" + userId);
                        return null;
                    });
                    
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/candidate/weekly-plan");
            return;
        }
        
        resp.sendRedirect(req.getContextPath() + "/candidate/dashboard");
    }

    /**
     * Load dữ liệu lịch sử bài thi và tính toán mảng cho biểu đồ Chart.js.
     */
    private void loadExamHistoryData(HttpServletRequest req, int userId) {
        try {
            // Toàn bộ lịch sử (mới nhất trước) → cho bảng lịch sử
            List<TestSubmission> submissions = examHistoryService.getSubmissionsByUser(userId);
            req.setAttribute("submissions", submissions);

            // Danh sách đã hoàn thành (cũ nhất trước) → cho biểu đồ
            List<TestSubmission> completed = examHistoryService.getCompletedSubmissionsForChart(userId);
            req.setAttribute("totalTests", (long) completed.size());
            req.setAttribute("avgBand", Math.round(examHistoryService.getAverageBand(completed) * 2) / 2.0);
            req.setAttribute("maxBand", examHistoryService.getMaxBand(completed));

            // Xây dựng mảng JSON cho Chart.js
            StringBuilder labels        = new StringBuilder("[");
            StringBuilder listeningArr  = new StringBuilder("[");
            StringBuilder readingArr    = new StringBuilder("[");
            StringBuilder writingArr    = new StringBuilder("[");
            StringBuilder speakingArr   = new StringBuilder("[");
            StringBuilder overallArr    = new StringBuilder("[");

            for (int i = 0; i < completed.size(); i++) {
                TestSubmission s = completed.get(i);
                labels.append("\"#").append(s.getSubmissionId()).append("\"");
                listeningArr.append(s.getListeningBand() != null ? s.getListeningBand() : "null");
                readingArr  .append(s.getReadingBand()   != null ? s.getReadingBand()   : "null");
                writingArr  .append(s.getWritingBand()   != null ? s.getWritingBand()   : "null");
                speakingArr .append(s.getSpeakingBand()  != null ? s.getSpeakingBand()  : "null");
                overallArr  .append(s.getOverallBand()   != null ? s.getOverallBand()   : "null");
                if (i < completed.size() - 1) {
                    labels.append(","); listeningArr.append(","); readingArr.append(",");
                    writingArr.append(","); speakingArr.append(","); overallArr.append(",");
                }
            }
            labels.append("]"); listeningArr.append("]"); readingArr.append("]");
            writingArr.append("]"); speakingArr.append("]"); overallArr.append("]");

            req.setAttribute("chartLabels",    labels.toString());
            req.setAttribute("chartListening", listeningArr.toString());
            req.setAttribute("chartReading",   readingArr.toString());
            req.setAttribute("chartWriting",   writingArr.toString());
            req.setAttribute("chartSpeaking",  speakingArr.toString());
            req.setAttribute("chartOverall",   overallArr.toString());

        } catch (Exception e) {
            req.setAttribute("historyError", "Không thể tải lịch sử bài thi: " + e.getMessage());
            req.setAttribute("submissions", java.util.Collections.emptyList());
            req.setAttribute("totalTests", 0L);
            req.setAttribute("avgBand", 0.0);
            req.setAttribute("maxBand", 0.0);
            req.setAttribute("chartLabels", "[]");
            req.setAttribute("chartListening", "[]");
            req.setAttribute("chartReading", "[]");
            req.setAttribute("chartWriting", "[]");
            req.setAttribute("chartSpeaking", "[]");
            req.setAttribute("chartOverall", "[]");
        }
    }

    private String generateLessonsJson(List<model.Lesson> lessons) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < lessons.size(); i++) {
            model.Lesson l = lessons.get(i);
            String type = (l.getVideoUrl() != null && !l.getVideoUrl().isEmpty()) ? "Video" : "Document";
            String color = "blue";
            String icon = "🎧";
            if ("Reading".equals(l.getSkill())) { color = "green"; icon = "📚"; }
            else if ("Writing".equals(l.getSkill())) { color = "orange"; icon = "✍️"; }
            else if ("Speaking".equals(l.getSkill())) { color = "purple"; icon = "🎙️"; }
            
            sb.append(String.format("{\"id\":%d,\"title\":\"%s\",\"type\":\"%s\",\"skill\":\"%s\",\"color\":\"%s\",\"icon\":\"%s\"}",
                l.getLessonId(), l.getTitle().replace("\"", "\\\"").replace("\n", ""), type, l.getSkill(), color, icon));
            if (i < lessons.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}


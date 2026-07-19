package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Exam;
import model.Question;
import model.SubmissionDetail;
import model.TestSubmission;
import services.MockTestService;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

/**
 * MockTestServlet — Xử lý toàn bộ luồng Mock Test:
 *
 *   GET  /candidate/mock-test                → Trang chọn đề thi
 *   POST /candidate/mock-test?action=start   → Tạo bài làm, load vào session, redirect take
 *   GET  /candidate/mock-test?action=take    → Giao diện thi (có timer, anti-cheat, speech-to-text)
 *   POST /candidate/mock-test?action=submit  → Chấm điểm, lưu DB, redirect result
 *   POST /candidate/mock-test?action=violation → Ghi nhận vi phạm (AJAX)
 *   GET  /candidate/mock-test?action=result&submissionId=X → Trang kết quả
 */
@WebServlet(name = "MockTestServlet", urlPatterns = {"/candidate/mock-test"})
public class MockTestServlet extends HttpServlet {

    private MockTestService mockTestService;

    @Override
    public void init() throws ServletException {
        mockTestService = new MockTestService();
    }

    // ──── GET ────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        services.SubscriptionService subService = new services.SubscriptionService();
        boolean hasActiveSub = (subService.getActiveSubscriptionByUserId(userId) != null);
        if (!hasActiveSub) {
            resp.sendRedirect(req.getContextPath() + "/subscription?error=premium_required_mocktest");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "take":
                    handleTake(req, resp);
                    break;
                case "result":
                    handleResult(req, resp);
                    break;
                default:
                    handleIndex(req, resp);
                    break;
            }
        } catch (Exception e) {
            resp.setContentType("text/plain;charset=UTF-8");
            e.printStackTrace(resp.getWriter());
        }
    }

    // ──── POST ───────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        services.SubscriptionService subService = new services.SubscriptionService();
        boolean hasActiveSub = (subService.getActiveSubscriptionByUserId(userId) != null);
        if (!hasActiveSub) {
            resp.sendRedirect(req.getContextPath() + "/subscription?error=premium_required_mocktest");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "start":
                    handleStart(req, resp);
                    break;
                case "submit":
                    handleSubmit(req, resp);
                    break;
                case "violation":
                    handleViolation(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/candidate/mock-test");
                    break;
            }
        } catch (Exception e) {
            resp.setContentType("text/plain;charset=UTF-8");
            e.printStackTrace(resp.getWriter());
        }
    }

    // ──── Handlers ───────────────────────────────────────────────────────

    /** Hiển thị trang chọn đề thi */
    private void handleIndex(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<Exam> exams = mockTestService.getAllMockTests();
        req.setAttribute("exams", exams);
        req.getRequestDispatcher("/jsp/mock-test/index.jsp").forward(req, resp);
    }

    /** Bắt đầu thi: tạo submission, load câu hỏi vào session, redirect sang take */
    private void handleStart(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");
        
        String testMode = req.getParameter("testMode");
        String examIdStr = req.getParameter("examId");
        String skillStr = req.getParameter("skillFocus");
        
        Exam exam = null;
        if ("placement".equals(testMode)) {
            exam = mockTestService.getRandomPlacementTest();
            if (exam == null) { 
                exam = mockTestService.getRandomMockTest();
            }
            skillStr = "All";
        } else if ("mocktest".equals(testMode)) {
            if (examIdStr != null && !examIdStr.isEmpty()) {
                try { exam = mockTestService.getMockTestById(Integer.parseInt(examIdStr)); } catch (Exception ignored) {}
            }
            skillStr = "All";
        } else {
            // practice test is default
            if (examIdStr != null && !examIdStr.isEmpty()) {
                try { exam = mockTestService.getMockTestById(Integer.parseInt(examIdStr)); } catch (Exception ignored) {}
            }
        }
        
        if (exam == null) {
            exam = mockTestService.getRandomMockTest();
        }
        
        if (exam == null) {
            req.setAttribute("errorMsg", "Hiện tại chưa có đề thi nào. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/jsp/mock-test/index.jsp").forward(req, resp);
            return;
        }

        if (skillStr != null && !skillStr.isEmpty() && !skillStr.equals("All")) {
            exam.setSkillFocus(skillStr);
        }

        int submissionId = mockTestService.createSubmission(userId, exam.getExamId());
        List<Question> questions = mockTestService.getQuestionsForExam(exam.getExamId());
        List<model.ExamSection> sections = mockTestService.getSectionsWithQuestionsForExam(exam.getExamId());

        if (skillStr != null && !skillStr.isEmpty() && !skillStr.equals("All")) {
            final String filterSkill = skillStr;
            sections = sections.stream()
                               .filter(s -> filterSkill.equalsIgnoreCase(s.getSkill()))
                               .collect(java.util.stream.Collectors.toList());
            questions = questions.stream()
                                 .filter(q -> filterSkill.equalsIgnoreCase(q.getSkill()))
                                 .collect(java.util.stream.Collectors.toList());
        }

        HttpSession session = req.getSession();
        session.setAttribute("mt_currentExam", exam);
        session.setAttribute("mt_currentQuestions", questions);
        session.setAttribute("mt_currentSections", sections);
        session.setAttribute("mt_currentSubmissionId", submissionId);
        session.setAttribute("mt_examStartTime", System.currentTimeMillis());

        resp.sendRedirect(req.getContextPath() + "/candidate/mock-test?action=take");
    }

    /** Render giao diện thi */
    private void handleTake(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        Exam exam = (Exam) session.getAttribute("mt_currentExam");
        if (exam == null) {
            resp.sendRedirect(req.getContextPath() + "/candidate/mock-test");
            return;
        }
        req.setAttribute("exam", exam);
        req.setAttribute("questions", session.getAttribute("mt_currentQuestions"));
        req.setAttribute("sections", session.getAttribute("mt_currentSections"));
        req.setAttribute("submissionId", session.getAttribute("mt_currentSubmissionId"));
        req.setAttribute("maxViolations", mockTestService.getMaxViolations());
        req.getRequestDispatcher("/jsp/mock-test/take.jsp").forward(req, resp);
    }

    /** Nộp bài: chấm điểm, lưu DB, dọn session, redirect kết quả */
    @SuppressWarnings("unchecked")
    private void handleSubmit(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        int submissionId = (Integer) session.getAttribute("mt_currentSubmissionId");
        List<Question> questions = (List<Question>) session.getAttribute("mt_currentQuestions");
        List<model.FeedbackWriting> writingFeedbacks = new ArrayList<>();
        List<model.FeedbackSpeaking> speakingFeedbacks = new ArrayList<>();

        int correctReading = 0, totalReading = 0;
        int correctListening = 0, totalListening = 0;
        double sumWriting = 0, sumSpeaking = 0;
        int countWriting = 0, countSpeaking = 0;
        // Dùng 1 instance duy nhất để tận dụng key rotation static counter
        services.AIEvaluationService aiSvc = new services.AIEvaluationService();

        // Thu thập các tác vụ AI cần chấm TRƯỚC, sau đó chạy tuần tự tránh rate-limit
        // Format: int[]{detailId}, String topic, String answer/transcript, double azureScore
        java.util.List<int[]>    writingDetailIds   = new java.util.ArrayList<>();
        java.util.List<String>   writingTopics      = new java.util.ArrayList<>();
        java.util.List<String>   writingAnswers     = new java.util.ArrayList<>();
        java.util.List<int[]>    speakingDetailIds  = new java.util.ArrayList<>();
        java.util.List<String>   speakingTopics     = new java.util.ArrayList<>();
        java.util.List<String>   speakingTranscripts = new java.util.ArrayList<>();
        java.util.List<double[]> speakingScores     = new java.util.ArrayList<>();

        for (Question q : questions) {
            String skill  = q.getSkill()        != null ? q.getSkill().trim()        : "";
            String qType  = q.getQuestionType() != null ? q.getQuestionType().trim() : "";
            
            // Xử lý parameter gửi lên từ form
            String[] answersArray = req.getParameterValues("q_" + q.getQuestionId());
            String answer = null;
            if (answersArray != null && answersArray.length > 0) {
                if (answersArray.length == 1) {
                    answer = answersArray[0];
                } else {
                    // Nếu là nhiều đáp án, gom thành JSON Array string
                    try {
                        answer = new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(answersArray);
                    } catch (Exception e) {
                        answer = answersArray[0];
                    }
                }
            }

            // Only apply answer-ID-to-content conversion for objective (non-AI) skills
            boolean isAiSkill = "Speaking".equalsIgnoreCase(skill) || "Writing".equalsIgnoreCase(skill);
            if (!isAiSkill && ("Multiple_Choice".equals(qType) || "MultipleChoice".equals(qType) || "FillBlank".equals(qType) || "FillInBlanks".equals(qType)) 
                && answer != null && !answer.isBlank()) {
                
                // Nếu chỉ có 1 đáp án dạng ID, convert sang nội dung text (như code cũ)
                if (!answer.trim().startsWith("[")) {
                    try {
                        int ansId = Integer.parseInt(answer.trim());
                        for (model.Answer a : q.getAnswers()) {
                            if (a.getAnswerId() == ansId) {
                                answer = a.getContent();
                                break;
                            }
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            SubmissionDetail detail = new SubmissionDetail();
            detail.setSubmissionId(submissionId);
            detail.setQuestionId(q.getQuestionId());
            detail.setCandidateAnswer(answer);

            // Route to objective grading only if the skill is NOT Speaking/Writing.
            // Speaking questions may have QuestionType='FillInBlanks' in the DB,
            // so skill must take precedence over qType here.
            if (!isAiSkill && ("Multiple_Choice".equals(qType) || "MultipleChoice".equals(qType) || "FillBlank".equals(qType) || "FillInBlanks".equals(qType))) {
                int correctCount = mockTestService.isAnswerCorrect(q, answer);
                detail.setIsCorrect(correctCount > 0);
                detail.setScore((double) correctCount);
                detail.setGradingStatus("Graded");
                if ("Reading".equalsIgnoreCase(skill))   { 
                    totalReading += q.getQuestionCount();   
                    correctReading += correctCount;   
                }
                if ("Listening".equalsIgnoreCase(skill)) { 
                    totalListening += q.getQuestionCount(); 
                    correctListening += correctCount; 
                }
                mockTestService.saveDetail(detail);
            } else {
                detail.setGradingStatus("Pending_AI");
                String transcript = null;
                double azureScore = 0.0;
                if ("Speaking".equalsIgnoreCase(skill) || "Speaking".equalsIgnoreCase(qType)) {
                    detail.setSpeakingUrl(req.getParameter("speaking_url_" + q.getQuestionId()));
                    transcript = req.getParameter("transcript_" + q.getQuestionId());
                    detail.setCandidateTranscript(transcript);
                    String azureScoreStr = req.getParameter("azure_" + q.getQuestionId());
                    if (azureScoreStr != null && !azureScoreStr.isEmpty()) {
                        try { azureScore = Double.parseDouble(azureScoreStr); } catch (NumberFormatException ignored) {}
                    }
                }
                int detailId = mockTestService.saveDetail(detail);

                if ("Writing".equalsIgnoreCase(skill) || "Writing".equalsIgnoreCase(qType) || "Essay".equalsIgnoreCase(qType)) {
                    countWriting++;
                    writingDetailIds.add(new int[]{detailId});
                    writingTopics.add(q.getContent());
                    writingAnswers.add(answer);
                } else if ("Speaking".equalsIgnoreCase(skill) || "Speaking".equalsIgnoreCase(qType)) {
                    countSpeaking++;
                    speakingDetailIds.add(new int[]{detailId});
                    speakingTopics.add(q.getContent());
                    speakingTranscripts.add(transcript);
                    speakingScores.add(new double[]{azureScore});
                }
            }
        }

        // Chạy Writing tuần tự (chained) - tránh rate-limit khi nhiều task cùng lúc
        // QUAN TRỌNG: Gộp tất cả Writing + Speaking vào 1 chain DUY NHẤT
        // để tránh rate-limit khi 2 chain chạy song song cùng lúc
        java.util.concurrent.CompletableFuture<Void> allAiTasks =
            java.util.concurrent.CompletableFuture.completedFuture(null);

        for (int i = 0; i < writingDetailIds.size(); i++) {
            final int detailId = writingDetailIds.get(i)[0];
            final String topic = writingTopics.get(i);
            final String essay = writingAnswers.get(i);
            allAiTasks = allAiTasks.thenCompose(v ->
                aiSvc.evaluateWritingAsync(detailId, topic, essay).thenApply(r -> null));
        }

        for (int i = 0; i < speakingDetailIds.size(); i++) {
            final int detailId      = speakingDetailIds.get(i)[0];
            final String topic      = speakingTopics.get(i);
            final String transcript = speakingTranscripts.get(i);
            final double azureScore = speakingScores.get(i)[0];
            allAiTasks = allAiTasks.thenCompose(v ->
                aiSvc.evaluateSpeakingAsync(detailId, topic, transcript, azureScore).thenApply(r -> null));
        }

        Double listeningBand = totalListening > 0 ? mockTestService.rawToBand(correctListening, totalListening) : null;
        Double readingBand   = totalReading   > 0 ? mockTestService.rawToBand(correctReading,   totalReading)   : null;
        
        // Vì AI đang chấm ngầm, điểm ban đầu sẽ là null (Pending)
        Double writingBand   = null;
        Double speakingBand  = null;
        
        Double overall = mockTestService.calcOverall(listeningBand, readingBand, writingBand, speakingBand);

        int violationCount = 0;
        Object vc = session.getAttribute("mt_violationCount_" + submissionId);
        if (vc != null) violationCount = (int) vc;
        boolean forcedSubmit = Boolean.TRUE.equals(session.getAttribute("mt_forcedSubmit_" + submissionId));

        TestSubmission finalSub = new TestSubmission();
        finalSub.setSubmissionId(submissionId);
        finalSub.setEndTime(LocalDateTime.now());
        finalSub.setListeningBand(listeningBand);
        finalSub.setReadingBand(readingBand);
        finalSub.setWritingBand(writingBand);
        finalSub.setSpeakingBand(speakingBand);
        finalSub.setOverallBand(overall);
        finalSub.setViolationCount(violationCount);
        finalSub.setCheated(forcedSubmit);
        finalSub.setStatus(forcedSubmit ? "Abandoned" : "Completed");
        mockTestService.finaliseSubmission(finalSub);

        req.setAttribute("writingFeedbacks", writingFeedbacks);
        req.setAttribute("speakingFeedbacks", speakingFeedbacks);

        // Fetch back full join Exam for result page
        TestSubmission fullInfo = mockTestService.getSubmissionById(submissionId);
        session.removeAttribute("mt_currentExam");
        session.removeAttribute("mt_currentQuestions");
        session.removeAttribute("mt_currentSubmissionId");
        session.removeAttribute("mt_examStartTime");
        session.removeAttribute("mt_violationCount_" + submissionId);
        session.removeAttribute("mt_forcedSubmit_" + submissionId);

        resp.sendRedirect(req.getContextPath() + "/candidate/mock-test?action=result&submissionId=" + submissionId);
    }

    /** AJAX: ghi nhận vi phạm anti-cheat, trả về JSON */
    private void handleViolation(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        Object subIdObj = session != null ? session.getAttribute("mt_currentSubmissionId") : null;
        if (subIdObj == null) {
            resp.setStatus(400);
            return;
        }
        int submissionId = (int) subIdObj;
        int violations = mockTestService.incrementViolation(submissionId);
        boolean cheated = violations >= mockTestService.getMaxViolations();

        if (cheated && session != null) {
            session.setAttribute("mt_forcedSubmit_" + submissionId, true);
        }
        if (session != null) {
            session.setAttribute("mt_violationCount_" + submissionId, violations);
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("{\"violations\":" + violations + ",\"cheated\":" + cheated + "}");
    }

    /** Hiển thị trang kết quả bài thi */
    private void handleResult(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int subId;
        try {
            subId = Integer.parseInt(req.getParameter("submissionId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/candidate/dashboard");
            return;
        }

        int userId = (int) req.getSession().getAttribute("userId");
        TestSubmission sub = mockTestService.getSubmissionById(subId);
        if (sub == null || sub.getUserId() != userId) {
            resp.sendRedirect(req.getContextPath() + "/candidate/dashboard");
            return;
        }

        req.setAttribute("submission", sub);
        
        if (sub.getStartTime() != null && sub.getEndTime() != null) {
            java.time.Duration duration = java.time.Duration.between(sub.getStartTime(), sub.getEndTime());
            long totalSeconds = duration.getSeconds();
            long h = totalSeconds / 3600;
            long m = (totalSeconds % 3600) / 60;
            long s = totalSeconds % 60;
            String timeTaken = (h > 0 ? h + " giờ " : "") + (m > 0 ? m + " phút " : "") + s + " giây";
            req.setAttribute("timeTaken", timeTaken);
        }
        
        // --- AI Feedback ---
        dao.AIEvaluationDAO aiDao = new dao.AIEvaluationDAO();
        List<String> feedbackJsons = aiDao.getFeedbackJsonStringsBySubmissionId(subId);
        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
        mapper.configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        List<model.FeedbackWriting> writingFeedbacks = new ArrayList<>();
        List<model.FeedbackSpeaking> speakingFeedbacks = new ArrayList<>();

        for (String json : feedbackJsons) {
            try {
                if (json.contains("\"taskResponse\"")) {
                    writingFeedbacks.add(mapper.readValue(json, model.FeedbackWriting.class));
                } else if (json.contains("\"pronunciation\"")) {
                    speakingFeedbacks.add(mapper.readValue(json, model.FeedbackSpeaking.class));
                }
            } catch (Exception e) {
                java.util.logging.Logger.getLogger("MockTestServlet").log(
                    java.util.logging.Level.SEVERE, "Lỗi parse Feedback JSON", e);
            }
        }
        req.setAttribute("writingFeedbacks", writingFeedbacks);
        req.setAttribute("speakingFeedbacks", speakingFeedbacks);
        
        // Fetch submission details for mentor override info
        dao.SubmissionDetailsDAO detailsDao = new dao.SubmissionDetailsDAO();
        java.util.List<model.SubmissionDetail> details = detailsDao.getDetailsBySubmissionId(subId);
        java.util.List<model.SubmissionDetail> writingDetails = new java.util.ArrayList<>();
        java.util.List<model.SubmissionDetail> speakingDetails = new java.util.ArrayList<>();
        for (model.SubmissionDetail d : details) {
            if ("Writing".equalsIgnoreCase(d.getSkill())) {
                writingDetails.add(d);
            } else if ("Speaking".equalsIgnoreCase(d.getSkill())) {
                speakingDetails.add(d);
            }
        }
        req.setAttribute("writingDetails", writingDetails);
        req.setAttribute("speakingDetails", speakingDetails);

        // --- Answer Review cho Reading/Listening ---
        java.util.List<model.AnswerReviewItem> answerReview =
            aiDao.getAnswerReviewBySubmissionId(subId);
        java.util.List<model.AnswerReviewItem> listeningReview = new java.util.ArrayList<>();
        java.util.List<model.AnswerReviewItem> readingReview   = new java.util.ArrayList<>();
        for (model.AnswerReviewItem item : answerReview) {
            if ("Listening".equals(item.getSkill())) listeningReview.add(item);
            else readingReview.add(item);
        }
        req.setAttribute("listeningReview", listeningReview);
        req.setAttribute("readingReview",   readingReview);
        // -------------------------------------------

        // Lấy lịch sử bài thi của user
        List<TestSubmission> history = mockTestService.getSubmissionsByUser(userId);
        req.setAttribute("history", history);
        req.getRequestDispatcher("/jsp/mock-test/result.jsp").forward(req, resp);
    }
}

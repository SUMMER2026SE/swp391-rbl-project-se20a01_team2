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
 * PlacementTestServlet — Xử lý toàn bộ luồng Mock Test:
 *
 *   GET  /candidate/placement-test                → Trang chọn đề thi
 *   POST /candidate/placement-test?action=start   → Tạo bài làm, load vào session, redirect take
 *   GET  /candidate/placement-test?action=take    → Giao diện thi (có timer, anti-cheat, speech-to-text)
 *   POST /candidate/placement-test?action=submit  → Chấm điểm, lưu DB, redirect result
 *   POST /candidate/placement-test?action=violation → Ghi nhận vi phạm (AJAX)
 *   GET  /candidate/placement-test?action=result&submissionId=X → Trang kết quả
 */
@WebServlet(name = "PlacementTestServlet", urlPatterns = {"/candidate/placement-test"})
public class PlacementTestServlet extends HttpServlet {

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
                    resp.sendRedirect(req.getContextPath() + "/candidate/placement-test");
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
        Exam exam = mockTestService.getRandomPlacementTest();
        req.setAttribute("exam", exam);
        req.getRequestDispatcher("/jsp/placement-test/index.jsp").forward(req, resp);
    }

    /** Bắt đầu thi: tạo submission, load câu hỏi vào session, redirect sang take */
    private void handleStart(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");
        Exam exam = mockTestService.getRandomPlacementTest();
        if (exam == null) {
            req.setAttribute("errorMsg", "Hiện tại chưa có đề thi nào. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/jsp/placement-test/index.jsp").forward(req, resp);
            return;
        }

        int submissionId = mockTestService.createSubmission(userId, exam.getExamId());
        List<Question> questions = mockTestService.getQuestionsForExam(exam.getExamId());
        List<model.ExamSection> sections = mockTestService.getSectionsWithQuestionsForExam(exam.getExamId());

        HttpSession session = req.getSession();
        session.setAttribute("mt_currentExam", exam);
        session.setAttribute("mt_currentQuestions", questions);
        session.setAttribute("mt_currentSections", sections);
        session.setAttribute("mt_currentSubmissionId", submissionId);
        session.setAttribute("mt_examStartTime", System.currentTimeMillis());

        resp.sendRedirect(req.getContextPath() + "/candidate/placement-test?action=take");
    }

    /** Render giao diện thi */
    private void handleTake(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        Exam exam = (Exam) session.getAttribute("mt_currentExam");
        if (exam == null) {
            resp.sendRedirect(req.getContextPath() + "/candidate/placement-test");
            return;
        }
        req.setAttribute("exam", exam);
        req.setAttribute("questions", session.getAttribute("mt_currentQuestions"));
        req.setAttribute("sections", session.getAttribute("mt_currentSections"));
        req.setAttribute("submissionId", session.getAttribute("mt_currentSubmissionId"));
        req.setAttribute("maxViolations", mockTestService.getMaxViolations());
        req.getRequestDispatcher("/jsp/placement-test/take.jsp").forward(req, resp);
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
        services.AIEvaluationService aiSvc = new services.AIEvaluationService();

        java.util.List<int[]>    writingDetailIds    = new java.util.ArrayList<>();
        java.util.List<String>   writingTopics       = new java.util.ArrayList<>();
        java.util.List<String>   writingAnswers      = new java.util.ArrayList<>();
        java.util.List<int[]>    speakingDetailIds   = new java.util.ArrayList<>();
        java.util.List<String>   speakingTopics      = new java.util.ArrayList<>();
        java.util.List<String>   speakingTranscripts = new java.util.ArrayList<>();
        java.util.List<double[]> speakingScores      = new java.util.ArrayList<>();

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

            if (("Multiple_Choice".equals(qType) || "MultipleChoice".equals(qType) || "FillBlank".equals(qType) || "FillInBlanks".equals(qType)) 
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

            if ("Multiple_Choice".equals(qType) || "MultipleChoice".equals(qType) || "FillBlank".equals(qType) || "FillInBlanks".equals(qType)) {
                int correctCount = mockTestService.isAnswerCorrect(q, answer);
                detail.setIsCorrect(correctCount > 0);
                detail.setScore((double) correctCount);
                detail.setGradingStatus("Graded");
                if ("Reading".equals(skill))   { 
                    totalReading += q.getQuestionCount();   
                    correctReading += correctCount;   
                }
                if ("Listening".equals(skill)) { 
                    totalListening += q.getQuestionCount(); 
                    correctListening += correctCount; 
                }
                mockTestService.saveDetail(detail);
            } else {
                detail.setGradingStatus("Pending_AI");
                String transcript = null;
                double azureScore = 0.0;
                if ("Speaking".equals(skill)) {
                    detail.setSpeakingUrl(req.getParameter("speaking_url_" + q.getQuestionId()));
                    transcript = req.getParameter("transcript_" + q.getQuestionId());
                    detail.setCandidateTranscript(transcript);
                    String azureScoreStr = req.getParameter("azure_" + q.getQuestionId());
                    if (azureScoreStr != null && !azureScoreStr.isEmpty()) {
                        try { azureScore = Double.parseDouble(azureScoreStr); } catch (NumberFormatException ignored) {}
                    }
                }
                int detailId = mockTestService.saveDetail(detail);

                if ("Writing".equals(skill)) {
                    countWriting++;
                    writingDetailIds.add(new int[]{detailId});
                    writingTopics.add(q.getContent());
                    writingAnswers.add(answer);
                } else if ("Speaking".equals(skill)) {
                    countSpeaking++;
                    speakingDetailIds.add(new int[]{detailId});
                    speakingTopics.add(q.getContent());
                    speakingTranscripts.add(transcript);
                    speakingScores.add(new double[]{azureScore});
                }
            }
        }

        // Gộp tất cả Writing + Speaking vào 1 chain DUY NHẤT
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

        // Dọn sạch session
        session.removeAttribute("mt_currentExam");
        session.removeAttribute("mt_currentQuestions");
        session.removeAttribute("mt_currentSubmissionId");
        session.removeAttribute("mt_examStartTime");
        session.removeAttribute("mt_violationCount_" + submissionId);
        session.removeAttribute("mt_forcedSubmit_" + submissionId);

        resp.sendRedirect(req.getContextPath() + "/candidate/placement-test?action=result&submissionId=" + submissionId);
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
                java.util.logging.Logger.getLogger("PlacementTestServlet").log(
                    java.util.logging.Level.SEVERE, "Lỗi parse Feedback JSON", e);
            }
        }
        req.setAttribute("writingFeedbacks", writingFeedbacks);
        req.setAttribute("speakingFeedbacks", speakingFeedbacks);

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
        req.getRequestDispatcher("/jsp/placement-test/result.jsp").forward(req, resp);
    }
}

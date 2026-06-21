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
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
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
                    resp.sendRedirect(req.getContextPath() + "/candidate/mock-test");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
        }
    }

    // ──── Handlers ───────────────────────────────────────────────────────

    /** Hiển thị trang chọn đề thi */
    private void handleIndex(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        Exam exam = mockTestService.getRandomMockTest();
        req.setAttribute("exam", exam);
        req.getRequestDispatcher("/jsp/mock-test/index.jsp").forward(req, resp);
    }

    /** Bắt đầu thi: tạo submission, load câu hỏi vào session, redirect sang take */
    private void handleStart(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");
        Exam exam = mockTestService.getRandomMockTest();
        if (exam == null) {
            req.setAttribute("errorMsg", "Hiện tại chưa có đề thi nào. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/jsp/mock-test/index.jsp").forward(req, resp);
            return;
        }

        int submissionId = mockTestService.createSubmission(userId, exam.getExamId());
        List<Question> questions = mockTestService.getQuestionsForExam(exam.getExamId());

        HttpSession session = req.getSession();
        session.setAttribute("mt_currentExam", exam);
        session.setAttribute("mt_currentQuestions", questions);
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

        int correctReading = 0, totalReading = 0;
        int correctListening = 0, totalListening = 0;
        double sumWriting = 0, sumSpeaking = 0;
        int countWriting = 0, countSpeaking = 0;

        for (Question q : questions) {
            String skill  = q.getSkill()        != null ? q.getSkill().trim()        : "";
            String qType  = q.getQuestionType() != null ? q.getQuestionType().trim() : "";
            String answer = req.getParameter("q_" + q.getQuestionId());

            SubmissionDetail detail = new SubmissionDetail();
            detail.setSubmissionId(submissionId);
            detail.setQuestionId(q.getQuestionId());
            detail.setCandidateAnswer(answer);

            if ("Multiple_Choice".equals(qType) || "FillBlank".equals(qType)) {
                boolean correct = mockTestService.isAnswerCorrect(q, answer);
                detail.setIsCorrect(correct);
                detail.setScore(correct ? 1.0 : 0.0);
                detail.setGradingStatus("Graded");
                if ("Reading".equals(skill))   { totalReading++;   if (correct) correctReading++;   }
                if ("Listening".equals(skill)) { totalListening++; if (correct) correctListening++; }
                mockTestService.saveDetail(detail);
            } else {
                detail.setGradingStatus("Pending_AI");
                if ("Speaking".equals(skill)) {
                    detail.setSpeakingUrl(req.getParameter("speaking_url_" + q.getQuestionId()));
                    detail.setCandidateTranscript(req.getParameter("transcript_" + q.getQuestionId()));
                }
                int detailId = mockTestService.saveDetail(detail);
                double aiScore = mockTestService.gradeSubjectiveAnswer(detailId, skill, answer);
                if ("Writing".equals(skill))  { sumWriting  += aiScore; countWriting++;  }
                if ("Speaking".equals(skill)) { sumSpeaking += aiScore; countSpeaking++; }
            }
        }

        Double listeningBand = totalListening > 0 ? mockTestService.rawToBand(correctListening, totalListening) : null;
        Double readingBand   = totalReading   > 0 ? mockTestService.rawToBand(correctReading,   totalReading)   : null;
        Double writingBand   = countWriting   > 0 ? (sumWriting  / countWriting)  : null;
        Double speakingBand  = countSpeaking  > 0 ? (sumSpeaking / countSpeaking) : null;
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

        // Dọn sạch session
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
        // Lấy lịch sử bài thi của user
        List<TestSubmission> history = mockTestService.getSubmissionsByUser(userId);
        req.setAttribute("history", history);
        req.getRequestDispatcher("/jsp/mock-test/result.jsp").forward(req, resp);
    }
}

package controller;

import dao.CandidateTargetDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CandidateTarget;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

/**
 * REST API để lấy và lưu mục tiêu IELTS của học viên.
 * GET  /api/goal  → trả JSON mục tiêu hiện tại
 * POST /api/goal  → lưu/cập nhật mục tiêu
 */
@WebServlet(name = "GoalApiServlet", urlPatterns = {"/api/goal"})
public class GoalApiServlet extends HttpServlet {

    private final CandidateTargetDAO dao;

    public GoalApiServlet() {
        this.dao = new CandidateTargetDAO();
    }

    // Constructor for testing
    GoalApiServlet(CandidateTargetDAO dao) {
        this.dao = dao;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(401);
            out.print("{\"error\":\"Unauthenticated\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        Optional<CandidateTarget> opt = dao.findActiveByUserId(userId);

        if (opt.isPresent()) {
            CandidateTarget t = opt.get();
            out.print("{\"currentBand\":" + t.getCurrentBand() +
                      ",\"targetBand\":" + t.getTargetBand() +
                      ",\"examDate\":\"" + (t.getExamDate() != null ? t.getExamDate().toString() : "") + "\"}");
        } else {
            out.print("{\"currentBand\":null,\"targetBand\":null,\"examDate\":\"\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(401);
            out.print("{\"error\":\"Unauthenticated\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            String currentStr = req.getParameter("currentBand");
            String targetStr  = req.getParameter("targetBand");
            String dateStr    = req.getParameter("examDate");

            if (targetStr == null || targetStr.trim().isEmpty()) {
                resp.setStatus(400);
                out.print("{\"error\":\"targetBand is required\"}");
                return;
            }

            BigDecimal currentBand = (currentStr != null && !currentStr.isEmpty()) ? new BigDecimal(currentStr) : null;
            
            BigDecimal targetBand;
            try {
                targetBand = new BigDecimal(targetStr);
            } catch (NumberFormatException e) {
                resp.setStatus(400);
                out.print("{\"error\":\"targetBand must be a number\"}");
                return;
            }

            if (targetBand.compareTo(new BigDecimal("4.0")) < 0 || targetBand.compareTo(new BigDecimal("9.0")) > 0) {
                resp.setStatus(400);
                out.print("{\"error\":\"Target band must be between 4.0 and 9.0\"}");
                return;
            }

            LocalDate examDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : null;

            dao.saveOrUpdate(userId, currentBand, targetBand, examDate);
            out.print("{\"success\":true}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"error\":\"" + (e.getMessage() != null ? e.getMessage().replace("\"", "'") : "Unknown error") + "\"}");
        }
    }
}

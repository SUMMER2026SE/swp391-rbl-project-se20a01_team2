package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import model.Transaction;
import services.TransactionService;
import services.TransactionServiceImpl;

@WebServlet("/api/transaction/cancel")
public class TransactionCancelServlet extends HttpServlet {
    
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        
        String txIdParam = req.getParameter("transactionId");
        if (txIdParam == null || txIdParam.isEmpty()) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Missing transactionId\"}");
            return;
        }

        try {
            int txId = Integer.parseInt(txIdParam);
            Transaction t = transactionService.getTransactionById(txId);
            
            if (t == null) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Transaction not found\"}");
                return;
            }

            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
                return;
            }
            
            int userId = (Integer) session.getAttribute("userId");
            if (t.getUserId() != userId) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
                return;
            }

            if (!"Pending".equalsIgnoreCase(t.getStatus())) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Transaction cannot be cancelled at this stage\"}");
                return;
            }

            // Update status to Failed/Cancelled
            t.setStatus("Failed/Cancelled");
            transactionService.updateTransaction(t);

            resp.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false, \"message\": \"Internal Server Error\"}");
        }
    }
}

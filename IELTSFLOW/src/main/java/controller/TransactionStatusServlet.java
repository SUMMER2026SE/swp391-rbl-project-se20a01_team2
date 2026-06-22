package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import model.Transaction;
import services.TransactionService;
import services.TransactionServiceImpl;

@WebServlet("/api/transaction/status")
public class TransactionStatusServlet extends HttpServlet {
    
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.getWriter().write("{\"status\": \"Error\"}");
            return;
        }
        
        try {
            int txId = Integer.parseInt(idParam);
            Transaction t = transactionService.getTransactionById(txId);
            if (t != null) {
                resp.getWriter().write("{\"status\": \"" + t.getStatus() + "\"}");
            } else {
                resp.getWriter().write("{\"status\": \"NotFound\"}");
            }
        } catch (Exception e) {
            resp.getWriter().write("{\"status\": \"Error\"}");
        }
    }
}

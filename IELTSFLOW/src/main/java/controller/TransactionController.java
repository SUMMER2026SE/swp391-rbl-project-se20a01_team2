/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ntpho
 */

import services.TransactionService;
import services.TransactionServiceImpl;
import model.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/transactions")
public class TransactionController extends HttpServlet {
    private TransactionService transactionService = new TransactionServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy status từ URL (nếu có) để lọc, ví dụ: /admin/transactions?status=Success
        String status = request.getParameter("status");
        List<Transaction> list;

        if (status != null && !status.isEmpty()) {
            list = transactionService.getTransactionsByStatus(status);
        } else {
            list = transactionService.getAllTransactions();
        }

        request.setAttribute("transactions", list);
        request.setAttribute("currentStatus", status); // Truyền status hiện tại để UI hiển thị đúng bộ lọc
        
        request.getRequestDispatcher("/jsp/admin/transactions.jsp").forward(request, response);
    }
}
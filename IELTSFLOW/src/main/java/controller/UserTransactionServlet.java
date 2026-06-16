package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Transaction;
import model.User;
import services.TransactionService;
import services.TransactionServiceImpl;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserTransactionServlet", urlPatterns = {"/my-transactions"})
public class UserTransactionServlet extends HttpServlet {

    private UserService userService;
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);

            List<Transaction> transactions = transactionService.getTransactionsByUserId(userId);
            req.setAttribute("transactions", transactions);

        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải danh sách giao dịch: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/my-transactions.jsp").forward(req, resp);
    }
}

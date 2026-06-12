package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import model.SubscriptionPackage;
import model.Transaction;
import services.SubscriptionService;
import services.TransactionService;
import services.TransactionServiceImpl;
import util.SePayUtil;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private SubscriptionService subscriptionService;
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        subscriptionService = new SubscriptionService();
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String packageIdParam = req.getParameter("packageId");

        if (packageIdParam == null || packageIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/subscription.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(packageIdParam);
            SubscriptionPackage pkg = subscriptionService.getPackageById(packageId);

            if (pkg == null || Boolean.TRUE.equals(pkg.getDeleted())) {
                resp.sendRedirect(req.getContextPath() + "/jsp/subscription.jsp");
                return;
            }

            Transaction transaction = new Transaction();
            transaction.setUserId(userId);
            transaction.setSubscriptionPackage(pkg);
            transaction.setAmount(pkg.getPrice());
            transaction.setPaymentMethod("VietQR - SePay");
            transaction.setStatus("Pending");

            transactionService.createTransaction(transaction);

            String qrUrl = SePayUtil.generateQRUrl(transaction);
            
            req.setAttribute("transaction", transaction);
            req.setAttribute("qrUrl", qrUrl);
            req.setAttribute("pkg", pkg);
            
            req.setAttribute("bankAcc", System.getProperty("SEPAY_BANK_ACC", ""));
            req.setAttribute("bankName", System.getProperty("SEPAY_BANK_NAME", "Invalid Bank Name"));
            req.setAttribute("bankAccountName", System.getProperty("SEPAY_BANK_ACCOUNT_NAME", "Invalid Bank Account Name"));

            req.getRequestDispatcher("/jsp/checkout.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/jsp/subscription.jsp");
        }
    }
}

package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;

import model.Transaction;
import services.SubscriptionService;
import services.TransactionService;
import services.TransactionServiceImpl;

@WebServlet("/webhook/sepay")
public class SePayWebhookServlet extends HttpServlet {

    private TransactionService transactionService;
    private SubscriptionService subscriptionService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        transactionService = new TransactionServiceImpl();
        subscriptionService = new SubscriptionService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        
        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
        String rawBody = buffer.toString();
        
        try {
            JsonObject payload = gson.fromJson(rawBody, JsonObject.class);
            if (payload == null) {
                resp.getWriter().write("{\"success\": false}");
                return;
            }
            
            String content = payload.has("content") && !payload.get("content").isJsonNull() ? payload.get("content").getAsString() : "";
            int transferAmount = payload.has("transferAmount") ? payload.get("transferAmount").getAsInt() : 0;
            String gatewayTxId = payload.has("id") ? payload.get("id").getAsString() : "";
            
            if (transactionService.isGatewayTransactionProcessed(gatewayTxId)) {
                resp.getWriter().write("{\"success\": true}");
                return;
            }
            
            int transactionId = -1;
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("IF(\\d+)");
            java.util.regex.Matcher matcher = pattern.matcher(content.toUpperCase());
            if (matcher.find()) {
                transactionId = Integer.parseInt(matcher.group(1));
            }
            
            if (transactionId != -1) {
                Transaction t = transactionService.getTransactionById(transactionId);
                if (t != null && "Pending".equals(t.getStatus())) {
                    if (t.getAmount().intValue() <= transferAmount) {
                        transactionService.updateTransactionStatus(transactionId, "Success", gatewayTxId, rawBody);
                        subscriptionService.processSuccessfulTransaction(t);
                    } else {
                        transactionService.updateTransactionStatus(transactionId, "Failed", gatewayTxId, rawBody);
                    }
                }
            }
            
            resp.getWriter().write("{\"success\": true}");
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false}");
        }
    }
}

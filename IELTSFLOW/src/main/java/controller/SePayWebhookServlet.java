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
            System.out.println("SePay Webhook RAW: " + rawBody);
            JsonObject payload = gson.fromJson(rawBody, JsonObject.class);
            if (payload == null) {
                System.out.println("SePay Webhook: Payload is null.");
                resp.getWriter().write("{\"success\": false}");
                return;
            }
            
            String content = payload.has("content") && !payload.get("content").isJsonNull() ? payload.get("content").getAsString() : "";
            String code = payload.has("code") && !payload.get("code").isJsonNull() ? payload.get("code").getAsString() : "";
            int transferAmount = payload.has("transferAmount") ? payload.get("transferAmount").getAsInt() : 0;
            String gatewayTxId = payload.has("id") ? payload.get("id").getAsString() : "";
            String transferType = payload.has("transferType") && !payload.get("transferType").isJsonNull() ? payload.get("transferType").getAsString() : "in";
            
            System.out.println("SePay Webhook parsed - Code: " + code + ", Content: " + content + ", Amount: " + transferAmount + ", GatewayTxId: " + gatewayTxId);
            
            if (!"in".equalsIgnoreCase(transferType)) {
                System.out.println("SePay Webhook: Ignored because transferType is not 'in'");
                resp.getWriter().write("{\"success\": true}");
                return;
            }

            if (transactionService.isGatewayTransactionProcessed(gatewayTxId)) {
                System.out.println("SePay Webhook: GatewayTxId " + gatewayTxId + " already processed.");
                resp.getWriter().write("{\"success\": true}");
                return;
            }
            
            int transactionId = -1;
            if (code != null && code.toUpperCase().startsWith("IF")) {
                try {
                    transactionId = Integer.parseInt(code.substring(2));
                } catch (NumberFormatException e) {}
            }
            
            if (transactionId == -1) {
                java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\bIF(\\d+)\\b");
                java.util.regex.Matcher matcher = pattern.matcher(content.toUpperCase());
                if (matcher.find()) {
                    transactionId = Integer.parseInt(matcher.group(1));
                }
            }
            
            System.out.println("SePay Webhook: Parsed Transaction ID: " + transactionId);
            
            if (transactionId != -1) {
                Transaction t = transactionService.getTransactionById(transactionId);
                if (t != null) {
                    System.out.println("SePay Webhook: Found DB Transaction " + transactionId + " with status " + t.getStatus());
                    if ("Pending".equals(t.getStatus())) {
                        if (t.getAmount().intValue() <= transferAmount) {
                            System.out.println("SePay Webhook: Amount OK. Updating to Success.");
                            transactionService.updateTransactionStatus(transactionId, "Success", gatewayTxId, rawBody);
                            subscriptionService.processSuccessfulTransaction(t);
                        } else {
                            System.out.println("SePay Webhook: Underpaid. Expected " + t.getAmount().intValue() + ", got " + transferAmount);
                            transactionService.updateTransactionStatus(transactionId, "Failed", gatewayTxId, rawBody);
                        }
                    }
                } else {
                    System.out.println("SePay Webhook: DB Transaction not found for ID " + transactionId);
                }
            }
            
            resp.getWriter().write("{\"success\": true}");
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false}");
        }
    }
}

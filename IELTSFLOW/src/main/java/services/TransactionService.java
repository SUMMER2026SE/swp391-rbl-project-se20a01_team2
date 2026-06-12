package services;

import model.Transaction;
import java.util.List;

public interface TransactionService {
    void createTransaction(Transaction transaction);
    void updateTransaction(Transaction transaction);
    Transaction getTransactionById(int id);
    List<Transaction> getTransactionsByStatus(String status);
    List<Transaction> getAllTransactions();
    void updateTransactionStatus(int transactionId, String status, String gatewayTxId, String payload);
    boolean isGatewayTransactionProcessed(String gatewayTxId);
    void expireOldTransactions(int hours);
}

package services;

import model.Transaction;
import java.util.List;

public interface TransactionService {
    List<Transaction> getTransactionsByStatus(String status);
    List<Transaction> getAllTransactions();
}

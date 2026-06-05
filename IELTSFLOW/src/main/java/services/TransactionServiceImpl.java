package services;

import dao.TransactionDAO;
import model.Transaction;
import services.TransactionService;

import java.util.List;

public class TransactionServiceImpl implements TransactionService {
    private TransactionDAO transactionDAO;

    public TransactionServiceImpl() {
        this.transactionDAO = new TransactionDAO();
    }

    @Override
    public List<Transaction> getTransactionsByStatus(String status) {
        return transactionDAO.getTransactionsByStatus(status);
    }

    @Override
    public List<Transaction> getAllTransactions() {
        return transactionDAO.getAllTransactions();
    }
}

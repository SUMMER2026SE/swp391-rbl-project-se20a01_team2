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
    public void createTransaction(Transaction transaction) {
        transactionDAO.createTransaction(transaction);
    }

    @Override
    public void updateTransaction(Transaction transaction) {
        transactionDAO.updateTransaction(transaction);
    }

    @Override
    public Transaction getTransactionById(int id) {
        return transactionDAO.getTransactionById(id);
    }

    @Override
    public List<Transaction> getTransactionsByStatus(String status) {
        return transactionDAO.getTransactionsByStatus(status);
    }

    @Override
    public List<Transaction> getAllTransactions() {
        return transactionDAO.getAllTransactions();
    }

    @Override
    public void updateTransactionStatus(int transactionId, String status, String gatewayTxId, String payload) {
        transactionDAO.updateTransactionStatus(transactionId, status, gatewayTxId, payload);
    }

    @Override
    public boolean isGatewayTransactionProcessed(String gatewayTxId) {
        return transactionDAO.isGatewayTransactionProcessed(gatewayTxId);
    }

    @Override
    public void expireOldTransactions(int hours) {
        transactionDAO.expireOldTransactions(hours);
    }

    @Override
    public List<Transaction> getTransactionsByUserId(int userId) {
        return transactionDAO.getTransactionsByUserId(userId);
    }
}

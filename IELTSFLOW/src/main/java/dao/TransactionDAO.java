/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ntpho
 */

import model.Transaction;
import util.JpaHelper;
import java.util.List;

public class TransactionDAO {
    
    // Lưu giao dịch mới
    public void createTransaction(Transaction transaction) {
        JpaHelper.execute(em -> em.persist(transaction));
    }
    
    // Cập nhật trạng thái giao dịch
    public void updateTransaction(Transaction transaction) {
        JpaHelper.execute(em -> em.merge(transaction));
    }
    
    public Transaction getTransactionById(int id) {
        return JpaHelper.query(em -> em.find(Transaction.class, id));
    }
    
    // Lấy toàn bộ lịch sử giao dịch
    public List<Transaction> getAllTransactions() {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT t FROM Transaction t ORDER BY t.createdAt DESC", Transaction.class).getResultList()
        );
    }

    // Lọc giao dịch theo trạng thái (Success, Pending, Failed)
    public List<Transaction> getTransactionsByStatus(String status) {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT t FROM Transaction t WHERE t.status = :status ORDER BY t.createdAt DESC", Transaction.class)
              .setParameter("status", status)
              .getResultList()
        );
    }

    public void updateTransactionStatus(int transactionId, String status, String gatewayTxId, String payload) {
        JpaHelper.execute(em -> {
            Transaction t = em.find(Transaction.class, transactionId);
            if (t != null) {
                t.setStatus(status);
                t.setGatewayTransactionId(gatewayTxId);
                t.setGatewayPayload(payload);
                if ("Success".equalsIgnoreCase(status)) {
                    t.setPaymentDate(new java.util.Date());
                }
                em.merge(t);
            }
        });
    }

    public boolean isGatewayTransactionProcessed(String gatewayTxId) {
        if (gatewayTxId == null || gatewayTxId.trim().isEmpty()) {
            return false;
        }
        return JpaHelper.query(em -> {
            Long count = em.createQuery("SELECT COUNT(t) FROM Transaction t WHERE t.gatewayTransactionId = :txId", Long.class)
                           .setParameter("txId", gatewayTxId)
                           .getSingleResult();
            return count != null && count > 0;
        });
    }

    public void expireOldTransactions(int hours) {
        JpaHelper.execute(em -> {
            em.createQuery("UPDATE Transaction t SET t.status = 'Failed/Cancelled' WHERE t.status = 'Pending' AND t.createdAt < :cutoff")
              .setParameter("cutoff", new java.util.Date(System.currentTimeMillis() - (hours * 3600000L)))
              .executeUpdate();
        });
    }

    public List<Transaction> getTransactionsByUserId(int userId) {
        return JpaHelper.query(em -> 
            em.createQuery("SELECT t FROM Transaction t WHERE t.userId = :userId ORDER BY t.createdAt DESC", Transaction.class)
              .setParameter("userId", userId)
              .getResultList()
        );
    }
}
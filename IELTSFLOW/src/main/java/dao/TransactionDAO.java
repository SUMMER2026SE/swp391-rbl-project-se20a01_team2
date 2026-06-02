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
}
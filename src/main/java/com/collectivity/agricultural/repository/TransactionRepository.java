package com.collectivity.agricultural.repository;

import com.collectivity.agricultural.model.Transaction;
import com.collectivity.agricultural.model.Transaction;
import com.collectivity.agricultural.model.enums.PaymentMode;
import com.collectivity.agricultural.model.enums.TransactionType;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
@AllArgsConstructor
public class TransactionRepository {
    private final Connection connection;

    public void saveTransaction(Transaction transaction) {
        String sql = """
            INSERT INTO "transaction" 
            (id_member, id_collectivity, id_cotisation_plan, id_account, amount, payment_mode, description, transaction_type, transaction_date)
            VALUES (?, ?, ?, ?, ?, ?::payment_mode, ?, 'IN', now())
        """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, transaction.getMemberId());
            stmt.setInt(2, transaction.getCollectivityId());

            if (transaction.getCotisationPlanId() != null) {
                stmt.setInt(3, transaction.getCotisationPlanId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setInt(4, transaction.getAccountId());
            stmt.setBigDecimal(5, transaction.getAmount());
            stmt.setString(6, transaction.getPaymentMode().toString());
            stmt.setString(7, transaction.getDescription());

            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'enregistrement du paiement", e);
        }

    }
    public List<Transaction> findAllByCollectivityId(Integer collectivityId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = """
        SELECT 
            t.id, 
            t.id_member, 
            t.id_account, 
            t.amount, 
            t.type, 
            t.mode, 
            t.transaction_date, 
            t.label 
        FROM "transaction" t
        JOIN "account" a ON t.id_account = a.id
        WHERE a.id_collectivity = ? 
        ORDER BY t.transaction_date DESC
    """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, collectivityId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(Transaction.builder()
                            .id(String.valueOf(rs.getString("id")))
                            .memberId(rs.getInt("id_member"))
                            .collectivityId(rs.getInt("id_collectivity"))
                            .cotisationPlanId(rs.getObject("id_cotisation_plan") != null ? rs.getInt("id_cotisation_plan") : null)
                            .accountId(rs.getInt("id_account"))
                            .amount(rs.getBigDecimal("amount"))
                            .paymentMode(PaymentMode.valueOf(rs.getString("payment_mode")))
                            .transactionType(TransactionType.valueOf(rs.getString("transaction_type")))
                            .description(rs.getString("description"))
                            .transactionDate(rs.getTimestamp("transaction_date"))
                            .build());
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des transactions", e);
        }
        return transactions;
    }
    public List<Transaction> findTransactionsByPeriod(Integer id, String from, String to) {
        List<Transaction> transactions = new ArrayList<>();
        // Requête SQL filtrant par collectivité ET par période
        String sql = """
        SELECT 
            t.id, 
            t.id_member, 
            t.id_account, 
            t.amount, 
            t.type, 
            t.mode, 
            t.transaction_date, 
            t.label 
        FROM "transaction" t
        JOIN "account" a ON t.id_account = a.id
        WHERE a.id_collectivity = ? 
        AND t.transaction_date BETWEEN ?::date AND ?::date 
        ORDER BY t.transaction_date DESC
    """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setString(2, from); // "2026-01-01"
            stmt.setString(3, to);   // "2026-12-31"

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(Transaction.builder()
                            .id(String.valueOf(rs.getString("id")))
                            .memberId(rs.getInt("id_member"))
                            .collectivityId(rs.getInt("id_collectivity"))
                            .amount(rs.getBigDecimal("amount"))
                            .description(rs.getString("description"))
                            .transactionDate(rs.getTimestamp("transaction_date"))
                            .build());
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur SQL lors de la recherche par période", e);
        }
        return transactions;
    }
}
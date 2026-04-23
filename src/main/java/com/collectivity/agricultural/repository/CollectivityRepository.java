package com.collectivity.agricultural.repository;

import com.collectivity.agricultural.model.Collectivity;
import com.collectivity.agricultural.model.FinancialAccount;
import com.collectivity.agricultural.model.Member;
import com.collectivity.agricultural.model.Structure;
import com.collectivity.agricultural.model.enums.CollectivityOccupation;
import com.collectivity.agricultural.model.enums.Gender;
import com.collectivity.agricultural.model.enums.PaymentMode;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.Date;

@Repository
@AllArgsConstructor
public class CollectivityRepository {
    private final Connection connection;

    // --- SAUVEGARDE ---

    public Collectivity save(Collectivity collectivity, List<Integer> memberIds,
                             Integer presidentId, Integer vicePresidentId,
                             Integer treasurerId, Integer secretaryId) {
        String insertCollectivitySql = """
            insert into collectivity (number, name, speciality, federation_approval, authorization_date, location, id_federation, creation_datetime)
            values (?, ?, ?, ?, ?, ?, 1, now())
            returning id
        """;

        String insertMemberSql = """
            insert into member_collectivity (id_member, id_collectivity, occupation, start_date)
            values (?, ?, ?, ?)
        """;

        try {
            connection.setAutoCommit(false);
            int collectivityId;
            try (PreparedStatement stmt = connection.prepareStatement(insertCollectivitySql)) {
                // Utilisation directe du String (compatible UUID ou numérique)
                stmt.setString(1, collectivity.getNumber());
                stmt.setString(2, collectivity.getName());
                stmt.setString(3, collectivity.getSpeciality());
                stmt.setBoolean(4, collectivity.isFederationApproval());
                stmt.setTimestamp(5, collectivity.getAuthorizationDate() != null ?
                        Timestamp.from(collectivity.getAuthorizationDate().toInstant()) : null);
                stmt.setString(6, collectivity.getLocation());

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    collectivityId = rs.getInt("id");
                } else {
                    throw new SQLException("Failed to insert collectivity");
                }
            }

            try (PreparedStatement memberStmt = connection.prepareStatement(insertMemberSql)) {
                Timestamp now = Timestamp.from(Instant.now());
                for (Integer memberId : memberIds) {
                    memberStmt.setInt(1, memberId);
                    memberStmt.setInt(2, collectivityId);
                    memberStmt.setString(3, determineOccupation(memberId, presidentId, vicePresidentId, treasurerId, secretaryId));
                    memberStmt.setTimestamp(4, now);
                    memberStmt.addBatch();
                }
                memberStmt.executeBatch();
            }
            connection.commit();
            return findById(collectivityId);
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { /* ignored */ }
            throw new RuntimeException(e);
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { /* ignored */ }
        }
    }

    public List<Collectivity> saveAll(List<Collectivity> collectivities,
                                      List<List<Integer>> memberIdsList,
                                      List<Integer> presidentIds,
                                      List<Integer> vicePresidentIds,
                                      List<Integer> treasurerIds,
                                      List<Integer> secretaryIds) {
        List<Collectivity> savedCollectivities = new ArrayList<>();
        for (int i = 0; i < collectivities.size(); i++) {
            savedCollectivities.add(save(
                    collectivities.get(i),
                    memberIdsList.get(i),
                    presidentIds.get(i),
                    vicePresidentIds.get(i),
                    treasurerIds.get(i),
                    secretaryIds.get(i)
            ));
        }
        return savedCollectivities;
    }

    // --- RECHERCHE ET LECTURE ---

    public Collectivity findById(Integer id) {
        String sql = "SELECT * FROM \"collectivity\" WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Collectivity collectivity = Collectivity.builder()
                            .id(rs.getInt("id"))
                            .name(rs.getString("name"))
                            .number(rs.getString("number")) // Récupération propre du String
                            .location(rs.getString("location"))
                            .speciality(rs.getString("speciality"))
                            .federationApproval(rs.getBoolean("federation_approval"))
                            .authorizationDate(rs.getTimestamp("authorization_date") != null ?
                                    Date.from(rs.getTimestamp("authorization_date").toInstant()) : null)
                            .build();

                    fetchMembersAndStructure(collectivity);
                    return collectivity;
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    private void fetchMembersAndStructure(Collectivity collectivity) {
        String sql = """
            select m.*, mc.occupation from member_collectivity mc
            join member m on mc.id_member = m.id
            where mc.id_collectivity = ? AND mc.end_date is null
        """;
        List<Member> members = new ArrayList<>();
        Structure structure = Structure.builder().build();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, collectivity.getId());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Member member = Member.builder()
                        .id(rs.getInt("id"))
                        .firstName(rs.getString("first_name"))
                        .lastName(rs.getString("last_name"))
                        .gender(Gender.valueOf(rs.getString("gender")))
                        .build();
                members.add(member);

                String occ = rs.getString("occupation");
                if (occ != null) {
                    switch (CollectivityOccupation.valueOf(occ)) {
                        case PRESIDENT -> structure.setPresident(member);
                        case VICE_PRESIDENT -> structure.setVicePresident(member);
                        case TREASURER -> structure.setTreasurer(member);
                        case SECRETARY -> structure.setSecretary(member);
                    }
                }
            }
            collectivity.setMembers(members);
            collectivity.setStructure(structure);
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public List<FinancialAccount> findAccountsWithBalance(Integer collectivityId, String atDate) {
        List<FinancialAccount> accounts = new ArrayList<>();
        String sql = """
            SELECT a.id, a.label, a.type,
            COALESCE(SUM(CASE WHEN t.transaction_type = 'IN' THEN t.amount ELSE -t.amount END), 0) as balance
            FROM account a
            LEFT JOIN "transaction" t ON a.id = t.id_account AND t.transaction_date <= ?::timestamp
            WHERE a.id_collectivity = ?
            GROUP BY a.id, a.label, a.type
        """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, atDate + " 23:59:59");
            stmt.setInt(2, collectivityId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                accounts.add(FinancialAccount.builder()
                        .id(rs.getString("id"))
                        .label(rs.getString("label"))
                        .type(PaymentMode.valueOf(rs.getString("type")))
                        .balance(rs.getBigDecimal("balance"))
                        .build());
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return accounts;
    }

    // --- MISES À JOUR ET VÉRIFICATIONS ---

    public void updateIdentity(Integer id, String number, String name) {
        String sql = "UPDATE collectivity SET number = ?, name = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, number);
            stmt.setString(2, name);
            stmt.setInt(3, id);
            if (stmt.executeUpdate() == 0) throw new SQLException("Update failed");
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public boolean existsByName(String name) {
        String sql = "SELECT count(*) FROM collectivity WHERE name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private String determineOccupation(Integer memberId, Integer pres, Integer vice, Integer treas, Integer sec) {
        if (memberId.equals(pres)) return "PRESIDENT";
        if (memberId.equals(vice)) return "VICE_PRESIDENT";
        if (memberId.equals(treas)) return "TREASURER";
        if (memberId.equals(sec)) return "SECRETARY";
        return hasMinimumSeniority(memberId) ? "SENIOR" : "JUNIOR";
    }

    private boolean hasMinimumSeniority(Integer memberId) {
        String sql = "select enrolment_date from member where id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Timestamp enrolmentDate = rs.getTimestamp("enrolment_date");
                return ChronoUnit.MONTHS.between(enrolmentDate.toLocalDateTime(), LocalDateTime.now()) >= 6;
            }
            return false;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
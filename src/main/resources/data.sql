-- ==========================================================
-- SCRIPT D'INSERTION DES DONNÉES - TD FÉDÉRATION AGRICOLE
-- ==========================================================

-- 1. COLLECTIVITÉS (Tableau 1) [cite: 364]
INSERT INTO collectivity (id, number, name, location, speciality, creation_datetime) VALUES
                                                                                         ('col-1', '1', 'Mpanorina', 'Ambatondrazaka', 'Riziculture', '2026-01-01 08:00:00'),
                                                                                         ('col-2', '2', 'Dobo voalohany', 'Ambatondrazaka', 'Pisciculture', '2026-01-01 08:00:00'),
                                                                                         ('col-3', '3', 'Tantely mamy', 'Brickaville', 'Apiculture', '2026-01-01 08:00:00');

-- 2. MEMBRES (Tableaux 2, 3 et 4) [cite: 365, 374, 383]
-- Note: Les membres C1-M1 à C1-M8 sont partagés entre col-1 et col-2 selon le document.
INSERT INTO member (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email) VALUES
                                                                                                                 ('C1-M1', 'Prénom membre 1', 'Nom membre 1', '1980-02-01', 'M', 'Lot II V M Ambato.', 'Riziculteur', '0341234567', 'member.1@fed-agri.mg'),
                                                                                                                 ('C1-M2', 'Prénom membre 2', 'Nom membre 2', '1982-03-05', 'M', 'Lot II F Ambato.', 'Agriculteur', '0321234567', 'member.2@fed-agri.mg'),
                                                                                                                 ('C1-M3', 'Prénom membre 3', 'Nom membre 3', '1992-03-10', 'M', 'Lot II J Ambato.', 'Collecteur', '0331234567', 'member.3@fed-agri.mg'),
                                                                                                                 ('C1-M4', 'Prénom membre 4', 'Nom membre 4', '1988-05-22', 'F', 'Lot A K 50 Ambato.', 'Distributeur', '0381234567', 'member.4@fed-agri.mg'),
                                                                                                                 ('C1-M5', 'Prénom membre 5', 'Nom membre 5', '1999-08-21', 'M', 'Lot UV 80 Ambato.', 'Riziculteur', '0373434567', 'member.5@fed-agri.mg'),
                                                                                                                 ('C1-M6', 'Prénom membre 6', 'Nom membre 6', '1998-08-22', 'F', 'Lot UV 6 Ambato.', 'Riziculteur', '0372234567', 'member.6@fed-agri.mg'),
                                                                                                                 ('C1-M7', 'Prénom membre 7', 'Nom membre 7', '1998-01-31', 'M', 'Lot UV 7 Ambato.', 'Riziculteur', '0374234567', 'member.7@fed-agri.mg'),
                                                                                                                 ('C1-M8', 'Prénom membre 6', 'Nom membre 8', '1975-08-20', 'M', 'Lot UV 8 Ambato.', 'Riziculteur', '0370234567', 'member.8@fed-agri.mg'),
                                                                                                                 ('C3-M1', 'Prénom membre 9', 'Nom membre 9', '1988-01-02', 'M', 'Lot 33 J Antsirabe', 'Apiculteur', '0340345670', 'member.9@fed-agri.mg'),
                                                                                                                 ('C3-M2', 'Prénom membre 10', 'Nom membre 10', '1982-03-05', 'M', 'Lot 2 J Antsirabe', 'Agriculteur', '0338634567', 'member.10@fed-agri.mg'),
                                                                                                                 ('C3-M3', 'Prénom membre 11', 'Nom membre 11', '1992-03-12', 'M', 'Lot 8 KM Antsirabe', 'Collecteur', '0338234567', 'member.11@fed-agri.mg'),
                                                                                                                 ('C3-M4', 'Prénom membre 12', 'Nom membre 12', '1988-05-10', 'F', 'Lot A K 50 Antsirabe', 'Distributeur', '0382334567', 'member.12@fed-agri.mg'),
                                                                                                                 ('C3-M5', 'Prénom membre 13', 'Nom membre 13', '1999-08-11', 'M', 'Lot UV 80 Antsirabe.', 'Apiculteur', '0373365567', 'member.13@fed-agri.mg'),
                                                                                                                 ('C3-M6', 'Prénom membre 14', 'Nom membre 14', '1998-08-09', 'F', 'Lot UV 6 Antsirabe.', 'Apiculteur', '0378234567', 'member.14@fed-agri.mg'),
                                                                                                                 ('C3-M7', 'Prénom membre 15', 'Nom membre 15', '1998-01-13', 'M', 'Lot UV 7 Antsirabe', 'Apiculteur', '0374914567', 'member.15@fed-agri.mg'),
                                                                                                                 ('C3-M8', 'Prénom membre 16', 'Nom membre 16', '1975-08-02', 'M', 'Lot UV 8 Antsirabe', 'Apiculteur', '0370634567', 'member.16@fed-agri.mg');

-- 3. AFFECTATIONS ET ROLES (Hiérarchie) [cite: 365, 374, 383]
INSERT INTO member_collectivity (id_member, id_collectivity, occupation) VALUES
                                                                             ('C1-M1', 'col-1', 'PRESIDENT'), ('C1-M2', 'col-1', 'VICE_PRESIDENT'), ('C1-M3', 'col-1', 'SECRETARY'), ('C1-M4', 'col-1', 'TREASURER'),
                                                                             ('C1-M5', 'col-1', 'MEMBRE_CONFIRME'), ('C1-M6', 'col-1', 'MEMBRE_CONFIRME'), ('C1-M7', 'col-1', 'MEMBRE_CONFIRME'), ('C1-M8', 'col-1', 'MEMBRE_CONFIRME'),
                                                                             ('C1-M1', 'col-2', 'MEMBRE_CONFIRME'), ('C1-M2', 'col-2', 'MEMBRE_CONFIRME'), ('C1-M3', 'col-2', 'MEMBRE_CONFIRME'), ('C1-M4', 'col-2', 'MEMBRE_CONFIRME'),
                                                                             ('C1-M5', 'col-2', 'PRESIDENT'), ('C1-M6', 'col-2', 'VICE_PRESIDENT'), ('C1-M7', 'col-2', 'SECRETARY'), ('C1-M8', 'col-2', 'TREASURER'),
                                                                             ('C3-M1', 'col-3', 'PRESIDENT'), ('C3-M2', 'col-3', 'VICE_PRESIDENT'), ('C3-M3', 'col-3', 'SECRETARY'), ('C3-M4', 'col-3', 'TREASURER'),
                                                                             ('C3-M5', 'col-3', 'MEMBRE_CONFIRME'), ('C3-M6', 'col-3', 'MEMBRE_CONFIRME'), ('C3-M7', 'col-3', 'MEMBRE_CONFIRME'), ('C3-M8', 'col-3', 'MEMBRE_CONFIRME');

-- 4. PARRAINAGES (Membres référents) [cite: 365, 383]
INSERT INTO sponsorship (id_candidate, id_sponsor, relation_type) VALUES
                                                                      ('C1-M3', 'C1-M1', 'Professionnel'), ('C1-M3', 'C1-M2', 'Professionnel'),
                                                                      ('C1-M4', 'C1-M1', 'Professionnel'), ('C1-M4', 'C1-M2', 'Professionnel'),
                                                                      ('C1-M8', 'C1-M6', 'Professionnel'), ('C1-M8', 'C1-M7', 'Professionnel'),
                                                                      ('C3-M1', 'C1-M1', 'Professionnel'), ('C3-M1', 'C1-M2', 'Professionnel'),
                                                                      ('C3-M3', 'C3-M1', 'Professionnel'), ('C3-M3', 'C3-M2', 'Professionnel');

-- 5. COTISATIONS (Tableaux 5, 6 et 7) [cite: 392, 393]
INSERT INTO membership_fee (id, id_collectivity, label, status, frequency, amount, eligible_since) VALUES
                                                                                                       ('cot-1', 'col-1', 'Cotisation annuelle', 'ACTIVE', 'ANNUALLY', 100000, '2026-01-01'),
                                                                                                       ('cot-2', 'col-2', 'Cotisation annuelle', 'ACTIVE', 'ANNUALLY', 100000, '2026-01-01'),
                                                                                                       ('cot-3', 'col-3', 'Cotisation annuelle', 'ACTIVE', 'ANNUALLY', 50000, '2026-01-01');

-- 6. COMPTES FINANCIERS (Données page 16) [cite: 394, 395]
INSERT INTO account (id, id_collectivity, account_type, balance, owner_name, phone_number) VALUES
                                                                                               ('C1-A-CASH', 'col-1', 'CASH', 0, '-', '-'),
                                                                                               ('C1-A-MOBILE-1', 'col-1', 'ORANGE_MONEY', 0, 'Mpanorina', '0370489612'),
                                                                                               ('C2-A-CASH', 'col-2', 'CASH', 0, '-', '-'),
                                                                                               ('C2-A-MOBILE-1', 'col-2', 'ORANGE_MONEY', 0, 'Dobo voalohany', '0320489612'),
                                                                                               ('C3-A-CASH', 'col-3', 'CASH', 0, '-', '-');

-- 7. PAIEMENTS ET TRANSACTIONS (Tableaux 8, 9, 10, 11) [cite: 396, 398, 399, 401]
-- Note: Le document indique que les paiements sont identiques aux transactions.
INSERT INTO "transaction" (id_member, id_collectivity, id_account, amount, payment_mode, transaction_type, transaction_date) VALUES
                                                                                                                                 ('C1-M1', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M2', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M3', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M4', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M5', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M6', 'col-1', 'C1-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M7', 'col-1', 'C1-A-CASH', 60000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M8', 'col-1', 'C1-A-CASH', 90000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M1', 'col-2', 'C2-A-CASH', 60000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M2', 'col-2', 'C2-A-CASH', 90000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M3', 'col-2', 'C2-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M4', 'col-2', 'C2-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M5', 'col-2', 'C2-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M6', 'col-2', 'C2-A-CASH', 100000, 'CASH', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M7', 'col-2', 'C2-A-MOBILE-1', 40000, 'MOBILE_MONEY', 'IN', '2026-01-01'),
                                                                                                                                 ('C1-M8', 'col-2', 'C2-A-MOBILE-1', 60000, 'MOBILE_MONEY', 'IN', '2026-01-01');
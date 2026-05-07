-- ============================================
-- COMPLETE DATABASE SCHEMA AND DATA FROM PDF ONLY (FIXED)
-- ============================================
-- ============================================
-- DATABASE INITIALIZATION SCRIPT
-- Drops all tables and recreates with PDF data
-- Run before tests
-- ============================================

-- Drop tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS activity_attendance CASCADE;
DROP TABLE IF EXISTS activity_member_occupation CASCADE;
DROP TABLE IF EXISTS activity CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;
DROP TABLE IF EXISTS cotisation_plan CASCADE;
DROP TABLE IF EXISTS mobile_money_account CASCADE;
DROP TABLE IF EXISTS bank_account CASCADE;
DROP TABLE IF EXISTS cash_account CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS member_referee CASCADE;
DROP TABLE IF EXISTS member_collectivity CASCADE;
DROP TABLE IF EXISTS member CASCADE;
DROP TABLE IF EXISTS collectivity CASCADE;
DROP TABLE IF EXISTS federation CASCADE;

-- Federation table
CREATE TABLE IF NOT EXISTS federation (
                                          id VARCHAR PRIMARY KEY DEFAULT 'fed-1',
                                          name VARCHAR NOT NULL DEFAULT 'Fédération Agricole de Madagascar',
                                          creation_date DATE DEFAULT CURRENT_DATE
);

-- Member table
CREATE TABLE IF NOT EXISTS member (
                                      id VARCHAR PRIMARY KEY,
                                      first_name VARCHAR NOT NULL,
                                      last_name VARCHAR NOT NULL,
                                      birth_date DATE NOT NULL,
                                      gender VARCHAR(10) CHECK (gender IN ('MALE', 'FEMALE')),
    address VARCHAR,
    profession VARCHAR,
    phone_number VARCHAR,
    email VARCHAR UNIQUE NOT NULL,
    enrolment_date DATE DEFAULT CURRENT_DATE,
    is_superuser BOOLEAN DEFAULT FALSE
    );

-- Member referee relationship
CREATE TABLE IF NOT EXISTS member_referee (
                                              id_candidate VARCHAR REFERENCES member(id),
    id_referee VARCHAR REFERENCES member(id),
    relationship VARCHAR,
    PRIMARY KEY (id_candidate, id_referee)
    );

-- Collectivity table
CREATE TABLE IF NOT EXISTS collectivity (
                                            id VARCHAR PRIMARY KEY,
                                            number VARCHAR UNIQUE,
                                            name VARCHAR UNIQUE,
                                            speciality VARCHAR NOT NULL,
                                            creation_date DATE DEFAULT CURRENT_DATE,
                                            federation_approval BOOLEAN NOT NULL,
                                            authorization_date DATE,
                                            location VARCHAR NOT NULL,
                                            id_federation VARCHAR REFERENCES federation(id)
    );

-- Member collectivity association
CREATE TABLE IF NOT EXISTS member_collectivity (
                                                   id_member VARCHAR REFERENCES member(id),
    id_collectivity VARCHAR REFERENCES collectivity(id),
    occupation VARCHAR CHECK (
                                 occupation IN ('JUNIOR', 'SENIOR', 'SECRETARY', 'TREASURER', 'VICE_PRESIDENT', 'PRESIDENT')
    ),
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    PRIMARY KEY (id_member, id_collectivity, start_date)
    );

-- Account table
CREATE TABLE IF NOT EXISTS account (
                                       id VARCHAR PRIMARY KEY,
                                       id_collectivity VARCHAR REFERENCES collectivity(id),
    id_federation VARCHAR REFERENCES federation(id),
    CHECK (id_collectivity IS NOT NULL OR id_federation IS NOT NULL)
    );

-- Cash account
CREATE TABLE IF NOT EXISTS cash_account (
                                            id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_account VARCHAR UNIQUE REFERENCES account(id)
    );

-- Bank account
CREATE TABLE IF NOT EXISTS bank_account (
                                            id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_account VARCHAR UNIQUE REFERENCES account(id),
    holder_name VARCHAR NOT NULL,
    bank_name VARCHAR CHECK (
                                bank_name IN ('BRED', 'MCB', 'BMOI', 'BOA', 'BGFI', 'AFG', 'ACCES_BANQUE', 'BAOBAB', 'SIPEM')
    ),
    bank_code VARCHAR(5),
    branch_code VARCHAR(5),
    account_number VARCHAR(11),
    rib_key VARCHAR(2)
    );

-- Mobile money account
CREATE TABLE IF NOT EXISTS mobile_money_account (
                                                    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_account VARCHAR UNIQUE REFERENCES account(id),
    holder_name VARCHAR NOT NULL,
    service_name VARCHAR CHECK (
                                   service_name IN ('ORANGE_MONEY', 'MVOLA', 'AIRTEL_MONEY')
    ),
    phone_number VARCHAR NOT NULL
    );

-- Cotisation plan
CREATE TABLE IF NOT EXISTS cotisation_plan (
                                               id VARCHAR PRIMARY KEY,
                                               label VARCHAR NOT NULL,
                                               id_collectivity VARCHAR REFERENCES collectivity(id),
    status VARCHAR DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    frequency VARCHAR CHECK (frequency IN ('WEEKLY', 'MONTHLY', 'ANNUALLY', 'PUNCTUALLY')),
    eligible_from DATE,
    amount DECIMAL(15,2)
    );

-- Transaction
CREATE TABLE IF NOT EXISTS transaction (
                                           id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_collectivity VARCHAR REFERENCES collectivity(id),
    id_member VARCHAR REFERENCES member(id),
    id_cotisation_plan VARCHAR REFERENCES cotisation_plan(id),
    transaction_type VARCHAR CHECK (transaction_type IN ('IN', 'OUT')),
    amount DECIMAL(15,2),
    transaction_date DATE DEFAULT CURRENT_DATE,
    payment_mode VARCHAR CHECK (
                                   payment_mode IN ('CASH', 'MOBILE_BANKING', 'BANK_TRANSFER')
    ),
    description VARCHAR,
    id_account VARCHAR REFERENCES account(id)
    );

-- Activity table
CREATE TABLE IF NOT EXISTS activity (
                                        id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_collectivity VARCHAR REFERENCES collectivity(id),
    label VARCHAR NOT NULL,
    activity_type VARCHAR CHECK (activity_type IN ('MEETING', 'TRAINING', 'OTHER')),
    executive_date DATE,
    week_ordinal INTEGER CHECK (week_ordinal BETWEEN 1 AND 5),
    day_of_week VARCHAR CHECK (
                                  day_of_week IN ('MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU')
    ),
    creation_date DATE DEFAULT CURRENT_DATE
    );

-- Activity member occupation
CREATE TABLE IF NOT EXISTS activity_member_occupation (
                                                          id_activity VARCHAR REFERENCES activity(id),
    occupation VARCHAR CHECK (
                                 occupation IN ('JUNIOR', 'SENIOR', 'SECRETARY', 'TREASURER', 'VICE_PRESIDENT', 'PRESIDENT')
    ),
    PRIMARY KEY (id_activity, occupation)
    );

-- Activity attendance
CREATE TABLE IF NOT EXISTS activity_attendance (
                                                   id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::VARCHAR,
    id_activity VARCHAR REFERENCES activity(id),
    id_member VARCHAR REFERENCES member(id),
    attendance_status VARCHAR DEFAULT 'UNDEFINED' CHECK (
                                                            attendance_status IN ('UNDEFINED', 'ATTENDED', 'MISSING')
    ),
    UNIQUE (id_activity, id_member)
    );

-- ============================================================
-- DONNÉES DE TEST — Évaluation 6 Mai 2026
-- ============================================================

-- ============================================================
-- COLLECTIVITÉS (Tableau 1)
-- ============================================================
INSERT INTO collectivities (id, number, name, location, specialty, creation_date)
VALUES
    ('col-1', '1', 'Mpanorina',      'Ambatondrazaka', 'Riziculture',  NOW()),
    ('col-2', '2', 'Dobo voalohany', 'Ambatondrazaka', 'Pisciculture', NOW()),
    ('col-3', '3', 'Tantely mamy',   'Brickaville',    'Apiculture',   NOW());

-- ============================================================
-- MEMBRES (Tableaux 2, 3, 4)
-- ============================================================
INSERT INTO members (id, last_name, first_name, birth_date, gender, address, profession, phone, email)
VALUES
    ('C1-M1', 'Nom membre 1',  'Prénom membre 1',  '1980-02-01', 'MALE',   'Lot II V M Ambato.',   'Riziculteur', '0341234567', 'member.1@fed-agri.mg'),
    ('C1-M2', 'Nom membre 2',  'Prénom membre 2',  '1982-03-05', 'MALE',   'Lot II F Ambato.',     'Agriculteur', '0321234567', 'member.2@fed-agri.mg'),
    ('C1-M3', 'Nom membre 3',  'Prénom membre 3',  '1992-03-10', 'MALE',   'Lot II J Ambato.',     'Collecteur',  '0331234567', 'member.3@fed-agri.mg'),
    ('C1-M4', 'Nom membre 4',  'Prénom membre 4',  '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.',   'Distributeur','0381234567', 'member.4@fed-agri.mg'),
    ('C1-M5', 'Nom membre 5',  'Prénom membre 5',  '1999-08-21', 'MALE',   'Lot UV 80 Ambato.',    'Riziculteur', '0373434567', 'member.5@fed-agri.mg'),
    ('C1-M6', 'Nom membre 6',  'Prénom membre 6',  '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.',     'Riziculteur', '0372234567', 'member.6@fed-agri.mg'),
    ('C1-M7', 'Nom membre 7',  'Prénom membre 7',  '1998-01-31', 'MALE',   'Lot UV 7 Ambato.',     'Riziculteur', '0374234567', 'member.7@fed-agri.mg'),
    ('C1-M8', 'Nom membre 8',  'Prénom membre 8',  '1975-08-20', 'MALE',   'Lot UV 8 Ambato.',     'Riziculteur', '0370234567', 'member.8@fed-agri.mg'),
    ('C3-M1', 'Nom membre 9',  'Prénom membre 9',  '1988-01-02', 'MALE',   'Lot 33 J Antsirabe',   'Apiculteur',  '034034567',  'member.9@fed-agri.mg'),
    ('C3-M2', 'Nom membre 10', 'Prénom membre 10', '1982-03-05', 'MALE',   'Lot 2 J Antsirabe',    'Agriculteur', '0338634567', 'member.10@fed-agri.mg'),
    ('C3-M3', 'Nom membre 11', 'Prénom membre 11', '1992-03-12', 'MALE',   'Lot 8 KM Antsirabe',   'Collecteur',  '0338234567', 'member.11@fed-agri.mg'),
    ('C3-M4', 'Nom membre 12', 'Prénom membre 12', '1988-05-10', 'FEMALE', 'Lot A K 50 Antsirabe', 'Distributeur','0382334567', 'member.12@fed-agri.mg'),
    ('C3-M5', 'Nom membre 13', 'Prénom membre 13', '1999-08-11', 'MALE',   'Lot UV 80 Antsirabe',  'Apiculteur',  '0373365567', 'member.13@fed-agri.mg'),
    ('C3-M6', 'Nom membre 14', 'Prénom membre 14', '1998-08-09', 'FEMALE', 'Lot UV 6 Antsirabe',   'Apiculteur',  '0378234567', 'member.14@fed-agri.mg'),
    ('C3-M7', 'Nom membre 15', 'Prénom membre 15', '1998-01-13', 'MALE',   'Lot UV 7 Antsirabe',   'Apiculteur',  '0374914567', 'member.15@fed-agri.mg'),
    ('C3-M8', 'Nom membre 16', 'Prénom membre 16', '1975-08-02', 'MALE',   'Lot UV 8 Antsirabe',   'Apiculteur',  '0370634567', 'member.16@fed-agri.mg');

-- ============================================================
-- MEMBERSHIPS — start_date à 01/01/2026 pour tous les anciens
-- ============================================================

-- Collectivité 1
INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C1-M1', 'col-1', 'PRESIDENT',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M2', 'col-1', 'VICE_PRESIDENT', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M3', 'col-1', 'SECRETARY',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M4', 'col-1', 'TREASURER',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M5', 'col-1', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M6', 'col-1', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M7', 'col-1', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M8', 'col-1', 'SENIOR',         '2026-01-01');

-- Collectivité 2
INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C1-M1', 'col-2', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M2', 'col-2', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M3', 'col-2', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M4', 'col-2', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M5', 'col-2', 'PRESIDENT',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M6', 'col-2', 'VICE_PRESIDENT', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M7', 'col-2', 'SECRETARY',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M8', 'col-2', 'TREASURER',      '2026-01-01');

-- Collectivité 3
INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C3-M1', 'col-3', 'PRESIDENT',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M2', 'col-3', 'VICE_PRESIDENT', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M3', 'col-3', 'SECRETARY',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M4', 'col-3', 'TREASURER',      '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M5', 'col-3', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M6', 'col-3', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M7', 'col-3', 'SENIOR',         '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M8', 'col-3', 'SENIOR',         '2026-01-01');

-- ============================================================
-- REFERALS
-- ============================================================
INSERT INTO referals (id, member_id, referee_id) VALUES
                                                     (gen_random_uuid()::VARCHAR, 'C1-M3', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M3', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M4', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M4', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M5', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M5', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M6', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M6', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M7', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M7', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M8', 'C1-M6'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-M8', 'C1-M7'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M3', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M3', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M4', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M4', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M5', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M5', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M6', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M6', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M7', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M7', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M8', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-M8', 'C3-M2');

-- ============================================================
-- COMPTES FINANCIERS
-- ============================================================

-- Collectivité 1
INSERT INTO accounts (id, collectivity_id, type, balance, holder_name, mobile_banking_service, mobile_number)
VALUES
    ('C1-A-CASH',     'col-1', 'CASH',         0, NULL,        NULL,           NULL),
    ('C1-A-MOBILE-1', 'col-1', 'MOBILE_MONEY', 0, 'Mpanorina', 'ORANGE_MONEY', '0370489612');

-- Collectivité 2
INSERT INTO accounts (id, collectivity_id, type, balance, holder_name, mobile_banking_service, mobile_number)
VALUES
    ('C2-A-CASH',     'col-2', 'CASH',         0, NULL,              NULL,           NULL),
    ('C2-A-MOBILE-1', 'col-2', 'MOBILE_MONEY', 0, 'Dobo voalohany', 'ORANGE_MONEY', '0320489612');

-- Collectivité 3 — caisse existante
INSERT INTO accounts (id, collectivity_id, type, balance)
VALUES ('C3-A-CASH', 'col-3', 'CASH', 0);

-- Collectivité 3 — comptes bancaires (BMOI et BRED)
INSERT INTO accounts (id, collectivity_id, type, balance, holder_name, bank_name, bank_account_number)
VALUES
    ('C3-A-BANK-1', 'col-3', 'BANK', 0, 'Koto',  'BMOI', '0000400001123456789012'),
    ('C3-A-BANK-2', 'col-3', 'BANK', 0, 'Naivo', 'BRED', '0000800003456789012358');

-- Collectivité 3 — compte mobile money (MVOLA)
INSERT INTO accounts (id, collectivity_id, type, balance, holder_name, mobile_banking_service, mobile_number)
VALUES ('C3-A-MOBILE-1', 'col-3', 'MOBILE_MONEY', 0, 'Kolo', 'MVOLA', '0341889612');

-- ============================================================
-- COTISATIONS (Tableaux 12, 13, 14)
-- ============================================================

-- col-1
INSERT INTO fees (id, collectivity_id, eligible_from, amount, label, frequency, status)
VALUES
    ('cot-1', 'col-1', '2026-01-01', 200000.00, 'Cotisation annuelle', 'ANNUALLY',   'ACTIVE'),
    ('cot-2', 'col-1', '2026-04-30', 20000.00,  'Famangiana',          'PUNCTUALLY', 'ACTIVE');

-- col-2
INSERT INTO fees (id, collectivity_id, eligible_from, amount, label, frequency, status)
VALUES
    ('cot-3', 'col-2', '2026-01-01', 200000.00, 'Cotisation annuelle', 'ANNUALLY', 'ACTIVE'),
    ('cot-4', 'col-2', '2025-01-01', 100000.00, 'Cotisation 2025',     'ANNUALLY', 'INACTIVE');

-- col-3
INSERT INTO fees (id, collectivity_id, eligible_from, amount, label, frequency, status)
VALUES
    ('cot-5', 'col-3', '2026-04-01', 25000.00, 'Cotisation mensuelle', 'MONTHLY', 'ACTIVE');

-- ============================================================
-- PAIEMENTS (Tableaux 15, 16, 17)
-- ============================================================

-- col-1 (Tableau 15)
-- C1-M1 et C1-M2 : CASH | C1-M3 et C1-M4 : MOBILE_MONEY (01/01/2026)
-- C1-M5 : paiement partiel 150 000 (pas 200 000) | C1-M6, M7, M8 : CASH (01/05/2026)
INSERT INTO payments (id, member_id, amount, membership_fee_id, credited_account_id, payment_method, creation_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C1-M1', 200000, 'cot-1', 'C1-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M2', 200000, 'cot-1', 'C1-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M3', 200000, 'cot-1', 'C1-A-MOBILE-1', 'MOBILE_BANKING', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M4', 200000, 'cot-1', 'C1-A-MOBILE-1', 'MOBILE_BANKING', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M5', 150000, 'cot-1', 'C1-A-MOBILE-1', 'MOBILE_BANKING', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M6', 100000, 'cot-1', 'C1-A-CASH',     'CASH',           '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M7', 60000,  'cot-1', 'C1-A-CASH',     'CASH',           '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M8', 90000,  'cot-1', 'C1-A-CASH',     'CASH',           '2026-05-01');

-- Soldes col-1 :
--   CASH     : 200k + 200k + 100k + 60k + 90k = 650 000  ✓
--   MOBILE-1 : 200k + 200k + 150k             = 550 000  ✓
UPDATE accounts SET balance = 650000 WHERE id = 'C1-A-CASH';
UPDATE accounts SET balance = 550000 WHERE id = 'C1-A-MOBILE-1';

-- col-2 (Tableau 16)
INSERT INTO payments (id, member_id, amount, membership_fee_id, credited_account_id, payment_method, creation_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C1-M1', 120000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M2', 180000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M3', 200000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M4', 200000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M5', 200000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M6', 200000, 'cot-3', 'C2-A-CASH',     'CASH',           '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M7', 80000,  'cot-3', 'C2-A-MOBILE-1', 'MOBILE_BANKING', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C1-M8', 120000, 'cot-3', 'C2-A-MOBILE-1', 'MOBILE_BANKING', '2026-01-01');

-- Soldes col-2 :
--   CASH     : 120k + 180k + 200k + 200k + 200k + 200k = 1 100 000  ✓
--   MOBILE-1 : 80k + 120k                               = 200 000    ✓
UPDATE accounts SET balance = 1100000 WHERE id = 'C2-A-CASH';
UPDATE accounts SET balance = 200000  WHERE id = 'C2-A-MOBILE-1';

-- col-3 (Tableau 17)
INSERT INTO payments (id, member_id, amount, membership_fee_id, credited_account_id, payment_method, creation_date)
VALUES
    -- Avril
    (gen_random_uuid()::VARCHAR, 'C3-M1', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M2', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M3', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M4', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M5', 25000, 'cot-5', 'C3-A-BANK-2',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M6', 25000, 'cot-5', 'C3-A-BANK-2',   'BANK_TRANSFER', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M7', 25000, 'cot-5', 'C3-A-CASH',     'CASH',          '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M8', 25000, 'cot-5', 'C3-A-CASH',     'CASH',          '2026-04-01'),
    -- Mai
    (gen_random_uuid()::VARCHAR, 'C3-M1', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M2', 25000, 'cot-5', 'C3-A-BANK-1',   'BANK_TRANSFER', '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M3', 15000, 'cot-5', 'C3-A-MOBILE-1', 'MOBILE_BANKING','2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M4', 15000, 'cot-5', 'C3-A-MOBILE-1', 'MOBILE_BANKING','2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M5', 20000, 'cot-5', 'C3-A-BANK-2',   'BANK_TRANSFER', '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M6', 25000, 'cot-5', 'C3-A-BANK-2',   'BANK_TRANSFER', '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M7', 5000,  'cot-5', 'C3-A-CASH',     'CASH',          '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C3-M8', 5000,  'cot-5', 'C3-A-CASH',     'CASH',          '2026-05-01');

-- Soldes col-3 :
--   CASH     : 25k + 25k (avr) + 5k + 5k (mai)                     =  60 000  ✓
--   BANK-1   : 25k×4 (avr)    + 25k + 25k (mai)                    = 150 000  ✓  (corrigé : était 100 000)
--   BANK-2   : 25k + 25k (avr) + 20k + 25k (mai)                   =  95 000  ✓
--   MOBILE-1 : 15k + 15k (mai)                                      =  30 000  ✓
UPDATE accounts SET balance = 60000  WHERE id = 'C3-A-CASH';
UPDATE accounts SET balance = 150000 WHERE id = 'C3-A-BANK-1';
UPDATE accounts SET balance = 95000  WHERE id = 'C3-A-BANK-2';
UPDATE accounts SET balance = 30000  WHERE id = 'C3-A-MOBILE-1';

-- ============================================================
-- NOUVEAUX MEMBRES JUNIORS (Tableaux 18, 19, 20)
-- ============================================================

-- col-1 : 4 juniors (Tableau 18)
INSERT INTO members (id, last_name, first_name, birth_date, gender, address, profession, phone, email)
VALUES
    ('C1-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot X Ambato', 'Agriculteur', '0300000001', 'junior1.col1@fed-agri.mg'),
    ('C1-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot X Ambato', 'Agriculteur', '0300000002', 'junior2.col1@fed-agri.mg'),
    ('C1-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot X Ambato', 'Agriculteur', '0300000003', 'junior3.col1@fed-agri.mg'),
    ('C1-NJ4', 'Nouveau4', 'Junior4', '2003-04-04', 'FEMALE', 'Lot X Ambato', 'Agriculteur', '0300000004', 'junior4.col1@fed-agri.mg');

INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C1-NJ1', 'col-1', 'JUNIOR', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C1-NJ2', 'col-1', 'JUNIOR', '2026-04-01'),
    (gen_random_uuid()::VARCHAR, 'C1-NJ3', 'col-1', 'JUNIOR', '2026-05-01'),
    (gen_random_uuid()::VARCHAR, 'C1-NJ4', 'col-1', 'JUNIOR', '2026-06-01');

INSERT INTO referals (id, member_id, referee_id) VALUES
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ1', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ1', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ2', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ2', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ3', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ3', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ4', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C1-NJ4', 'C1-M2');

-- col-2 : 3 juniors (Tableau 19)
INSERT INTO members (id, last_name, first_name, birth_date, gender, address, profession, phone, email)
VALUES
    ('C2-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot Y Ambato', 'Agriculteur', '0300000011', 'junior1.col2@fed-agri.mg'),
    ('C2-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot Y Ambato', 'Agriculteur', '0300000012', 'junior2.col2@fed-agri.mg'),
    ('C2-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot Y Ambato', 'Agriculteur', '0300000013', 'junior3.col2@fed-agri.mg');

INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C2-NJ1', 'col-2', 'JUNIOR', '2026-03-01'),
    (gen_random_uuid()::VARCHAR, 'C2-NJ2', 'col-2', 'JUNIOR', '2026-03-01'),
    (gen_random_uuid()::VARCHAR, 'C2-NJ3', 'col-2', 'JUNIOR', '2026-03-01');

-- Parrains des juniors col-2 : C1-M1 et C1-M2 (Tableau 19)
INSERT INTO referals (id, member_id, referee_id) VALUES
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ1', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ1', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ2', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ2', 'C1-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ3', 'C1-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C2-NJ3', 'C1-M2');

-- col-3 : 6 juniors (Tableau 20)
INSERT INTO members (id, last_name, first_name, birth_date, gender, address, profession, phone, email)
VALUES
    ('C3-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000021', 'junior1.col3@fed-agri.mg'),
    ('C3-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000022', 'junior2.col3@fed-agri.mg'),
    ('C3-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000023', 'junior3.col3@fed-agri.mg'),
    ('C3-NJ4', 'Nouveau4', 'Junior4', '2003-04-04', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000024', 'junior4.col3@fed-agri.mg'),
    ('C3-NJ5', 'Nouveau5', 'Junior5', '2004-05-05', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000025', 'junior5.col3@fed-agri.mg'),
    ('C3-NJ6', 'Nouveau6', 'Junior6', '2005-06-06', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000026', 'junior6.col3@fed-agri.mg');

INSERT INTO memberships (id, member_id, collectivity_id, occupation, start_date)
VALUES
    (gen_random_uuid()::VARCHAR, 'C3-NJ1', 'col-3', 'JUNIOR', '2026-01-01'),
    (gen_random_uuid()::VARCHAR, 'C3-NJ2', 'col-3', 'JUNIOR', '2026-02-01'),
    (gen_random_uuid()::VARCHAR, 'C3-NJ3', 'col-3', 'JUNIOR', '2026-02-01'),
    (gen_random_uuid()::VARCHAR, 'C3-NJ4', 'col-3', 'JUNIOR', '2026-03-01'),
    (gen_random_uuid()::VARCHAR, 'C3-NJ5', 'col-3', 'JUNIOR', '2026-03-01'),
    (gen_random_uuid()::VARCHAR, 'C3-NJ6', 'col-3', 'JUNIOR', '2026-03-01');

-- Parrains des juniors col-3 : C3-M1 et C3-M2 (Tableau 20)
INSERT INTO referals (id, member_id, referee_id) VALUES
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ1', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ1', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ2', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ2', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ3', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ3', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ4', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ4', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ5', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ5', 'C3-M2'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ6', 'C3-M1'),
                                                     (gen_random_uuid()::VARCHAR, 'C3-NJ6', 'C3-M2');                                                                                                                                   ('trx-2-8', 'col-2', 'C2-M8', 'IN', 60000, '2026-01-01', 'MOBILE_BANKING', 'C2-A-MOBILE-1');
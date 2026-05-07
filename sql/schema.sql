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
-- Conforme au DDL : federation, collectivity, member,
-- member_collectivity, member_referee, account, cash_account,
-- bank_account, mobile_money_account, cotisation_plan, transaction
-- ============================================================

-- ============================================================
-- NETTOYAGE (ordre FK)
-- ============================================================
DELETE FROM activity_attendance;
DELETE FROM activity_member_occupation;
DELETE FROM activity;
DELETE FROM transaction;
DELETE FROM cotisation_plan;
DELETE FROM mobile_money_account;
DELETE FROM bank_account;
DELETE FROM cash_account;
DELETE FROM account;
DELETE FROM member_referee;
DELETE FROM member_collectivity;
DELETE FROM member;
DELETE FROM collectivity;
DELETE FROM federation;

-- ============================================================
-- FEDERATION
-- ============================================================
INSERT INTO federation (id, name, creation_date)
VALUES ('fed-1', 'Fédération Agricole de Madagascar', CURRENT_DATE);

-- ============================================================
-- COLLECTIVITÉS (Tableau 1)
-- ============================================================
INSERT INTO collectivity (id, number, name, speciality, location, federation_approval, authorization_date, creation_date, id_federation)
VALUES
    ('col-1', '1', 'Mpanorina',      'Riziculture',  'Ambatondrazaka', TRUE, CURRENT_DATE, CURRENT_DATE, 'fed-1'),
    ('col-2', '2', 'Dobo voalohany', 'Pisciculture', 'Ambatondrazaka', TRUE, CURRENT_DATE, CURRENT_DATE, 'fed-1'),
    ('col-3', '3', 'Tantely mamy',   'Apiculture',   'Brickaville',    TRUE, CURRENT_DATE, CURRENT_DATE, 'fed-1');

-- ============================================================
-- MEMBRES (Tableaux 2, 3, 4)
-- Colonne DDL : first_name, last_name, phone_number, enrolment_date
-- ============================================================
INSERT INTO member (id, last_name, first_name, birth_date, gender, address, profession, phone_number, email, enrolment_date)
VALUES
    -- Collectivité 1 & 2 (mêmes membres)
    ('C1-M1', 'Nom membre 1',  'Prénom membre 1',  '1980-02-01', 'MALE',   'Lot II V M Ambato.',   'Riziculteur', '0341234567', 'member.1@fed-agri.mg',  '2026-01-01'),
    ('C1-M2', 'Nom membre 2',  'Prénom membre 2',  '1982-03-05', 'MALE',   'Lot II F Ambato.',     'Agriculteur', '0321234567', 'member.2@fed-agri.mg',  '2026-01-01'),
    ('C1-M3', 'Nom membre 3',  'Prénom membre 3',  '1992-03-10', 'MALE',   'Lot II J Ambato.',     'Collecteur',  '0331234567', 'member.3@fed-agri.mg',  '2026-01-01'),
    ('C1-M4', 'Nom membre 4',  'Prénom membre 4',  '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.',   'Distributeur','0381234567', 'member.4@fed-agri.mg',  '2026-01-01'),
    ('C1-M5', 'Nom membre 5',  'Prénom membre 5',  '1999-08-21', 'MALE',   'Lot UV 80 Ambato.',    'Riziculteur', '0373434567', 'member.5@fed-agri.mg',  '2026-01-01'),
    ('C1-M6', 'Nom membre 6',  'Prénom membre 6',  '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.',     'Riziculteur', '0372234567', 'member.6@fed-agri.mg',  '2026-01-01'),
    ('C1-M7', 'Nom membre 7',  'Prénom membre 7',  '1998-01-31', 'MALE',   'Lot UV 7 Ambato.',     'Riziculteur', '0374234567', 'member.7@fed-agri.mg',  '2026-01-01'),
    ('C1-M8', 'Nom membre 8',  'Prénom membre 8',  '1975-08-20', 'MALE',   'Lot UV 8 Ambato.',     'Riziculteur', '0370234567', 'member.8@fed-agri.mg',  '2026-01-01'),
    -- Collectivité 3
    ('C3-M1', 'Nom membre 9',  'Prénom membre 9',  '1988-01-02', 'MALE',   'Lot 33 J Antsirabe',   'Apiculteur',  '034034567',  'member.9@fed-agri.mg',  '2026-01-01'),
    ('C3-M2', 'Nom membre 10', 'Prénom membre 10', '1982-03-05', 'MALE',   'Lot 2 J Antsirabe',    'Agriculteur', '0338634567', 'member.10@fed-agri.mg', '2026-01-01'),
    ('C3-M3', 'Nom membre 11', 'Prénom membre 11', '1992-03-12', 'MALE',   'Lot 8 KM Antsirabe',   'Collecteur',  '0338234567', 'member.11@fed-agri.mg', '2026-01-01'),
    ('C3-M4', 'Nom membre 12', 'Prénom membre 12', '1988-05-10', 'FEMALE', 'Lot A K 50 Antsirabe', 'Distributeur','0382334567', 'member.12@fed-agri.mg', '2026-01-01'),
    ('C3-M5', 'Nom membre 13', 'Prénom membre 13', '1999-08-11', 'MALE',   'Lot UV 80 Antsirabe',  'Apiculteur',  '0373365567', 'member.13@fed-agri.mg', '2026-01-01'),
    ('C3-M6', 'Nom membre 14', 'Prénom membre 14', '1998-08-09', 'FEMALE', 'Lot UV 6 Antsirabe',   'Apiculteur',  '0378234567', 'member.14@fed-agri.mg', '2026-01-01'),
    ('C3-M7', 'Nom membre 15', 'Prénom membre 15', '1998-01-13', 'MALE',   'Lot UV 7 Antsirabe',   'Apiculteur',  '0374914567', 'member.15@fed-agri.mg', '2026-01-01'),
    ('C3-M8', 'Nom membre 16', 'Prénom membre 16', '1975-08-02', 'MALE',   'Lot UV 8 Antsirabe',   'Apiculteur',  '0370634567', 'member.16@fed-agri.mg', '2026-01-01');

-- ============================================================
-- MEMBER_COLLECTIVITY (= memberships)
-- PK : (id_member, id_collectivity, start_date)
-- ============================================================

-- Collectivité 1 (Tableau 2)
INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C1-M1', 'col-1', 'PRESIDENT',      '2026-01-01'),
    ('C1-M2', 'col-1', 'VICE_PRESIDENT', '2026-01-01'),
    ('C1-M3', 'col-1', 'SECRETARY',      '2026-01-01'),
    ('C1-M4', 'col-1', 'TREASURER',      '2026-01-01'),
    ('C1-M5', 'col-1', 'SENIOR',         '2026-01-01'),
    ('C1-M6', 'col-1', 'SENIOR',         '2026-01-01'),
    ('C1-M7', 'col-1', 'SENIOR',         '2026-01-01'),
    ('C1-M8', 'col-1', 'SENIOR',         '2026-01-01');

-- Collectivité 2 (Tableau 3) — mêmes membres, postes différents
INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C1-M1', 'col-2', 'SENIOR',         '2026-01-01'),
    ('C1-M2', 'col-2', 'SENIOR',         '2026-01-01'),
    ('C1-M3', 'col-2', 'SENIOR',         '2026-01-01'),
    ('C1-M4', 'col-2', 'SENIOR',         '2026-01-01'),
    ('C1-M5', 'col-2', 'PRESIDENT',      '2026-01-01'),
    ('C1-M6', 'col-2', 'VICE_PRESIDENT', '2026-01-01'),
    ('C1-M7', 'col-2', 'SECRETARY',      '2026-01-01'),
    ('C1-M8', 'col-2', 'TREASURER',      '2026-01-01');

-- Collectivité 3 (Tableau 4)
INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C3-M1', 'col-3', 'PRESIDENT',      '2026-01-01'),
    ('C3-M2', 'col-3', 'VICE_PRESIDENT', '2026-01-01'),
    ('C3-M3', 'col-3', 'SECRETARY',      '2026-01-01'),
    ('C3-M4', 'col-3', 'TREASURER',      '2026-01-01'),
    ('C3-M5', 'col-3', 'SENIOR',         '2026-01-01'),
    ('C3-M6', 'col-3', 'SENIOR',         '2026-01-01'),
    ('C3-M7', 'col-3', 'SENIOR',         '2026-01-01'),
    ('C3-M8', 'col-3', 'SENIOR',         '2026-01-01');

-- ============================================================
-- MEMBER_REFEREE (= referals)
-- PK : (id_candidate, id_referee) — pas de colonne id séparée
-- La colonne relationship est NULL (non fournie dans le PDF)
-- ============================================================
INSERT INTO member_referee (id_candidate, id_referee, relationship)
VALUES
    -- Collectivité 1 : parrains des membres confirmés
    ('C1-M3', 'C1-M1', NULL), ('C1-M3', 'C1-M2', NULL),
    ('C1-M4', 'C1-M1', NULL), ('C1-M4', 'C1-M2', NULL),
    ('C1-M5', 'C1-M1', NULL), ('C1-M5', 'C1-M2', NULL),
    ('C1-M6', 'C1-M1', NULL), ('C1-M6', 'C1-M2', NULL),
    ('C1-M7', 'C1-M1', NULL), ('C1-M7', 'C1-M2', NULL),
    ('C1-M8', 'C1-M6', NULL), ('C1-M8', 'C1-M7', NULL),
    -- Collectivité 3
    ('C3-M3', 'C3-M1', NULL), ('C3-M3', 'C3-M2', NULL),
    ('C3-M4', 'C3-M1', NULL), ('C3-M4', 'C3-M2', NULL),
    ('C3-M5', 'C3-M1', NULL), ('C3-M5', 'C3-M2', NULL),
    ('C3-M6', 'C3-M1', NULL), ('C3-M6', 'C3-M2', NULL),
    ('C3-M7', 'C3-M1', NULL), ('C3-M7', 'C3-M2', NULL),
    ('C3-M8', 'C3-M1', NULL), ('C3-M8', 'C3-M2', NULL);

-- ============================================================
-- COMPTES FINANCIERS
-- Le DDL sépare : account (parent) + cash_account / bank_account
-- / mobile_money_account (enfants)
-- ============================================================

-- === Collectivité 1 ===
INSERT INTO account (id, id_collectivity) VALUES
                                              ('C1-A-CASH',     'col-1'),
                                              ('C1-A-MOBILE-1', 'col-1');

INSERT INTO cash_account (id, id_account)
VALUES (gen_random_uuid()::VARCHAR, 'C1-A-CASH');

INSERT INTO mobile_money_account (id, id_account, holder_name, service_name, phone_number)
VALUES (gen_random_uuid()::VARCHAR, 'C1-A-MOBILE-1', 'Mpanorina', 'ORANGE_MONEY', '0370489612');

-- === Collectivité 2 ===
INSERT INTO account (id, id_collectivity) VALUES
                                              ('C2-A-CASH',     'col-2'),
                                              ('C2-A-MOBILE-1', 'col-2');

INSERT INTO cash_account (id, id_account)
VALUES (gen_random_uuid()::VARCHAR, 'C2-A-CASH');

INSERT INTO mobile_money_account (id, id_account, holder_name, service_name, phone_number)
VALUES (gen_random_uuid()::VARCHAR, 'C2-A-MOBILE-1', 'Dobo voalohany', 'ORANGE_MONEY', '0320489612');

-- === Collectivité 3 ===
INSERT INTO account (id, id_collectivity) VALUES
                                              ('C3-A-CASH',     'col-3'),
                                              ('C3-A-BANK-1',   'col-3'),
                                              ('C3-A-BANK-2',   'col-3'),
                                              ('C3-A-MOBILE-1', 'col-3');

INSERT INTO cash_account (id, id_account)
VALUES (gen_random_uuid()::VARCHAR, 'C3-A-CASH');

-- BMOI : code banque 00004, code guichet 00001, numéro compte 12345678901, clé RIB 12
INSERT INTO bank_account (id, id_account, holder_name, bank_name, bank_code, branch_code, account_number, rib_key)
VALUES
    (gen_random_uuid()::VARCHAR, 'C3-A-BANK-1', 'Koto',  'BMOI', '00004', '00001', '12345678901', '12'),
    (gen_random_uuid()::VARCHAR, 'C3-A-BANK-2', 'Naivo', 'BRED', '00008', '00003', '45678901234', '58');

INSERT INTO mobile_money_account (id, id_account, holder_name, service_name, phone_number)
VALUES (gen_random_uuid()::VARCHAR, 'C3-A-MOBILE-1', 'Kolo', 'MVOLA', '0341889612');

-- ============================================================
-- COTISATIONS (Tableaux 12, 13, 14)
-- Table : cotisation_plan
-- ============================================================

-- col-1
INSERT INTO cotisation_plan (id, label, id_collectivity, status, frequency, eligible_from, amount)
VALUES
    ('cot-1', 'Cotisation annuelle', 'col-1', 'ACTIVE',   'ANNUALLY',   '2026-01-01', 200000.00),
    ('cot-2', 'Famangiana',          'col-1', 'ACTIVE',   'PUNCTUALLY', '2026-04-30',  20000.00);

-- col-2
INSERT INTO cotisation_plan (id, label, id_collectivity, status, frequency, eligible_from, amount)
VALUES
    ('cot-3', 'Cotisation annuelle', 'col-2', 'ACTIVE',   'ANNUALLY', '2026-01-01', 200000.00),
    ('cot-4', 'Cotisation 2025',     'col-2', 'INACTIVE', 'ANNUALLY', '2025-01-01', 100000.00);

-- col-3
INSERT INTO cotisation_plan (id, label, id_collectivity, status, frequency, eligible_from, amount)
VALUES
    ('cot-5', 'Cotisation mensuelle', 'col-3', 'ACTIVE', 'MONTHLY', '2026-04-01', 25000.00);

-- ============================================================
-- TRANSACTIONS (Tableaux 15, 16, 17)
-- Table : transaction
-- Colonnes : id, id_collectivity, id_member, id_cotisation_plan,
--            transaction_type, amount, transaction_date,
--            payment_mode, description, id_account
-- ============================================================

-- === col-1 (Tableau 15) ===
-- CASH : C1-M1, C1-M2 → C1-A-CASH (01/01/2026)
-- MOBILE_BANKING : C1-M3, C1-M4 (200k), C1-M5 (150k) → C1-A-MOBILE-1 (01/01/2026)
-- CASH : C1-M6 (100k), C1-M7 (60k), C1-M8 (90k) → C1-A-CASH (01/05/2026)
INSERT INTO transaction (id, id_collectivity, id_member, id_cotisation_plan, transaction_type, amount, transaction_date, payment_mode, id_account)
VALUES
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M1', 'cot-1', 'IN', 200000, '2026-01-01', 'CASH',           'C1-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M2', 'cot-1', 'IN', 200000, '2026-01-01', 'CASH',           'C1-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M3', 'cot-1', 'IN', 200000, '2026-01-01', 'MOBILE_BANKING', 'C1-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M4', 'cot-1', 'IN', 200000, '2026-01-01', 'MOBILE_BANKING', 'C1-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M5', 'cot-1', 'IN', 150000, '2026-01-01', 'MOBILE_BANKING', 'C1-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M6', 'cot-1', 'IN', 100000, '2026-05-01', 'CASH',           'C1-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M7', 'cot-1', 'IN',  60000, '2026-05-01', 'CASH',           'C1-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-1', 'C1-M8', 'cot-1', 'IN',  90000, '2026-05-01', 'CASH',           'C1-A-CASH');

-- Soldes col-1 :
-- C1-A-CASH     : 200k + 200k + 100k + 60k + 90k = 650 000
-- C1-A-MOBILE-1 : 200k + 200k + 150k             = 550 000

-- === col-2 (Tableau 16) ===
INSERT INTO transaction (id, id_collectivity, id_member, id_cotisation_plan, transaction_type, amount, transaction_date, payment_mode, id_account)
VALUES
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M1', 'cot-3', 'IN', 120000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M2', 'cot-3', 'IN', 180000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M3', 'cot-3', 'IN', 200000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M4', 'cot-3', 'IN', 200000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M5', 'cot-3', 'IN', 200000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M6', 'cot-3', 'IN', 200000, '2026-01-01', 'CASH',           'C2-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M7', 'cot-3', 'IN',  80000, '2026-01-01', 'MOBILE_BANKING', 'C2-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-2', 'C1-M8', 'cot-3', 'IN', 120000, '2026-01-01', 'MOBILE_BANKING', 'C2-A-MOBILE-1');

-- Soldes col-2 :
-- C2-A-CASH     : 120k+180k+200k+200k+200k+200k = 1 100 000
-- C2-A-MOBILE-1 : 80k + 120k                    =   200 000

-- === col-3 (Tableau 17) ===
INSERT INTO transaction (id, id_collectivity, id_member, id_cotisation_plan, transaction_type, amount, transaction_date, payment_mode, id_account)
VALUES
    -- Avril
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M1', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M2', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M3', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M4', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M5', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-2'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M6', 'cot-5', 'IN', 25000, '2026-04-01', 'BANK_TRANSFER', 'C3-A-BANK-2'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M7', 'cot-5', 'IN', 25000, '2026-04-01', 'CASH',          'C3-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M8', 'cot-5', 'IN', 25000, '2026-04-01', 'CASH',          'C3-A-CASH'),
    -- Mai
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M1', 'cot-5', 'IN', 25000, '2026-05-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M2', 'cot-5', 'IN', 25000, '2026-05-01', 'BANK_TRANSFER', 'C3-A-BANK-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M3', 'cot-5', 'IN', 15000, '2026-05-01', 'MOBILE_BANKING','C3-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M4', 'cot-5', 'IN', 15000, '2026-05-01', 'MOBILE_BANKING','C3-A-MOBILE-1'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M5', 'cot-5', 'IN', 20000, '2026-05-01', 'BANK_TRANSFER', 'C3-A-BANK-2'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M6', 'cot-5', 'IN', 25000, '2026-05-01', 'BANK_TRANSFER', 'C3-A-BANK-2'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M7', 'cot-5', 'IN',  5000, '2026-05-01', 'CASH',          'C3-A-CASH'),
    (gen_random_uuid()::VARCHAR, 'col-3', 'C3-M8', 'cot-5', 'IN',  5000, '2026-05-01', 'CASH',          'C3-A-CASH');

-- Soldes col-3 :
-- C3-A-CASH     : 25k+25k+5k+5k       =  60 000
-- C3-A-BANK-1   : 25k×4 + 25k+25k     = 150 000
-- C3-A-BANK-2   : 25k+25k + 20k+25k   =  95 000
-- C3-A-MOBILE-1 : 15k+15k             =  30 000

-- ============================================================
-- NOUVEAUX MEMBRES JUNIORS (Tableaux 18, 19, 20)
-- ============================================================

-- === col-1 : 4 juniors (Tableau 18) ===
INSERT INTO member (id, last_name, first_name, birth_date, gender, address, profession, phone_number, email, enrolment_date)
VALUES
    ('C1-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot X Ambato', 'Agriculteur', '0300000001', 'junior1.col1@fed-agri.mg', '2026-04-01'),
    ('C1-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot X Ambato', 'Agriculteur', '0300000002', 'junior2.col1@fed-agri.mg', '2026-04-01'),
    ('C1-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot X Ambato', 'Agriculteur', '0300000003', 'junior3.col1@fed-agri.mg', '2026-05-01'),
    ('C1-NJ4', 'Nouveau4', 'Junior4', '2003-04-04', 'FEMALE', 'Lot X Ambato', 'Agriculteur', '0300000004', 'junior4.col1@fed-agri.mg', '2026-06-01');

INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C1-NJ1', 'col-1', 'JUNIOR', '2026-04-01'),
    ('C1-NJ2', 'col-1', 'JUNIOR', '2026-04-01'),
    ('C1-NJ3', 'col-1', 'JUNIOR', '2026-05-01'),
    ('C1-NJ4', 'col-1', 'JUNIOR', '2026-06-01');

INSERT INTO member_referee (id_candidate, id_referee, relationship)
VALUES
    ('C1-NJ1', 'C1-M1', NULL), ('C1-NJ1', 'C1-M2', NULL),
    ('C1-NJ2', 'C1-M1', NULL), ('C1-NJ2', 'C1-M2', NULL),
    ('C1-NJ3', 'C1-M1', NULL), ('C1-NJ3', 'C1-M2', NULL),
    ('C1-NJ4', 'C1-M1', NULL), ('C1-NJ4', 'C1-M2', NULL);

-- === col-2 : 3 juniors (Tableau 19) ===
INSERT INTO member (id, last_name, first_name, birth_date, gender, address, profession, phone_number, email, enrolment_date)
VALUES
    ('C2-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot Y Ambato', 'Agriculteur', '0300000011', 'junior1.col2@fed-agri.mg', '2026-03-01'),
    ('C2-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot Y Ambato', 'Agriculteur', '0300000012', 'junior2.col2@fed-agri.mg', '2026-03-01'),
    ('C2-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot Y Ambato', 'Agriculteur', '0300000013', 'junior3.col2@fed-agri.mg', '2026-03-01');

INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C2-NJ1', 'col-2', 'JUNIOR', '2026-03-01'),
    ('C2-NJ2', 'col-2', 'JUNIOR', '2026-03-01'),
    ('C2-NJ3', 'col-2', 'JUNIOR', '2026-03-01');

INSERT INTO member_referee (id_candidate, id_referee, relationship)
VALUES
    ('C2-NJ1', 'C1-M1', NULL), ('C2-NJ1', 'C1-M2', NULL),
    ('C2-NJ2', 'C1-M1', NULL), ('C2-NJ2', 'C1-M2', NULL),
    ('C2-NJ3', 'C1-M1', NULL), ('C2-NJ3', 'C1-M2', NULL);

-- === col-3 : 6 juniors (Tableau 20) ===
INSERT INTO member (id, last_name, first_name, birth_date, gender, address, profession, phone_number, email, enrolment_date)
VALUES
    ('C3-NJ1', 'Nouveau1', 'Junior1', '2000-01-01', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000021', 'junior1.col3@fed-agri.mg', '2026-01-01'),
    ('C3-NJ2', 'Nouveau2', 'Junior2', '2001-02-02', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000022', 'junior2.col3@fed-agri.mg', '2026-02-01'),
    ('C3-NJ3', 'Nouveau3', 'Junior3', '2002-03-03', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000023', 'junior3.col3@fed-agri.mg', '2026-02-01'),
    ('C3-NJ4', 'Nouveau4', 'Junior4', '2003-04-04', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000024', 'junior4.col3@fed-agri.mg', '2026-03-01'),
    ('C3-NJ5', 'Nouveau5', 'Junior5', '2004-05-05', 'MALE',   'Lot Z Antsirabe', 'Apiculteur', '0300000025', 'junior5.col3@fed-agri.mg', '2026-03-01'),
    ('C3-NJ6', 'Nouveau6', 'Junior6', '2005-06-06', 'FEMALE', 'Lot Z Antsirabe', 'Apiculteur', '0300000026', 'junior6.col3@fed-agri.mg', '2026-03-01');

INSERT INTO member_collectivity (id_member, id_collectivity, occupation, start_date)
VALUES
    ('C3-NJ1', 'col-3', 'JUNIOR', '2026-01-01'),
    ('C3-NJ2', 'col-3', 'JUNIOR', '2026-02-01'),
    ('C3-NJ3', 'col-3', 'JUNIOR', '2026-02-01'),
    ('C3-NJ4', 'col-3', 'JUNIOR', '2026-03-01'),
    ('C3-NJ5', 'col-3', 'JUNIOR', '2026-03-01'),
    ('C3-NJ6', 'col-3', 'JUNIOR', '2026-03-01');

INSERT INTO member_referee (id_candidate, id_referee, relationship)
VALUES
    ('C3-NJ1', 'C3-M1', NULL), ('C3-NJ1', 'C3-M2', NULL),
    ('C3-NJ2', 'C3-M1', NULL), ('C3-NJ2', 'C3-M2', NULL),
    ('C3-NJ3', 'C3-M1', NULL), ('C3-NJ3', 'C3-M2', NULL),
    ('C3-NJ4', 'C3-M1', NULL), ('C3-NJ4', 'C3-M2', NULL),
    ('C3-NJ5', 'C3-M1', NULL), ('C3-NJ5', 'C3-M2', NULL),
    ('C3-NJ6', 'C3-M1', NULL), ('C3-NJ6', 'C3-M2', NULL);




-- ============================================================
-- DONNÉES BONUS — Activités et Présences
-- Évaluation 6 Mai 2026
-- Tables : activity, activity_member_occupation, activity_attendance
-- ============================================================

-- ============================================================
-- ACTIVITÉS (Tableaux 21, 22, 23)
-- Colonnes : id, id_collectivity, label, activity_type,
--            executive_date, week_ordinal, day_of_week, creation_date
-- Pour les activités récurrentes : executive_date = NULL
-- Pour l'activité ponctuelle    : week_ordinal et day_of_week = NULL
-- ============================================================

INSERT INTO activity (id, id_collectivity, label, activity_type, executive_date, week_ordinal, day_of_week, creation_date)
VALUES
    -- Collectivité 1 (Tableau 21)
    ('act-1', 'col-1', 'AG1',            'MEETING',  NULL,         1, 'SA', CURRENT_DATE), -- 1er samedi
    ('act-2', 'col-1', 'Formation base', 'TRAINING', NULL,         2, 'SU', CURRENT_DATE), -- 2è dimanche

    -- Collectivité 2 (Tableau 22)
    ('act-3', 'col-2', 'AG2',              'MEETING',  NULL,         1, 'SU', CURRENT_DATE), -- 1er dimanche
    ('act-4', 'col-2', 'Formation base',   'TRAINING', NULL,         3, 'SU', CURRENT_DATE), -- 3è dimanche
    ('act-5', 'col-2', 'Perfectionnement', 'OTHER',    '2026-04-30', NULL, NULL, CURRENT_DATE), -- ponctuelle

    -- Collectivité 3 (Tableau 23)
    ('act-6', 'col-3', 'AG3',            'MEETING',  NULL,         1, 'FR', CURRENT_DATE), -- 1er vendredi
    ('act-7', 'col-3', 'Formation base', 'TRAINING', NULL,         4, 'WE', CURRENT_DATE); -- 4è mercredi

-- ============================================================
-- OCCUPATIONS CONCERNÉES PAR ACTIVITÉ
-- Table : activity_member_occupation
-- PK : (id_activity, occupation)
-- ============================================================

-- act-1 : AG1 col-1 → toutes les occupations
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
                                                                     ('act-1', 'JUNIOR'),
                                                                     ('act-1', 'SENIOR'),
                                                                     ('act-1', 'SECRETARY'),
                                                                     ('act-1', 'TREASURER'),
                                                                     ('act-1', 'VICE_PRESIDENT'),
                                                                     ('act-1', 'PRESIDENT');

-- act-2 : Formation base col-1 → JUNIOR uniquement
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
    ('act-2', 'JUNIOR');

-- act-3 : AG2 col-2 → toutes les occupations
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
                                                                     ('act-3', 'JUNIOR'),
                                                                     ('act-3', 'SENIOR'),
                                                                     ('act-3', 'SECRETARY'),
                                                                     ('act-3', 'TREASURER'),
                                                                     ('act-3', 'VICE_PRESIDENT'),
                                                                     ('act-3', 'PRESIDENT');

-- act-4 : Formation base col-2 → JUNIOR uniquement
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
    ('act-4', 'JUNIOR');

-- act-5 : Perfectionnement col-2 → SENIOR uniquement
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
    ('act-5', 'SENIOR');

-- act-6 : AG3 col-3 → toutes les occupations
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
                                                                     ('act-6', 'JUNIOR'),
                                                                     ('act-6', 'SENIOR'),
                                                                     ('act-6', 'SECRETARY'),
                                                                     ('act-6', 'TREASURER'),
                                                                     ('act-6', 'VICE_PRESIDENT'),
                                                                     ('act-6', 'PRESIDENT');

-- act-7 : Formation base col-3 → JUNIOR uniquement
INSERT INTO activity_member_occupation (id_activity, occupation) VALUES
    ('act-7', 'JUNIOR');

-- ============================================================
-- PRÉSENCES (Tableaux 24 à 30)
-- Table : activity_attendance
-- Colonnes : id, id_activity, id_member, attendance_status
-- Valeurs : ATTENDED | MISSING | UNDEFINED
-- UNIQUE (id_activity, id_member) → une ligne par membre par activité
-- ⚠️  act-1 a deux occurrences (mars et avril) mais id_activity est
--     le même → on ne peut pas insérer deux fois le même membre
--     sur act-1. Le PDF donne des fiches par date, mais la table
--     ne stocke pas la date de présence séparément.
--     → On insère la dernière fiche connue (avril, Tableau 25),
--       qui est la plus récente. Adapter si ton archi gère les
--       occurrences avec une colonne executive_date sur attendance.
-- ============================================================

-- act-1 : AG1 col-1 — fiche avril 2026 (Tableau 25)
INSERT INTO activity_attendance (id, id_activity, id_member, attendance_status)
VALUES
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M1', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M2', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M3', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M4', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M5', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M6', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M7', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-1', 'C1-M8', 'ATTENDED');

-- act-3 : AG2 col-2 — fiche avril 2026 (Tableau 27)
INSERT INTO activity_attendance (id, id_activity, id_member, attendance_status)
VALUES
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M1', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M2', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M3', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M4', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M5', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M6', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M7', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-3', 'C1-M8', 'MISSING');

-- act-5 : Perfectionnement col-2 — 30/04/2026 (Tableau 28)
INSERT INTO activity_attendance (id, id_activity, id_member, attendance_status)
VALUES
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M1', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M2', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M3', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M4', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M5', 'UNDEFINED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M6', 'UNDEFINED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M7', 'UNDEFINED'),
    (gen_random_uuid()::VARCHAR, 'act-5', 'C1-M8', 'UNDEFINED');

-- act-6 : AG3 col-3 — fiche avril 2026 (Tableau 30)
-- ⚠️  C1-M1 apparaît aussi (membre d'une autre collectivité présent)
--     → à insérer également selon le contexte métier (présence hors collectivité)
INSERT INTO activity_attendance (id, id_activity, id_member, attendance_status)
VALUES
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M1', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M2', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M3', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M4', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M5', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M6', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M7', 'MISSING'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C3-M8', 'ATTENDED'),
    (gen_random_uuid()::VARCHAR, 'act-6', 'C1-M1', 'ATTENDED'); -- membre externe
-- ==========================================================
-- 1. NETTOYAGE ET ENUMS
-- ==========================================================
DROP TABLE IF EXISTS "transaction" CASCADE;
DROP TABLE IF EXISTS "account" CASCADE;
DROP TABLE IF EXISTS "member_referee" CASCADE;
DROP TABLE IF EXISTS "member" CASCADE;
DROP TABLE IF EXISTS "collectivity" CASCADE;
DROP TABLE IF EXISTS "federation" CASCADE;

CREATE TYPE "occupation_type" AS ENUM ('PRESIDENT', 'VICE_PRESIDENT', 'TREASURER', 'SECRETARY', 'SENIOR', 'JUNIOR');
CREATE TYPE "gender_type" AS ENUM ('MALE', 'FEMALE');
CREATE TYPE "account_type" AS ENUM ('CASH', 'MOBILE_MONEY', 'BANK');
CREATE TYPE "payment_mode" AS ENUM ('CASH', 'BANK_TRANSFER', 'MOBILE_MONEY');
CREATE TYPE "trans_type" AS ENUM ('IN', 'OUT');

-- ==========================================================
-- 2. STRUCTURE ADMINISTRATIVE
-- ==========================================================

CREATE TABLE "federation" (
                              "id" VARCHAR(50) PRIMARY KEY,
                              "cotisation_percentage" NUMERIC(5,2) DEFAULT 10.00
);

CREATE TABLE "collectivity" (
                                "id" VARCHAR(50) PRIMARY KEY, -- ex: 'col-1'
                                "number" VARCHAR(20) UNIQUE,  -- Attribué plus tard (PUT /informations)
                                "name" VARCHAR(100) UNIQUE,   -- Attribué plus tard (PUT /informations)
                                "speciality" VARCHAR(100) NOT NULL,
                                "location" VARCHAR(255) NOT NULL,
                                "creation_date" DATE DEFAULT CURRENT_DATE,
                                "id_federation" VARCHAR(50) REFERENCES "federation"("id")
);

CREATE TABLE "member" (
                          "id" VARCHAR(50) PRIMARY KEY, -- ex: 'C1-M1'
                          "first_name" VARCHAR(255) NOT NULL,
                          "last_name" VARCHAR(255) NOT NULL,
                          "birth_date" DATE NOT NULL,
                          "gender" "gender_type" NOT NULL,
                          "address" TEXT,
                          "phone_number" VARCHAR(50) UNIQUE,
                          "email" VARCHAR(255) UNIQUE,
                          "profession" VARCHAR(255), -- Le métier réel (ex: Riziculteur)
                          "occupation" "occupation_type" DEFAULT 'JUNIOR', -- Le rôle dans la fédération
                          "admission_date" DATE DEFAULT CURRENT_DATE,
                          "id_collectivity" VARCHAR(50) REFERENCES "collectivity"("id") ON DELETE CASCADE
);

-- Correction Angle Mort : Relation de parrainage (B-2)
CREATE TABLE "member_referee" (
                                  "id" SERIAL PRIMARY KEY,
                                  "id_candidate" VARCHAR(50) NOT NULL REFERENCES "member"("id") ON DELETE CASCADE,
                                  "id_referee" VARCHAR(50) NOT NULL REFERENCES "member"("id"),
                                  "relationship" VARCHAR(255) NOT NULL, -- Ami, Famille, Collègue
                                  UNIQUE("id_candidate", "id_referee")
);

-- ==========================================================
-- 3. TRÉSORERIE ET COMPTES (Aligné Tableau 10)
-- ==========================================================

CREATE TABLE "account" (
                           "id" VARCHAR(50) PRIMARY KEY, -- ex: 'C2-A-CASH', 'C2-A-MOBILE-1'
                           "id_collectivity" VARCHAR(50) NOT NULL REFERENCES "collectivity"("id") ON DELETE CASCADE,
                           "type" "account_type" NOT NULL,
                           "bank_name" VARCHAR(100),      -- Pour les comptes BANK
                           "account_number" VARCHAR(23), -- Pour BANK (RIB)
                           "mobile_service" VARCHAR(50),  -- MVOLA, AIRTEL_MONEY, ORANGE_MONEY
                           "owner_name" VARCHAR(255)      -- Nom du titulaire (demandé dans le TD)
);

-- Correction Angle Mort : Calcul du solde à la date T
CREATE TABLE "transaction" (
                               "id" SERIAL PRIMARY KEY,
                               "id_member" VARCHAR(50) REFERENCES "member"("id"), -- Qui a payé ?
                               "id_account" VARCHAR(50) NOT NULL REFERENCES "account"("id"), -- Sur quel compte ?
                               "amount" NUMERIC(15,2) NOT NULL,
                               "type" "trans_type" NOT NULL DEFAULT 'IN',
                               "mode" "payment_mode" NOT NULL,
                               "transaction_date" TIMESTAMP NOT NULL DEFAULT NOW(), -- Précision pour le paramètre 'at'
                               "label" VARCHAR(255) -- ex: 'Frais d''adhésion', 'Cotisation annuelle'
);
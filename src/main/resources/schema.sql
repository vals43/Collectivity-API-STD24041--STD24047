-- 1. Définition des Types Énumérés (Propre à Postgres)
CREATE TYPE gender_type AS ENUM ('MALE', 'FEMALE');
CREATE TYPE occupation_type AS ENUM ('JUNIOR', 'SENIOR', 'SECRETARY', 'TREASURER', 'VICE_PRESIDENT', 'PRESIDENT');

-- 2. Table des COLLECTIVITÉS
CREATE TABLE collectivities (
                                id VARCHAR(50) PRIMARY KEY,
                                name VARCHAR(100) UNIQUE NOT NULL,
                                location VARCHAR(100) NOT NULL,
                                specialty VARCHAR(100) NOT NULL,
                                creation_date DATE NOT NULL DEFAULT CURRENT_DATE,
                                federation_approval BOOLEAN DEFAULT FALSE
);

-- 3. Table des MEMBRES
CREATE TABLE members (
                         id                               serial          PRIMARY KEY DEFAULT gen_random_uuid(),
                         last_name                        VARCHAR(255)  NOT NULL,
                         first_name                       VARCHAR(255)  NOT NULL,
                         birth_date                       DATE          NOT NULL,
                         gender                           gender_type   NOT NULL,
                         address                          TEXT          NOT NULL,
                         occupation                       VARCHAR(255)  NOT NULL,
                         phone                            VARCHAR(50)   NOT NULL,
                         email                            VARCHAR(255)  NOT NULL UNIQUE,
                         membership_date                  DATE          NOT NULL,
                         community_id                     serial          NOT NULL REFERENCES communities(id),
                         position                         position_type NOT NULL DEFAULT 'JUNIOR_MEMBER',
                         active                           BOOLEAN       NOT NULL DEFAULT TRUE,
                         resignation_date                 DATE,
                         registration_fee_paid            NUMERIC(15,2) NOT NULL DEFAULT 50000,
                         registration_annual_contribution NUMERIC(15,2) NOT NULL DEFAULT 0,
                         registration_payment_method      payment_method NOT NULL DEFAULT 'MOBILE_MONEY',
                         registration_payment_date        DATE          NOT NULL DEFAULT CURRENT_DATE,
                         created_at                       TIMESTAMP     NOT NULL DEFAULT NOW(),
                         updated_at                       TIMESTAMP     NOT NULL DEFAULT NOW(),

                         CONSTRAINT chk_registration_payment_method
                             CHECK (registration_payment_method IN ('MOBILE_MONEY', 'BANK_TRANSFER'))
);
-- 4. Table de PARRAINAGE (Relation N:N)
-- Nature de la relation exigée pour le point B-2
CREATE TABLE member_referees (
                                 candidate_id VARCHAR(50),
                                 referee_id VARCHAR(50),
                                 relationship_nature VARCHAR(100),
                                 PRIMARY KEY (candidate_id, referee_id),
                                 CONSTRAINT fk_candidate FOREIGN KEY (candidate_id) REFERENCES members(id) ON DELETE CASCADE,
                                 CONSTRAINT fk_referee FOREIGN KEY (referee_id) REFERENCES members(id) ON DELETE CASCADE
);
-- 1. Définition des Types Énumérés (Propre à Postgres)
CREATE TYPE gender_type AS ENUM ('MALE', 'FEMALE');
CREATE TYPE occupation_type AS ENUM ('JUNIOR', 'SENIOR', 'SECRETARY', 'TREASURER', 'VICE_PRESIDENT', 'PRESIDENT');
CREATE TYPE payment_type_enum AS ENUM ('REGISTRATION', 'ANNUAL_DUES');

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
                         id VARCHAR(50) PRIMARY KEY,
                         first_name VARCHAR(100) NOT NULL,
                         last_name VARCHAR(100) NOT NULL,
                         birth_date DATE NOT NULL,
                         gender gender_type NOT NULL,
                         address TEXT,
                         profession VARCHAR(100),
                         phone_number VARCHAR(20),
                         email VARCHAR(100) UNIQUE,
                         occupation occupation_type NOT NULL,
                         adhesion_date DATE NOT NULL DEFAULT CURRENT_DATE,
                         collectivity_id VARCHAR(50),
                         CONSTRAINT fk_collectivity
                             FOREIGN KEY (collectivity_id)
                                 REFERENCES collectivities(id)
                                 ON DELETE SET NULL
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

-- 5. Table des MANDATS (Historique pour la règle des 2 mandats max)
CREATE TABLE mandates (
                          id SERIAL PRIMARY KEY,
                          year INT NOT NULL,
                          member_id VARCHAR(50) NOT NULL,
                          collectivity_id VARCHAR(50), -- NULL pour les mandats nationaux
                          role occupation_type NOT NULL,
                          is_federation_level BOOLEAN DEFAULT FALSE,
                          CONSTRAINT fk_member_mandate FOREIGN KEY (member_id) REFERENCES members(id),
                          CONSTRAINT fk_coll_mandate FOREIGN KEY (collectivity_id) REFERENCES collectivities(id)
);

-- 6. Table des PAIEMENTS
CREATE TABLE payments (
                          id SERIAL PRIMARY KEY,
                          member_id VARCHAR(50) NOT NULL,
                          amount NUMERIC(12, 2) NOT NULL, -- NUMERIC est plus précis que DECIMAL pour l'Ariary
                          p_type payment_type_enum NOT NULL,
                          payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_member_payment FOREIGN KEY (member_id) REFERENCES members(id)
);
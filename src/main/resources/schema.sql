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
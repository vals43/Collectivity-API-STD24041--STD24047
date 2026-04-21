create database "collectivity_db";

create user "collectivity_user" with password '123456';

-- Grant all privileges

GRANT ALL ON SCHEMA public TO collectivity_db;

GRANT ALL PRIVILEGES ON DATABASE collectivity_db TO collectivity_user;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO collectivity_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO collectivity_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO collectivity_user;
BEGIN;

-- Vérifie si la base de données existe, et la supprime le cas échéant
DROP DATABASE IF EXISTS cars_database;
-- Création de la base de données
CREATE DATABASE cars_database OWNER iousco;

-- Utilisation de la base de données nouvellement créée
\c cars_database;

-- Création de la table "marque"
CREATE TABLE marque (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

-- Création de la table "voiture"
CREATE TABLE voiture (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    marque_id INTEGER REFERENCES marque(id)
);

COMMIT;
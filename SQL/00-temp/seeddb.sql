-- Insertion des marques
INSERT INTO marque (nom) VALUES ('Toyota'), ('Honda'), ('Ford'), ('BMW'), ('Mercedes');

-- Insertion des voitures
INSERT INTO voiture (nom, marque_id) VALUES
    ('Corolla', 1),
    ('Camry', 1),
    ('Civic', 2),
    ('Accord', 2),
    ('F150', 3),
    ('Mustang', 3),
    ('X5', 4),
    ('X3', 4),
    ('C-Class', 5),
    ('E-Class', 5);

---- Création de tables ------------- --
CREATE TABLE
    family (
        id INT GENERATED ALWAYS AS IDENTITY,
        name VARCHAR(160) NOT NULL,
        PRIMARY KEY (id)
    );
 
CREATE TABLE
    category (
        id INT GENERATED ALWAYS AS IDENTITY,
        name VARCHAR(160) NOT NULL,
        family_id INT NOT NULL,
        PRIMARY KEY (id),
        CONSTRAINT fk_family FOREIGN KEY (family_id) REFERENCES family (id)
    );
 
CREATE TABLE
    product (
        id INT GENERATED ALWAYS AS IDENTITY,
        name VARCHAR(160) NOT NULL,
        PRIMARY KEY (id)
    );
 
CREATE TABLE
    size (
        id INT GENERATED ALWAYS AS IDENTITY,
        name VARCHAR(160) NOT NULL,
        PRIMARY KEY (id)
    );
 
-- création de table intermédiaire entre category et product (MANY TO MANY)
CREATE TABLE
    category_product (
        category_id INT NOT NULL,
        product_id INT NOT NULL,
        CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category (id),
        CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product (id)
    );
 
-- delete de l'attribut NOT NULL de l'élément family_id
ALTER TABLE category
ALTER COLUMN family_id
DROP NOT NULL;
 
-- création de table intermédiaire entre family et product (MANY TO MANY)
CREATE TABLE
    family_product (
        family_id INT NOT NULL,
        product_id INT NOT NULL,
        CONSTRAINT fk_family FOREIGN KEY (family_id) REFERENCES family (id),
        CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product (id)
    );
 
-- delete table (changement de logique)
DROP TABLE family_product;
 
-- création de table intermédiaire entre product et size (MANY TO MANY)
CREATE TABLE
    product_size (
        product_id INT NOT NULL,
        size_id INT NOT NULL,
        CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product (id),
        CONSTRAINT fk_size FOREIGN KEY (size_id) REFERENCES size (id)
    );
 
-- ------------- Insertion de valeurs ------------- --
-- insertion de valeurs dans la table family
INSERT INTO
    family (name)
VALUES
    ('Nos menus'),
    ('Nos boissons');
 
SELECT
    *
FROM
    family;
 
--  id |     name
-- ----+--------------
--   1 | Nos menus
--   2 | Nos boissons
-- 
-- insertion de valeurs dans la table category
INSERT INTO
    category (name, family_id)
VALUES
    ('Menu Maxi Best Of', 1),
    ('Menu Best Of', 1),
    ('Mc First', 1),
    ('Happy Meal', 1),
    ('Nos Burgers', NULL),
    ('Boissons froides', 2),
    ('Boissons chaudes', 2);
 
-- vérification des insertions
SELECT
    *
FROM
    category;
 
--  id |       name        | family_id
-- ----+-------------------+-----------
--   1 | Menu Maxi Best Of |         1
--   2 | Menu Best Of      |         1
--   3 | Mc First          |         1
--   4 | Happy Meal        |         1
--   5 | Nos Burgers       |
--   6 | Boissons froides  |         2
--   7 | Boissons chaudes  |         2
-- 
-- delete toutes les lignes de la table category (mais laisse l'auto incrémentation de l'id)
DELETE FROM category;
 
-- remet l'id de category à 0
ALTER SEQUENCE category_id_seq
RESTART WITH 1;
 
-- insertion de valeurs dans la table product
INSERT INTO
    product (name)
VALUES
    ('Big Mac'),
    ('Mc First'),
    ('Hamburger'),
    ('Big Tasty'),
    ('Cheeseburger'),
    ('Coca'),
    ('Cappuccino');
 
SELECT
    *
FROM
    product;
 
--  id |     name
-- ----+--------------
--   1 | Big Mac
--   2 | Mc First
--   3 | Hamburger
--   4 | Big Tasty
--   5 | Cheeseburger
--   6 | Coca
--   7 | Cappuccino
-- 
-- 
-- insertion de valeurs dans la table size
INSERT INTO
    size (name)
VALUES
    ('25 cl'),
    ('40 cl'),
    ('50 cl');
 
SELECT
    *
FROM
    size;
 
--  id | name
-- ----+-------
--   1 | 25 cl
--   2 | 40 cl
--   3 | 50 cl
-- insertion dans category_product (1 = Big Mac et 1 = menu maxi best of, 2 = menu best of, 5 = nos burgers)
INSERT INTO
    category_product (product_id, category_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 5);
 
SELECT
    *
FROM
    category_product;
 
--  category_id | product_id
-- -------------+------------
--            1 |          1
--            2 |          1
--            5 |          1
-- 
-- 
-- insertion dans product_size (6 = Coca et 1 = 20cl, 2 = 40cl, 5 = 50cl)
INSERT INTO
    product_size (product_id, size_id)
VALUES
    (6, 1),
    (6, 2),
    (6, 3);
 
SELECT
    *
FROM
    product_size;
 
--     product_id | size_id
-- ------------+---------
--           6 |       1
--           6 |       2
--           6 |       3
-- 
-- 
-- ------------- Sélection de données provenant des tables ------------- --
-- SELECT l'id et le name de category, le name de produit
SELECT
    c.id,
    c.name AS category,
    p.name AS product
    -- FROM category (qu'on appelle c)
FROM
    category c
    -- on JOIN la table category_product (qu'on appelle cp) et category_id venant de la table category_product = id venant de la table category
    INNER JOIN category_product cp ON cp.category_id = c.id
    -- on JOIN la table product (qu'on appelle p) et id de la table product = product_id de la table category_product
    INNER JOIN product p ON p.id = cp.product_id;
 
--      id |     category      | product
-- ----+-------------------+---------
--   1 | Menu Maxi Best Of | Big Mac
--   2 | Menu Best Of      | Big Mac
--   5 | Nos Burgers       | Big Mac
-- 
-- 
-- 
-- SELECT l'id et le name de family, l'id et le name de category, le name de produit
SELECT
    f.id,
    f.name AS family,
    c.id,
    c.name AS category,
    p.name AS product
    -- FROM family (qu'on appelle f)
FROM
    family f
    -- on JOIN la table category en demandant avec RIGHT de nous donner aussi les category qui ne sont reliées à aucune family
    -- l'id de family = family_id de category
    RIGHT JOIN category c ON f.id = c.family_id
    -- on JOIN la table category_product (qu'on appelle cp) et category_id venant de la table category_product = id venant de la table category
    INNER JOIN category_product cp ON cp.category_id = c.id
    -- on JOIN la table product (qu'on appelle p) et id de la table product = product_id de la table category_product
    INNER JOIN product p ON p.id = cp.product_id;
 
--      id |  family   | id |     category      | product
-- ----+-----------+----+-------------------+---------
--   1 | Nos menus |  1 | Menu Maxi Best Of | Big Mac
--   1 | Nos menus |  2 | Menu Best Of      | Big Mac
--     |           |  5 | Nos Burgers       | Big Mac
-- 
-- 
-- En utilisant INNER JOIN au lieu de RIGHT JOIN
--  id |  family   | id |     category      | product
-- ----+-----------+----+-------------------+---------
--   1 | Nos menus |  1 | Menu Maxi Best Of | Big Mac
--   1 | Nos menus |  2 | Menu Best Of      | Big Mac
-- 
-- 
-- 
-- ------------- Création view de données provenant des tables ------------- --
CREATE VIEW
    Big_Mac AS
SELECT
    f.id,
    f.name AS family,
    c.name AS category,
    p.name AS product
FROM
    family f
    RIGHT JOIN category c ON f.id = c.family_id
    INNER JOIN category_product cp ON cp.category_id = c.id
    INNER JOIN product p ON p.id = cp.product_id;
 
SELECT
    *
FROM
    Big_Mac;
 
--  id |  family   |     category      | product
-- ----+-----------+-------------------+---------
--   1 | Nos menus | Menu Maxi Best Of | Big Mac
--   1 | Nos menus | Menu Best Of      | Big Mac
--     |           | Nos Burgers       | Big Mac
-- 
-- 
-- insère coca (product 6) dans boissons froides (category 6)
INSERT INTO
    category_product (product_id, category_id)
VALUES
    (6, 6);
 
SELECT
    *
FROM
    Big_Mac;
 
--  id |    family    |     category      | product
-- ----+--------------+-------------------+---------
--   1 | Nos menus    | Menu Maxi Best Of | Big Mac
--   1 | Nos menus    | Menu Best Of      | Big Mac
--     |              | Nos Burgers       | Big Mac
--   2 | Nos boissons | Boissons froides  | Coca
-- 
-- 
CREATE VIEW
    add_all_products AS
SELECT
    f.id,
    f.name AS family,
    c.name AS category,
    p.name AS product,
    s.name AS size
FROM
    family f
    RIGHT JOIN category c ON f.id = c.family_id
    INNER JOIN category_product cp ON cp.category_id = c.id
    INNER JOIN product p ON p.id = cp.product_id
    LEFT JOIN product_size ps ON ps.product_id = p.id
    LEFT JOIN size s ON s.id = ps.size_id;
 
--  id |    family    |     category      | product | size
-- ----+--------------+-------------------+---------+-------
--   1 | Nos menus    | Menu Maxi Best Of | Big Mac |
--   1 | Nos menus    | Menu Best Of      | Big Mac |
--     |              | Nos Burgers       | Big Mac |
--   2 | Nos boissons | Boissons froides  | Coca    | 50 cl
--   2 | Nos boissons | Boissons froides  | Coca    | 40 cl
--   2 | Nos boissons | Boissons froides  | Coca    | 25 cl
-- 
-- 
-- ------------- Mise à jour d'une valeur dans une table ------------- --
UPDATE product
SET
    name = 'Café allongé'
WHERE
    id = 7;
 
SELECT
    *
FROM
    product;
 
--   id |     name
-- ----+--------------
--   1 | Big Mac
--   2 | Mc First
--   3 | Hamburger
--   4 | Big Tasty
--   5 | Cheeseburger
--   6 | Coca
--   7 | Café allongé

CREATE VIEW Big_Mac AS SELECT f.id, f.name AS family, c.name AS category, p.name AS product FROM family f RIGHT JOIN category c ON f.id = c.family_id INNER JOIN category_product cp ON cp.category_id = c.id INNER JOIN product p ON p.id = cp.product_id;
 
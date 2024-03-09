CREATE VIEW big_mac AS
SELECT f.id, f.nom AS family, c.nom AS category, p.nom AS product
FROM family f
RIGHT JOIN category c
ON  f.id = c.family_id 
INNER JOIN category_product cp
ON   c.id = cp.category_id
INNER JOIN product p 
ON p.id=cp.product_id;

CREATE VIEW big_mac AS SELECT f.id, f.nom AS family, c.nom AS category, p.nom AS product FROM family f RIGHT JOIN category c ON  f.id = c.family_id INNER JOIN category_product cp ON   c.id = cp.category_id INNER JOIN product p ON p.id=cp.product_id;

CREATE VIEW add_all_product AS
SELECT f.id, f.nom AS family, c.nom AS category, p.nom AS product, s.nom AS size
FROM family f
RIGHT JOIN category c
ON  f.id = c.family_id 
INNER JOIN category_product cp
ON   c.id = cp.category_id
INNER JOIN product p 
ON p.id=cp.product_id
INNER JOIN size_product sp
ON sp.product_id=p.id
RIGHT JOIN size s
ON s.id = sp.size_id;

CREATE VIEW add_all_product AS SELECT f.id, f.nom AS family, c.nom AS category, p.nom AS product, s.nom AS size FROM family f RIGHT JOIN category c ON f.id = c.family_id LEFT JOIN category_product cp ON c.id = cp.category_id INNER JOIN product p ON p.id=cp.product_id INNER JOIN size_product sp ON sp.product_id=p.id RIGHT JOIN size s ON s.id = sp.size_id;

-- insérer un produit et le lier aux autres tables
WITH 
    new_product AS (
        INSERT INTO product (nom) VALUES ('coca light') RETURNING id
    ),
    size_id AS (
        SELECT id FROM size WHERE nom = '25cl'
    ),
    category_id AS (
        SELECT id FROM category WHERE nom = 'Nos boissons froides'
    ),
    family_id AS (
        SELECT id FROM family WHERE nom = 'Nos boissons'
    )
INSERT INTO category_product (category_id, product_id)
VALUES ((SELECT id FROM category_id), (SELECT id FROM new_product)),
       ((SELECT id FROM size_id), (SELECT id FROM new_product)),
       ((SELECT id FROM family_id), (SELECT id FROM new_product));


CREATE VIEW add_coca_light_small AS
WITH 
    new_product AS (
        INSERT INTO product (nom) VALUES ('coca light') RETURNING id
    ),
    size_id AS (
        SELECT id FROM size WHERE nom = '25cl'
    ),
    category_id AS (
        SELECT id FROM category WHERE nom = 'Nos boissons froides'
    ),
    family_id AS (
        SELECT id FROM family WHERE nom = 'Nos boissons'
    )
SELECT 
    (SELECT id FROM category_id) AS category_id,
    (SELECT id FROM new_product) AS product_id
UNION ALL
SELECT 
    (SELECT id FROM size_id) AS category_id,
    (SELECT id FROM new_product) AS product_id
UNION ALL
SELECT 
    (SELECT id FROM family_id) AS category_id,
    (SELECT id FROM new_product) AS product_id;
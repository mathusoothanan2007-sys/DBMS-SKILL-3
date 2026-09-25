CREATE DATABASE stock_control;
USE stock_control;

CREATE TABLE category(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE product(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY(category_id) REFERENCES category(category_id)
);

CREATE TABLE seller(
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE inventory(
    inventory_id INT PRIMARY KEY,
    product_id INT,
    seller_id INT,
    quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    FOREIGN KEY(product_id) REFERENCES product(product_id),
    FOREIGN KEY(seller_id) REFERENCES seller(seller_id),
    UNIQUE(product_id, seller_id)
);

INSERT INTO category VALUES
(1,'Computers'),
(2,'Stationery'),
(3,'Kitchen'),
(4,'Footwear'),
(5,'Books');

INSERT INTO product VALUES
(1,'Wireless Mouse',750,1),
(2,'Keyboard',1200,1),
(3,'USB Drive',600,1),
(4,'Notebook',120,2),
(5,'Pen Set',180,2),
(6,'Water Bottle',550,3),
(7,'Lunch Box',700,3),
(8,'Running Shoes',2200,4),
(9,'Sandals',950,4),
(10,'Python Basics',500,5);

INSERT INTO seller VALUES
(1,'Digital Point','9123456701','digitalpoint@gmail.com'),
(2,'Stationery Mart','9123456702','stationerymart@gmail.com'),
(3,'Kitchen Corner','9123456703','kitchencorner@gmail.com'),
(4,'Footwear World','9123456704','footwearworld@gmail.com'),
(5,'Book Basket','9123456705','bookbasket@gmail.com');

INSERT INTO inventory VALUES
(1,1,1,45,10),
(2,2,1,30,8),
(3,3,1,12,5),
(4,4,2,75,15),
(5,5,2,0,10),
(6,6,3,28,8),
(7,7,3,18,5),
(8,8,4,55,12),
(9,9,4,0,6),
(10,10,5,40,10);

-- CREATE
INSERT INTO seller VALUES
(6,'Smart Supplies','9123456706','smartsupplies@gmail.com');

INSERT INTO inventory VALUES
(11,2,6,22,6);

-- READ
SELECT * FROM seller;

SELECT * FROM inventory;

SELECT p.product_name, i.quantity
FROM product p
JOIN inventory i
ON p.product_id = i.product_id;

-- UPDATE
UPDATE inventory
SET quantity = 60
WHERE inventory_id = 1;

UPDATE seller
SET email = 'digitalpointnew@gmail.com'
WHERE seller_id = 1;

-- DELETE
DELETE FROM inventory
WHERE inventory_id = 11;

DELETE FROM seller
WHERE seller_id = 6;

-- TOTAL PRODUCTS AVAILABLE
SELECT COUNT(DISTINCT product_id) AS available_products
FROM inventory
WHERE quantity > 0;

-- PRODUCTS OUT OF STOCK
SELECT p.product_id, p.product_name
FROM product p
JOIN inventory i
ON p.product_id = i.product_id
WHERE i.quantity = 0;

-- HIGHEST STOCKED PRODUCT
SELECT p.product_name, i.quantity
FROM product p
JOIN inventory i
ON p.product_id = i.product_id
WHERE i.quantity = (
    SELECT MAX(quantity)
    FROM inventory
);

-- AVERAGE INVENTORY
SELECT AVG(quantity) AS average_stock
FROM inventory;

-- COMPLETE INVENTORY ANALYSIS
SELECT
    p.product_name,
    c.category_name,
    s.seller_name,
    i.quantity,
    i.reorder_level
FROM inventory i
JOIN product p
ON i.product_id = p.product_id
JOIN category c
ON p.category_id = c.category_id
JOIN seller s
ON i.seller_id = s.seller_id;

-- PRODUCTS BELOW REORDER LEVEL
SELECT
    p.product_name,
    i.quantity,
    i.reorder_level
FROM product p
JOIN inventory i
ON p.product_id = i.product_id
WHERE i.quantity < i.reorder_level;
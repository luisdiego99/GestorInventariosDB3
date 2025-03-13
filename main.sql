-- Due to PROCEDURE being deprecated in our current MySQL version, we decided to run all the script in this  file. 
-- Correct order to run scrip is the following: 
-- 1. Tables
-- 2. Triggers
-- 3. Procedures
-- 4. Data 
-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS inventory_manager_db;
USE inventory_manager_db;

-- 2. Create Tables
-- Create table stores 
CREATE TABLE IF NOT EXISTS stores (
    id_store INT AUTO_INCREMENT PRIMARY KEY, 
    name_store VARCHAR(50) NOT NULL, 
    max_storage INTEGER NOT NULL, 
    location VARCHAR(100) NOT NULL
);

-- Create table products  
CREATE TABLE IF NOT EXISTS products (
    id_product INT AUTO_INCREMENT PRIMARY KEY,
    sku_number VARCHAR(20) NOT NULL, 
    product_name VARCHAR(50) NOT NULL, 
    description VARCHAR(250) NOT NULL, 
    unit_price DECIMAL(10,2),
    id_store INT, 
    stock INTEGER NOT NULL, 
    store_location VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_store) REFERENCES stores(id_store) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create table users 
CREATE TABLE IF NOT EXISTS users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(25),
    rol VARCHAR(25),
    email VARCHAR(25)
);

-- Create table transactions 
CREATE TABLE IF NOT EXISTS transactions (
    id_transaction INT AUTO_INCREMENT PRIMARY KEY,
    date_transaction DATETIME,
    id_user INT,
    type_transaction VARCHAR(25),
    id_product INT,
    quantity INTEGER, 
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE CASCADE ON UPDATE CASCADE 
);

-- 3. Create Triggers
-- This trigger validates stock (for sales) and calculates subtotal before inserting a transaction.
DELIMITER $$
CREATE TRIGGER before_insert_transaction
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);
    DECLARE current_stock INT;

    -- Retrieve the unit price and current stock for the product
    SELECT unit_price, stock INTO product_price, current_stock
    FROM products 
    WHERE id_product = NEW.id_product
    LIMIT 1;

    -- For a sale, ensure there is enough stock
    IF NEW.type_transaction = 'Venta' AND current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Insufficient stock for sale';
    END IF;

    -- Calculate the subtotal based on the unit price and quantity
    IF product_price IS NOT NULL THEN
        SET NEW.subtotal = product_price * NEW.quantity;
    ELSE
        SET NEW.subtotal = 0;
    END IF;
END $$
DELIMITER ;

-- This trigger updates the product stock after a transaction is inserted.
DELIMITER $$
CREATE TRIGGER after_insert_transaction_stock
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.type_transaction = 'Compra' THEN
        UPDATE products 
        SET stock = stock + NEW.quantity
        WHERE id_product = NEW.id_product;
    ELSEIF NEW.type_transaction = 'Venta' THEN
        UPDATE products 
        SET stock = stock - NEW.quantity
        WHERE id_product = NEW.id_product;
    END IF;
END $$
DELIMITER ;

-- 4. Create Procedures
-- Procedure: Recalculates the subtotal for a given transaction (if needed)
DELIMITER $$
CREATE PROCEDURE calculate_subtotal(IN trans_id INT)
BEGIN
    UPDATE transactions t
    JOIN products p ON t.id_product = p.id_product
    SET t.subtotal = p.unit_price * t.quantity
    WHERE t.id_transaction = trans_id;
END $$
DELIMITER ;

-- Procedure: Recalculates the stock for a specific product based on its transactions
DELIMITER $$
CREATE PROCEDURE recalc_product_stock(IN prod_id INT)
BEGIN
    DECLARE total_purchases INT;
    DECLARE total_sales INT;

    SELECT IFNULL(SUM(CASE WHEN type_transaction = 'Compra' THEN quantity END), 0),
           IFNULL(SUM(CASE WHEN type_transaction = 'Venta' THEN quantity END), 0)
    INTO total_purchases, total_sales
    FROM transactions
    WHERE id_product = prod_id;

    UPDATE products 
    SET stock = total_purchases - total_sales
    WHERE id_product = prod_id;
END $$
DELIMITER ;

-- Procedure: Generates a sales report for a given date range
DELIMITER $$
CREATE PROCEDURE get_sales_report(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        p.product_name, 
        SUM(t.quantity) AS total_sold, 
        SUM(t.subtotal) AS total_revenue
    FROM transactions t
    JOIN products p ON t.id_product = p.id_product
    WHERE t.type_transaction = 'Venta'
      AND t.date_transaction BETWEEN start_date AND end_date
    GROUP BY p.product_name;
END $$
DELIMITER ;

-- 5. Populate Initial Data
-- Insert initial records into stores
INSERT INTO stores (name_store, max_storage, location) VALUES
('Almacén Central', 1000, 'Zona Industrial - Calle 12 #45'),
('Sucursal Centro', 500, 'Avenida Principal #234 - Centro'),
('Bodega Norte', 700, 'Carrera 15 #100 - Zona Norte'),
('Tienda Sur', 400, 'Plaza Comercial - Local 8 - Zona Sur'),
('Depósito Este', 600, 'Carretera Nacional km 20 - Este'),
('Almacén Express', 300, 'Calle Comercio #10 - Centro Histórico'),
('Sucursal Oeste', 450, 'Boulevard del Oeste #400'),
('Bodega Electrónica', 800, 'Sector Tecnológico - Pasillo 3'),
('Tienda Papelería', 350, 'Centro Escolar - Pasillo 1'),
('Mega Bodega Fitness', 900, 'Avenida Deportiva - Zona Fitness');

-- Insert initial records into products
INSERT INTO products (sku_number, product_name, description, unit_price, id_store, stock, store_location) VALUES
('SKU001', 'Ratón Inalámbrico', 'Ratón ergonómico inalámbrico con DPI ajustable.', 25.99, 1, 100, 'Pasillo 3'),
('SKU002', 'Cuaderno Universitario', 'Cuaderno universitario de 100 hojas con espiral.', 2.99, 3, 200, 'Pasillo 5'),
('SKU003', 'Bocina Bluetooth', 'Bocina portátil con conexión Bluetooth y batería de 10 horas.', 49.99, 2, 50, 'Pasillo 3'),
('SKU004', 'Cable USB-C', 'Cable de carga USB-C a USB-A de 1 metro.', 9.99, 1, 300, 'Pasillo 3'),
('SKU005', 'Teclado Mecánico', 'Teclado mecánico gamer con retroiluminación RGB.', 79.99, 1, 30, 'Pasillo 3'),
('SKU006', 'Silla de Oficina', 'Silla ergonómica ajustable con soporte lumbar.', 199.99, NULL, 15, 'Pasillo 5'),
('SKU007', 'Mochila Antirrobo', 'Mochila impermeable con compartimento acolchado para laptop.', 39.99, 3, 80, 'Pasillo 5'),
('SKU008', 'Lámpara LED', 'Lámpara LED de escritorio con control táctil y brillo ajustable.', 29.99, 2, 60, 'Pasillo 3'),
('SKU009', 'SSD Externo', 'SSD portátil de 500GB con transferencia rápida.', 89.99, 1, 40, 'Pasillo 3'),
('SKU010', 'Botella Térmica', 'Botella de acero inoxidable de 500ml.', 15.99, 3, 150, 'Pasillo 1');

-- Insert initial records into users
INSERT INTO users (username, rol, email) VALUES
('admin_master', 'admin', 'admin@empresa.com'),
('operador_juan', 'operator', 'juan@empresa.com'),
('operador_luisa', 'operator', 'luisa@empresa.com'),
('operador_karen', 'operator', 'karen@empresa.com'),
('operador_pedro', 'operator', 'pedro@empresa.com');

-- Insert initial records into transactions
-- (These will fire the triggers to calculate subtotal and update stock)
INSERT INTO transactions (date_transaction, id_user, type_transaction, id_product, quantity) VALUES
('2023-10-01 10:15:00', 1, 'Compra', 1, 22),
('2023-10-02 14:30:00', 2, 'Venta', 2, 10),
('2023-10-03 09:45:00', 3, 'Compra', 3, 3),
('2023-10-04 16:20:00', 4, 'Venta', 4, 10),
('2023-10-05 11:10:00', 5, 'Compra', 5, 10),
('2023-10-06 13:55:00', 1, 'Venta', 6, 4),
('2023-10-07 08:30:00', 3, 'Compra', 7, 2),
('2023-10-08 17:40:00', 2, 'Venta', 8, 30),
('2023-10-09 12:25:00', 4, 'Compra', 9, 1),
('2023-10-10 15:05:00', 5, 'Venta', 10, 2);

-- 6. (Optional) Verify Data
SELECT * FROM transactions;
SELECT * FROM products;

-- 7. Test Procedures
CALL calculate_subtotal(1);
CALL calculate_subtotal(5);

CALL recalc_product_stock(1);
CALL recalc_product_stock(3);
SELECT * FROM products WHERE id_product = 3;


CALL get_sales_report('2023-10-01', '2023-10-31');
CALL get_sales_report('2023-10-05', '2023-10-10');
-- Next one will show no results, since no transactions took place between these dates
CALL get_sales_report('2023-11-05', '2023-11-10');



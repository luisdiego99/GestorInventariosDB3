-- This script should be run once the tables have been created and populated

-- Checks if stock is available before a transaction takes place. Otherwise will raise an error. 
-- Calculates subtotal to add it to transactions table 
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


-- Updates stock once a transaction takes place 
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



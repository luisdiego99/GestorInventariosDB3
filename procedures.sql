-- This script should be run once the tables and triggers have been created. 
-- Procedure to calculate subtotal
USE inventory_manager_db;
DELIMITER $$

CREATE PROCEDURE calculate_subtotal(IN trans_id INT)
BEGIN
    UPDATE transactions t
    JOIN products p ON t.id_product = p.id_product
    SET t.subtotal = p.unit_price * t.quantity
    WHERE t.id_transaction = trans_id;
END $$

DELIMITER ;


-- Calcualtes the stock of a product based on sell and purchase transactions. 
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

-- Generates a sales report 
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

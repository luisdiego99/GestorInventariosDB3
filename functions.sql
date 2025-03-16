-- function: This function returns the current stock of a specific product.
DELIMITER $$
CREATE FUNCTION get_current_stock(prod_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;
    SELECT stock INTO stock_actual
    FROM products
    WHERE id_product = prod_id;
    RETURN stock_actual;
END $$  
DELIMITER ;

-- function: This function helps to know how much a product has generated in sales.
DELIMITER $$
CREATE FUNCTION get_total_revenue(prod_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(subtotal) INTO total 
    FROM transactions 
    WHERE id_product = prod_id AND type_transaction = 'Venta';
    RETURN IFNULL(total, 0);
END $$
DELIMITER ;

-- function: This feature allows you to know how much a specific store has sold.
DELIMITER $$
CREATE FUNCTION get_total_sales_by_store(store_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_sales DECIMAL(10,2);
    SELECT SUM(subtotal) INTO total_sales
    FROM transactions t
    JOIN products p ON t.id_product = p.id_product
    WHERE p.id_store = store_id AND t.type_transaction = 'Venta';
    RETURN IFNULL(total_sales, 0);
END $$
DELIMITER ;

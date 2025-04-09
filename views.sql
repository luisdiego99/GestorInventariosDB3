-- create view inventory_report Includes an overview of products
CREATE VIEW inventory_report AS
SELECT p.id_product, p.sku_number, p.product_name, p.unit_price, p.stock, s.name_store,t.subtotal
FROM products p
JOIN stores s ON p.id_store = s.id_store
LEFT JOIN transactions t ON t.id_product = p.id_product
ORDER BY p.product_name;

-- Use view inventory_report
SELECT * FROM inventory_report;

-- create view vista_productos_por_almacen Includes a report of products organized by warehouse and product details
CREATE VIEW vista_productos_por_almacen AS
SELECT s.name_store AS Almacen,
    p.store_location AS Ubicacion,
    p.product_name AS NombreProducto,
    p.stock AS StockActual
FROM products p
JOIN stores s ON p.id_store = s.id_store
ORDER BY s.name_store, p.store_location, p.product_name;
    
-- use view vista_productos_por_almacen 
SELECT * FROM vista_productos_por_almacen;

-- create view productos_stock_bajo Includes a search for products with low stock of less than 15 units
CREATE VIEW productos_stock_bajo AS
SELECT p.sku_number AS codigo,
	p.product_name AS nombre,
    p.stock AS stock_actual,
    p.unit_price AS precio_unitario,
    (p.stock * p.unit_price) AS valor_total
FROM products p
WHERE p.stock < 15;
    
-- use view productos_stock_bajo
SELECT * FROM productos_stock_bajo;

-- create view vista_productos_mas_vendidos Includes a detailed best-selling product report
CREATE VIEW vista_productos_mas_vendidos AS
SELECT p.sku_number AS CodigoProducto, 
p.product_name AS NombreProducto, 
SUM(t.quantity) AS CantidadVendida, 
SUM(t.subtotal) AS SubtotalGenerado
FROM transactions t
JOIN products p ON t.id_product = p.id_product
GROUP BY p.id_product 
ORDER BY CantidadVendida DESC;
    
-- use view vista_productos_mas_vendidos
SELECT * FROM vista_productos_mas_vendidos;

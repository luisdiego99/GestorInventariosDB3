-- This is the script to fill the tables with data once they have been created
-- Antes de correr este script, es necesario correr: creador_tablas.sql
USE inventory_manager_db;

-- Populate Store table 
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

-- Populate Products table 
INSERT INTO products (sku_number, product_name, description, unit_price, id_store, stock, store_location) VALUES
('SKU001', 'Ratón Inalámbrico', 'Ratón ergonómico inalámbrico con DPI ajustable.', 25.99, 1, 100, 'Pasillo 3'),
('SKU002', 'Cuaderno Universitario', 'Cuaderno universitario de 100 hojas con espiral.', 2.99, 3, 200, 'Pasillo 5'),
('SKU003', 'Bocina Bluetooth', 'Bocina portátil con conexión Bluetooth y batería de 10 horas.', 49.99, 2, 50, 'Pasillo 3'),
('SKU004', 'Cable USB-C', 'Cable de carga USB-C a USB-A de 1 metro.', 9.99, 1, 300, 'Pasillo 3'),
('SKU005', 'Teclado Mecánico', 'Teclado mecánico gamer con retroiluminación RGB.', 79.99, 1, 30, 'Pasillo 3'),
('SKU006', 'Silla de Oficina', 'Silla ergonómica ajustable con soporte lumbar.', 199.99, NULL, 15, 'Pasillo 5'),  -- NULL si no pertenece a un almacén específico
('SKU007', 'Mochila Antirrobo', 'Mochila impermeable con compartimento acolchado para laptop.', 39.99, 3, 80, 'Pasillo 5'),
('SKU008', 'Lámpara LED', 'Lámpara LED de escritorio con control táctil y brillo ajustable.', 29.99, 2, 60, 'Pasillo 3'),
('SKU009', 'SSD Externo', 'SSD portátil de 500GB con transferencia rápida.', 89.99, 1, 40, 'Pasillo 3'),
('SKU010', 'Botella Térmica', 'Botella de acero inoxidable de 500ml.', 15.99, 3, 150, 'Pasillo 1');

-- Populate Users table 
INSERT INTO users (username, rol, email) VALUES
('admin_master', 'admin', 'admin@empresa.com'),
('operador_juan', 'operator', 'juan@empresa.com'),
('operador_luisa', 'operator', 'luisa@empresa.com'),
('operador_karen', 'operator', 'karen@empresa.com'),
('operador_pedro', 'operator', 'pedro@empresa.com');

-- Populate Transactions table
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


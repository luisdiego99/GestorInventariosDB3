CREATE DATABASE IF NOT EXISTS inventory_manager_db;

USE inventory_manager_db;

-- Create table stores 
CREATE TABLE IF NOT EXISTS stores (
	id_store INT AUTO_INCREMENT PRIMARY KEY, 
    name_store VARCHAR(50) NOT NULL, 
    max_storage INTEGER NOT NULL, 
    location VARCHAR(100) NOT NULL
);

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

-- Create table users 
CREATE TABLE IF NOT EXISTS users (
	id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(25),
    rol VARCHAR(25),
    email VARCHAR(25)
);

INSERT INTO users (username, rol, email) VALUES
('admin_master', 'admin', 'admin@empresa.com'),
('operador_juan', 'operator', 'juan@empresa.com'),
('operador_luisa', 'operator', 'luisa@empresa.com'),
('operador_karen', 'operator', 'karen@empresa.com'),
('operador_pedro', 'operator', 'pedro@empresa.com');

-- Create table transactions 
CREATE TABLE IF NOT EXISTS transactions (
	id_transaction INT AUTO_INCREMENT PRIMARY KEY,
    date_transaction DATETIME,
    id_user INt,
    type_transaction VARCHAR(25),
    id_product INT,
    quantity INTEGER, 
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO transactions (date_transaction, id_user, type_transaction, id_product, quantity, subtotal) VALUES
('2023-10-01 10:15:00', 1, 'Compra', 1, 2, 50.00),
('2023-10-02 14:30:00', 2, 'Venta', 2, 1, 25.00),
('2023-10-03 09:45:00', 3, 'Compra', 3, 3, 75.00),
('2023-10-04 16:20:00', 4, 'Venta', 4, 2, 60.00),
('2023-10-05 11:10:00', 5, 'Compra', 5, 1, 30.00),
('2023-10-06 13:55:00', 1, 'Venta', 6, 4, 100.00),
('2023-10-07 08:30:00', 3, 'Compra', 7, 2, 40.00),
('2023-10-08 17:40:00', 2, 'Venta', 8, 3, 90.00),
('2023-10-09 12:25:00', 4, 'Compra', 9, 1, 20.00),
('2023-10-10 15:05:00', 5, 'Venta', 10, 2, 50.00);

-- Run this document to create DB and tables
CREATE DATABASE IF NOT EXISTS inventory_manager_db;
USE inventory_manager_db;

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
    id_user INt,
    type_transaction VARCHAR(25),
    id_product INT,
    quantity INTEGER, 
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE CASCADE ON UPDATE CASCADE 
);

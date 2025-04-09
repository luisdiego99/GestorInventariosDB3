
-- Modificando la tabla users para mejor manejo de roles. 
ALTER TABLE users
MODIFY COLUMN rol ENUM('admin', 'manager', 'operador') NOT NULL DEFAULT 'operador',
ADD COLUMN password_hash VARCHAR(255) NOT NULL,
ADD COLUMN is_active BOOLEAN DEFAULT TRUE;


-- Tabla de permisos
CREATE TABLE IF NOT EXISTS permissions (
	id_permission INT AUTO_INCREMENT PRIMARY KEY,
	permission_name VARCHAR(50) NOT NULL, 
	description VARCHAR (250)
);

-- Tabla de asignación de roles
CREATE TABLE IF NOT EXISTS role_permissions (
    id_role_permission INT AUTO_INCREMENT PRIMARY KEY,
    rol VARCHAR(25) NOT NULL,
    id_permission INT NOT NULL,
    FOREIGN KEY (id_permission) REFERENCES permissions(id_permission) ON DELETE CASCADE
);

-- INSERT con permisos basicos 
INSERT INTO permissions (permission_name, description) VALUES
('create_product', 'Permite crear nuevos productos'),
('update_product', 'Permite modificar productos existentes'),
('delete_product', 'Permite eliminar productos'),
('view_products', 'Permite ver el listado de productos'),
('create_transaction', 'Permite registrar nuevas transacciones'),
('view_reports', 'Permite ver reportes de ventas/inventario'),
('manage_users', 'Permite gestionar otros usuarios'); 

-- Asignando permisos a los roles
-- Admin: Todos los permisos
INSERT INTO role_permissions (rol, id_permission) VALUES
('admin', 1), ('admin', 2), ('admin', 3), ('admin', 4), ('admin', 5), ('admin', 6), ('admin', 7);

-- Manager: Todo excepto gestionar usuarios
INSERT INTO role_permissions (rol, id_permission) VALUES
('manager', 1), ('manager', 2), ('manager', 3), ('manager', 4), ('manager', 5), ('manager', 6);

-- Operator: Operaciones básicas
INSERT INTO role_permissions (rol, id_permission) VALUES
('operator', 4), ('operator', 5);

-- Procedimiento para verificar permisos 
DELIMITER $$
CREATE PROCEDURE check_permission(IN p_username VARCHAR(25), IN p_permission VARCHAR(50), OUT has_permission BOOLEAN)
BEGIN
    DECLARE user_role VARCHAR(25);
    
    -- Obtener el rol del usuario
    SELECT rol INTO user_role FROM users WHERE username = p_username AND is_active = TRUE;
    
    -- Verificar si el rol tiene el permiso
    SELECT COUNT(*) > 0 INTO has_permission
    FROM role_permissions rp
    JOIN permissions p ON rp.id_permission = p.id_permission
    WHERE rp.rol = user_role AND p.permission_name = p_permission;
END $$
DELIMITER ;

-- Modificar proceidmientos existentes para validar permisos
DELIMITER $$
CREATE PROCEDURE secure_create_product(
    IN p_username VARCHAR(25),
    IN p_sku VARCHAR(20),
    IN p_name VARCHAR(50),
    IN p_desc VARCHAR(250),
    IN p_price DECIMAL(10,2),
    IN p_store INT,
    IN p_stock INT,
    IN p_location VARCHAR(50)
)
BEGIN
    DECLARE has_perm BOOLEAN DEFAULT FALSE;
    
    CALL check_permission(p_username, 'create_product', has_perm);
    
    IF has_perm THEN
        INSERT INTO products (sku_number, product_name, description, unit_price, id_store, stock, store_location)
        VALUES (p_sku, p_name, p_desc, p_price, p_store, p_stock, p_location);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No tiene permisos para crear productos';
    END IF;
END $$
DELIMITER ;

-- Ejemplos de uso 
-- Verificar permisos
CALL check_permission('operador_juan', 'create_product', @has_perm);
SELECT @has_perm;

-- Intentar crear producto (solo funcionará para usuarios con permiso)
CALL secure_create_product('operador_juan', 'SKU011', 'Nuevo Producto', 'Descripción', 19.99, 1, 50, 'Pasillo 1');

-- Creacion de vistas para los permisos por usuario
CREATE VIEW user_permissions AS
SELECT u.username, u.rol, p.permission_name
FROM users u
JOIN role_permissions rp ON u.rol = rp.rol
JOIN permissions p ON rp.id_permission = p.id_permission
WHERE u.is_active = TRUE;
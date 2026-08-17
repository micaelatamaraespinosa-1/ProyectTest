-- 
-- Proyecto: Modelo Relacional de Ventas de Tecnología (Retail)
-- 

-- Limpieza preventiva de tablas si ya existen (en orden inverso a la creación)
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

-- 
-- DEFINICIÓN DEL ESQUEMA (DDL) Y RESTRICCIONES DE INTEGRIDAD

-- 1. Tabla de Categorías (Dimensión)
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Tabla de Clientes (Dimensión)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ciudad VARCHAR(50) NOT NULL
);

-- 3. Tabla de Productos (Dimensión en 3NF)
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_productos_categorias 
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 4. Tabla de Ventas (Tabla de Hechos)
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    CONSTRAINT fk_ventas_clientes 
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ventas_productos 
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


-- 
-- SECCIÓN 3: CARGA INICIAL DE DATOS (DML)

-- 1. Inserción de Categorías 
INSERT INTO categorias (nombre_categoria) VALUES
('Smartphones'),
('Laptops'),
('Accesorios');
COMMIT;

-- 2. Inserción de Productos 
INSERT INTO productos (nombre, precio, id_categoria) VALUES
('iPhone 15 Pro', 1200.00, 1),
('Samsung Galaxy S24', 950.00, 1),
('MacBook Air M2', 1100.00, 2),
('Dell XPS 13', 1050.00, 2),
('Auriculares Sony WH-1000XM5', 380.00, 3);
COMMIT;

-- 3. Inserción de Clientes
INSERT INTO clientes (nombre, email, ciudad) VALUES
('Juan Pérez', 'juan.perez@email.com', 'Buenos Aires'),
('María García', 'maria.garcia@email.com', 'Córdoba'),
('Carlos López', 'carlos.lopez@email.com', 'Rosario');
COMMIT;

-- 4. Inserción de Transacciones de Venta 
INSERT INTO ventas (fecha, id_cliente, id_producto, cantidad) VALUES
('2026-01-10', 1, 1, 1),
('2026-01-12', 2, 3, 1),
('2026-01-15', 3, 5, 2),
('2026-01-18', 1, 5, 1),
('2026-01-20', 2, 2, 1),
('2026-02-01', 3, 4, 1),
('2026-02-05', 1, 3, 1),
('2026-02-10', 2, 5, 3),
('2026-02-14', 3, 1, 1),
('2026-02-20', 1, 2, 2);
COMMIT;
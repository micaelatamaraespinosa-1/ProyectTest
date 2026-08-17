# Checkpoint: Script SQL de Ingeniería de Datos

## 📌 Contexto del Proyecto
Para obtener la certificación como **Data Analyst**, el entregable final consiste en un **Dashboard de Inteligencia de Negocios** orientado a responder preguntas estratégicas de una empresa de retail del sector tecnológico (**RetailPro**).

Dado que un dashboard depende directamente de la calidad e integridad de los datos que lo alimentan, este checkpoint constituye el **Back-End del proyecto**: el diseño y desarrollo de una base de datos relacional sólida, limpia y normalizada hasta la **Tercera Forma Normal (3NF)**.

---

## 🛠️ Arquitectura del Modelo de Datos

El modelo sigue un esquema en estrella (*Star Schema*) optimizado para análisis transaccional y posterior consumo en herramientas de BI (Power BI, Tableau, etc.).

### **Estructura de las Tablas**
1. **`categorias` (Dimensión):** Normaliza el catálogo para cumplir con 3NF, aislando la categoría como entidad propia.
2. **`clientes` (Dimensión):** Almacena la información demográfica y de registro de los compradores.
3. **`productos` (Dimensión):** Registra el catálogo de productos vinculando cada ítem a su correspondiente `id_categoria`.
4. **`ventas` (Tabla de Hechos):** Registrará el historial de transacciones, conectando las dimensiones mediante Claves Foráneas (`FK`).

+------------------+         +------------------+
|    categorias    |         |     clientes     |
+------------------+         +------------------+
| PK  id_categoria |         | PK  id_cliente   |
+--------+---------+         +--------+---------+
|                            |
| 1:N                        | 1:N
+--------v---------+                  |
|    productos     |                  |
+------------------+                  |
| PK  id_producto  |                  |
| FK  id_categoria |                  |
+--------+---------+                  |
|                            |
| 1:N                        |
+----------+      +----------+
|      |
+--v------v--+
|   ventas   |
+------------+
| PK id_venta|
| FK id_clie |
| FK id_prod |
+------------+


---

## 📋 Especificaciones Técnicas e Integridad Referencial

- **Claves Primarias (`PRIMARY KEY`):** Cada tabla posee una clave primaria autoincremental (`AUTO_INCREMENT`) que garantiza la unicidad de sus registros.
- **Claves Foráneas (`FOREIGN KEY`):** Se definieron restricciones de integridad referencial en las tablas `productos` y `ventas`, impidiendo el registro de ventas con clientes o productos inexistentes.
- **Restricciones de Calidad:**
  - `NOT NULL` en campos críticos (`precio`, `nombre`, `fecha`, etc.).
  - `UNIQUE` en emails y nombres de categorías para evitar duplicados.
  - `CHECK` para asegurar cantidades vendidas mayores a cero (`cantidad > 0`).
  - Tipo de dato `DECIMAL(10,2)` para los precios, evitando pérdida de precisión decimal en cálculos financieros (`SUM`, `AVG`).

---

## 💻 Script SQL (`script_retail.sql`)

```sql
-- ============================================================================
-- CHECKPOINT: SCRIPT SQL DE INGENIERÍA DE DATOS
-- Proyecto: Modelo Relacional de Ventas de Tecnología (RetailPro)
-- ============================================================================

-- 0. Limpieza preventiva (en orden inverso al de creación)
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

-- ============================================================================
-- SECCIÓN 1 Y 2: DEFINICIÓN DEL ESQUEMA (DDL) Y RESTRICCIONES DE INTEGRIDAD
-- ============================================================================

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

-- ============================================================================
-- SECCIÓN 3: CARGA INICIAL DE DATOS (DML)
-- ============================================================================

-- 1. Inserción de Categorías
INSERT INTO categorias (nombre_categoria) VALUES
('Smartphones'),
('Laptops'),
('Accesorios');

-- 2. Inserción de Productos
INSERT INTO productos (nombre, precio, id_categoria) VALUES
('iPhone 15 Pro', 1200.00, 1),
('Samsung Galaxy S24', 950.00, 1),
('MacBook Air M2', 1100.00, 2),
('Dell XPS 13', 1050.00, 2),
('Auriculares Sony WH-1000XM5', 380.00, 3);

-- 3. Inserción de Clientes
INSERT INTO clientes (nombre, email, ciudad) VALUES
('Juan Pérez', 'juan.perez@email.com', 'Buenos Aires'),
('María García', 'maria.garcia@email.com', 'Córdoba'),
('Carlos López', 'carlos.lopez@email.com', 'Rosario');

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
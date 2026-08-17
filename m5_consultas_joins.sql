-- CONSULTAS CON JOINS Y UNIONES - RETAILPRO

-- 1. Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN territorios t ON c.id_territorio = t.id_territorio;


-- 2. Clientes sin ventas (LEFT JOIN)
SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- 3. Productos sin ventas (LEFT JOIN)
SELECT 
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- 4. Consolidado por canal (UNION ALL)
WITH ventas_consolidadas AS (
    SELECT 
        id_venta,
        cantidad,
        precio_unitario,
        'Online' AS canal
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT 
        id_venta,
        cantidad,
        precio_unitario,
        'Presencial' AS canal
    FROM ventas
    WHERE canal = 'Presencial'
)
SELECT 
    canal,
    COUNT(id_venta) AS total_operaciones,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas_consolidadas
GROUP BY canal;

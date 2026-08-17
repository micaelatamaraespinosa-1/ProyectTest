-- CONSULTAS SQL DE NEGOCIO

-- 1. Resumen ejecutivo mensual
-- Muestra el total facturado, cantidad de pedidos y ticket promedio por mes.
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;


-- 2. Ranking de productos
-- Identifica los 5 productos con mayor facturación y sus unidades vendidas.
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;


-- 3. Clientes recurrentes
-- Muestra los clientes con más de un pedido, sus compras y el total gastado.
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- 4. Meses por encima/por debajo del promedio
-- Compara la facturación mensual contra la media mensual general de la empresa.
WITH ventas_mensuales AS (
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_mensuales) 
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_respecto_promedio
FROM ventas_mensuales
ORDER BY mes;

-- 1. Concentración de Ingresos en Top Productos:
--    El producto con id_producto = 1 y id_producto = 3 representan más del 50% 
--    de la facturación total, demostrando una alta dependencia comercial de pocos ítems.
--
-- 2. Estacionalidad y Desempeño Mensual:
--    Se observa un incremento significativo en la facturación a partir del mes 2 (Febrero), 
--    posicionándolo 'Por encima' del promedio mensual general, impulsado por pedidos corporativos.
--
-- 3. Comportamiento de Clientes Recurrentes:
--    Los clientes recurrentes (id_cliente con más de 1 pedido) representan el mayor porcentaje 
--    del volumen facturado, lo que justifica enfocar estrategias en fidelización y retención.

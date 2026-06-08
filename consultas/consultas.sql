-- consultas.sql - 14 consultas obligatorias del proyecto NexShop
USE nexshop;

-- 1. Muestra todos los empleados registrados para revisar la plantilla y sus roles.
SELECT *
FROM empleados;

-- 2. Muestra solo nombre, apellidos y email de los clientes registrados.
SELECT nombre, apellidos, email
FROM clientes;

-- 3. Muestra los pedidos online que siguen en estado pendiente.
SELECT *
FROM pedidos_online
WHERE estado = 'PENDIENTE';

-- 4. Busca productos cuyo nombre contiene la palabra "Portatil".
SELECT id_producto, sku, nombre
FROM productos
WHERE nombre LIKE '%Portatil%';

-- 5. Busca clientes cuyo nombre empieza por la letra A.
SELECT id_cliente, nombre, apellidos, email
FROM clientes
WHERE nombre LIKE 'A%';

-- 6. Muestra pedidos online realizados entre dos fechas concretas.
SELECT id_pedido, id_cliente, fecha_pedido, estado, total_final
FROM pedidos_online
WHERE DATE(fecha_pedido) BETWEEN '2024-03-01' AND '2024-03-31';

-- 7. Muestra productos con PVP actual entre 50 y 1000 euros.
SELECT p.id_producto, p.nombre, pp.pvp
FROM productos p
JOIN precios_producto pp ON pp.id_producto = p.id_producto
WHERE pp.fecha_fin IS NULL
  AND pp.pvp BETWEEN 50 AND 1000;

-- 8. Muestra lineas de pedido online con cantidad superior a 1 unidad.
SELECT id_linea_pedido, id_pedido, id_producto, cantidad, subtotal
FROM pedido_online_lineas
WHERE cantidad > 1;

-- 9. Ordena los pedidos online del mas antiguo al mas reciente.
SELECT id_pedido, fecha_pedido, estado, total_final
FROM pedidos_online
ORDER BY fecha_pedido ASC;

-- 10. Ordena los productos por su PVP actual de mayor a menor.
SELECT p.id_producto, p.nombre, pp.pvp
FROM productos p
JOIN precios_producto pp ON pp.id_producto = p.id_producto
WHERE pp.fecha_fin IS NULL
ORDER BY pp.pvp DESC;

-- 11. Ordena alfabeticamente los clientes por nombre y apellidos.
SELECT id_cliente, nombre, apellidos, email
FROM clientes
ORDER BY nombre ASC, apellidos ASC;

-- 12. Actualiza un pedido concreto para pasarlo a preparacion.
UPDATE pedidos_online
SET estado = 'PREPARACION'
WHERE id_pedido = 3;

-- 13. Actualiza el email de un cliente identificado por su id.
UPDATE clientes
SET email = 'aina.sanchez.nuevo@example.com'
WHERE id_cliente = 1;

-- 14. Combina clientes y pedidos online para ver que cliente realizo cada pedido.
SELECT c.id_cliente, c.nombre, c.apellidos, p.id_pedido, p.fecha_pedido, p.estado, p.total_final
FROM clientes c
JOIN pedidos_online p ON p.id_cliente = c.id_cliente
ORDER BY p.fecha_pedido DESC;

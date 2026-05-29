-- datos.sql - Datos ficticios realistas para probar NexShop
USE nexshop;

INSERT INTO ubicaciones (id_ubicacion, nombre, tipo, direccion, codigo_postal, ciudad, provincia, pais, activa) VALUES
(1, 'Almacen central Valencia', 'ALMACEN_CENTRAL', 'Av. Logistica 10', '46980', 'Valencia', 'Valencia', 'Espana', TRUE),
(2, 'Tienda Valencia Centro', 'TIENDA', 'Calle Colon 25', '46004', 'Valencia', 'Valencia', 'Espana', TRUE),
(3, 'Tienda Madrid Norte', 'TIENDA', 'Calle Serrano 88', '28006', 'Madrid', 'Madrid', 'Espana', TRUE),
(4, 'Tienda Barcelona Eixample', 'TIENDA', 'Carrer Arago 210', '08011', 'Barcelona', 'Barcelona', 'Espana', TRUE);

INSERT INTO empleados (id_empleado, nombre, apellidos, dni, email_corporativo, fecha_incorporacion, rol, id_ubicacion) VALUES
(1, 'Ana', 'Ferrer', '12345678A', 'a.ferrer@nexshop.es', '2016-02-01', 'DIRECCION', 1),
(2, 'David', 'Cano', '23456789B', 'd.cano@nexshop.es', '2017-05-15', 'LOGISTICA', 1),
(3, 'Laura', 'Pons', '34567890C', 'l.pons@nexshop.es', '2018-03-20', 'ATENCION_CLIENTE', 1),
(4, 'Sergio', 'Blanco', '45678901D', 's.blanco@nexshop.es', '2019-01-10', 'IT', 1),
(5, 'Marta', 'Rios', '56789012E', 'm.rios@nexshop.es', '2020-09-01', 'COMERCIAL', 1),
(6, 'Javier', 'Moreno', '67890123F', 'j.moreno@nexshop.es', '2021-04-12', 'VENDEDOR', 2),
(7, 'Paula', 'Garcia', '78901234G', 'p.garcia@nexshop.es', '2021-06-10', 'ENCARGADO_TIENDA', 3),
(8, 'Ruben', 'Soler', '89012345H', 'r.soler@nexshop.es', '2022-10-03', 'RESPONSABLE_ALMACEN', 4),
(9, 'Nuria', 'Marti', '90123456J', 'n.marti@nexshop.es', '2023-02-01', 'COMPRAS', 1);

INSERT INTO categorias (id_categoria, nombre, descripcion) VALUES
(1, 'Informatica', 'Equipos, perifericos y accesorios informaticos'),
(2, 'Telefonia', 'Moviles y accesorios'),
(3, 'Hogar inteligente', 'Dispositivos conectados para el hogar');

INSERT INTO subcategorias (id_subcategoria, id_categoria, id_subcategoria_padre, nombre, descripcion) VALUES
(1, 1, NULL, 'Portatiles', 'Ordenadores portatiles'),
(2, 1, 1, 'Portatiles gaming', 'Portatiles de alto rendimiento'),
(3, 1, 1, 'Portatiles oficina', 'Portatiles para uso profesional'),
(4, 1, NULL, 'Perifericos', 'Teclados, ratones y monitores'),
(5, 2, NULL, 'Smartphones', 'Telefonos inteligentes'),
(6, 3, NULL, 'Iluminacion smart', 'Bombillas y tiras LED conectadas');

INSERT INTO productos (id_producto, sku, nombre, descripcion, id_subcategoria, activo) VALUES
(1, 'NX-LAP-G15', 'Portatil Gaming NX G15', 'Portatil gaming 15 pulgadas con GPU dedicada', 2, TRUE),
(2, 'NX-LAP-O14', 'Portatil Oficina NX O14', 'Portatil ligero para oficina y teletrabajo', 3, TRUE),
(3, 'NX-MOU-WL', 'Raton inalambrico NX', 'Raton ergonomico Bluetooth', 4, TRUE),
(4, 'NX-MON-27', 'Monitor 27 pulgadas NX', 'Monitor IPS 27 pulgadas QHD', 4, TRUE),
(5, 'NX-PHONE-X', 'Smartphone NX Phone X', 'Movil 5G con 128 GB', 5, TRUE),
(6, 'NX-BULB-RGB', 'Bombilla Smart RGB NX', 'Bombilla LED RGB controlable por app', 6, TRUE);

INSERT INTO precios_producto (id_precio, id_producto, pvp, fecha_inicio, fecha_fin) VALUES
(1, 1, 1299.00, '2024-01-01', '2024-05-31'),
(2, 1, 1199.00, '2024-06-01', NULL),
(3, 2, 799.00, '2024-01-01', NULL),
(4, 3, 29.90, '2024-01-01', NULL),
(5, 4, 259.00, '2024-01-01', NULL),
(6, 5, 699.00, '2024-01-01', NULL),
(7, 6, 19.90, '2024-01-01', NULL);

INSERT INTO promociones (id_promocion, nombre, descripcion, descuento_porcentaje, fecha_inicio, fecha_fin) VALUES
(1, 'Semana Gaming', 'Descuento en productos gaming', 15.00, '2024-03-01', '2024-03-10'),
(2, 'Vuelta a la oficina', 'Promocion para portatiles y perifericos', 10.00, '2024-09-01', '2024-09-15'),
(3, 'Black Friday', 'Descuento especial de noviembre', 20.00, '2024-11-20', '2024-11-30');

INSERT INTO promocion_productos (id_promocion, id_producto) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 4),
(3, 5);

INSERT INTO proveedores (id_proveedor, nombre, cif, telefono, email, direccion, ciudad, pais, id_representante) VALUES
(1, 'TechIberia Mayoristas S.L.', 'B12345678', '960111222', 'ventas@techiberia.es', 'Poligono Norte 5', 'Valencia', 'Espana', 5),
(2, 'EuroGadget Distribution', 'B87654321', '910333444', 'comercial@eurogadget.eu', 'Calle Industria 14', 'Madrid', 'Espana', 5),
(3, 'SmartHome Supplies', 'B11223344', '930555666', 'info@smarthomesupplies.es', 'Carrer Energia 9', 'Barcelona', 'Espana', 5);

INSERT INTO condiciones_proveedor_producto (id_condicion, id_proveedor, id_producto, precio_coste, plazo_entrega_dias, fecha_inicio, fecha_fin) VALUES
(1, 1, 1, 890.00, 5, '2024-01-01', '2024-05-31'),
(2, 1, 1, 840.00, 4, '2024-06-01', NULL),
(3, 1, 2, 520.00, 4, '2024-01-01', NULL),
(4, 2, 1, 860.00, 6, '2024-06-01', NULL),
(5, 2, 5, 480.00, 3, '2024-01-01', NULL),
(6, 3, 6, 8.50, 2, '2024-01-01', NULL),
(7, 2, 3, 12.00, 3, '2024-01-01', NULL),
(8, 1, 4, 170.00, 4, '2024-01-01', NULL);

INSERT INTO pedidos_proveedor (id_pedido_proveedor, id_proveedor, id_ubicacion_destino, id_empleado_compras, fecha_pedido, estado, total_estimado) VALUES
(1, 1, 1, 9, '2024-02-15', 'RECIBIDO', 17800.00),
(2, 2, 1, 9, '2024-06-05', 'CONFIRMADO', 9600.00),
(3, 3, 1, 9, '2024-06-07', 'SOLICITADO', 850.00);

INSERT INTO pedido_proveedor_lineas (id_pedido_proveedor, id_producto, cantidad, precio_coste_unitario) VALUES
(1, 1, 10, 890.00),
(1, 2, 15, 520.00),
(2, 5, 20, 480.00),
(3, 6, 100, 8.50);

INSERT INTO clientes (id_cliente, nombre, apellidos, email, password_hash, fecha_nacimiento, fecha_registro) VALUES
(1, 'Aina', 'Sanchez Roig', 'aina.sanchez@example.com', 'hash_demo_aina', '1995-04-12', '2024-01-20 10:15:00'),
(2, 'Carlos', 'Lopez Perez', 'carlos.lopez@example.com', 'hash_demo_carlos', '1988-11-02', '2024-02-05 18:33:00'),
(3, 'Mireia', 'Torres Vidal', 'mireia.torres@example.com', 'hash_demo_mireia', NULL, '2024-03-01 09:00:00'),
(4, 'Alejandro', 'Ruiz Gomez', 'alejandro.ruiz@example.com', 'hash_demo_alejandro', '1992-07-19', '2024-03-15 12:20:00');

INSERT INTO direcciones_cliente (id_direccion, id_cliente, alias, calle, numero, piso, codigo_postal, ciudad, provincia, pais, es_predeterminada) VALUES
(1, 1, 'Domicilio', 'Calle Mar', '12', '3A', '46001', 'Valencia', 'Valencia', 'Espana', TRUE),
(2, 1, 'Trabajo', 'Av. Francia', '33', '5B', '46023', 'Valencia', 'Valencia', 'Espana', FALSE),
(3, 2, 'Domicilio', 'Calle Alcala', '101', '2C', '28009', 'Madrid', 'Madrid', 'Espana', TRUE),
(4, 3, 'Domicilio', 'Carrer Mallorca', '55', '1A', '08029', 'Barcelona', 'Barcelona', 'Espana', TRUE),
(5, 4, 'Domicilio', 'Calle Mayor', '7', NULL, '28013', 'Madrid', 'Madrid', 'Espana', TRUE);

INSERT INTO pedidos_online (id_pedido, id_cliente, id_direccion_envio, fecha_pedido, estado, total_productos, puntos_canjeados, descuento_puntos_eur, total_final) VALUES
(1, 1, 1, '2024-03-02 11:10:00', 'ENTREGADO', 1134.05, 0, 0.00, 1134.05),
(2, 2, 3, '2024-03-08 17:45:00', 'ENVIADO', 699.00, 500, 5.00, 694.00),
(3, 3, 4, '2024-06-10 09:20:00', 'PENDIENTE', 49.80, 0, 0.00, 49.80),
(4, 4, 5, '2024-09-05 14:05:00', 'PAGADO', 746.01, 0, 0.00, 746.01);

INSERT INTO pedido_online_lineas (id_linea_pedido, id_pedido, id_producto, cantidad, precio_unitario_pvp, descuento_promocion_pct, subtotal) VALUES
(1, 1, 1, 1, 1299.00, 15.00, 1104.15),
(2, 1, 3, 1, 29.90, 0.00, 29.90),
(3, 2, 5, 1, 699.00, 0.00, 699.00),
(4, 3, 3, 1, 29.90, 0.00, 29.90),
(5, 3, 6, 1, 19.90, 0.00, 19.90),
(6, 4, 2, 1, 799.00, 10.00, 719.10),
(7, 4, 3, 1, 29.90, 10.00, 26.91);

INSERT INTO transportistas (id_transportista, nombre, telefono, email) VALUES
(1, 'RapidShip', '900100200', 'soporte@rapidship.es'),
(2, 'Correos Express', '900300400', 'clientes@correosexpress.es'),
(3, 'EcoMensajeria', '900500600', 'info@ecomensajeria.es');

INSERT INTO envios (id_envio, id_pedido, id_ubicacion_origen, id_transportista, numero_seguimiento, fecha_salida, fecha_estimada_entrega, estado) VALUES
(1, 1, 1, 1, 'RS-20240302-001', '2024-03-02 16:00:00', '2024-03-04', 'ENTREGADO'),
(2, 1, 2, 1, 'RS-20240302-002', '2024-03-02 18:30:00', '2024-03-04', 'ENTREGADO'),
(3, 2, 3, 2, 'CE-20240308-010', '2024-03-09 10:00:00', '2024-03-11', 'EN_TRANSITO'),
(4, 4, 1, 3, 'EC-20240905-020', NULL, '2024-09-08', 'PENDIENTE');

INSERT INTO envio_lineas (id_envio, id_producto, cantidad) VALUES
(1, 1, 1),
(2, 3, 1),
(3, 5, 1),
(4, 2, 1),
(4, 3, 1);

INSERT INTO ventas_presenciales (id_venta, id_ubicacion, id_empleado, id_cliente, codigo_cliente_invitado, fecha_venta, metodo_pago, total) VALUES
(1, 2, 6, NULL, 'INV-VAL-0001', '2024-03-06 12:05:00', 'TARJETA', 259.00),
(2, 3, 7, 2, NULL, '2024-03-10 18:12:00', 'EFECTIVO', 49.80),
(3, 4, 8, NULL, 'INV-BCN-0007', '2024-04-02 11:25:00', 'TARJETA', 699.00);

INSERT INTO venta_presencial_lineas (id_linea_venta, id_venta, id_producto, cantidad, precio_unitario, descuento_pct, subtotal) VALUES
(1, 1, 4, 1, 259.00, 0.00, 259.00),
(2, 2, 3, 1, 29.90, 0.00, 29.90),
(3, 2, 6, 1, 19.90, 0.00, 19.90),
(4, 3, 5, 1, 699.00, 0.00, 699.00);

INSERT INTO devoluciones_presenciales (id_devolucion_presencial, id_venta, id_empleado, fecha_devolucion, motivo, importe_total) VALUES
(1, 2, 7, '2024-03-12 10:30:00', 'El cliente cambia la bombilla smart por incompatibilidad', 19.90);

INSERT INTO devolucion_presencial_lineas (id_linea_devolucion, id_devolucion_presencial, id_producto, cantidad, importe_linea) VALUES
(1, 1, 6, 1, 19.90);

INSERT INTO tickets_incidencia (id_ticket, id_cliente, id_pedido, id_agente, asunto, descripcion, fecha_apertura, estado, fecha_cierre, nota_resolucion, tipo) VALUES
(1, 1, 1, 3, 'Consulta sobre envio parcial', 'La clienta pregunta por que recibio dos numeros de seguimiento.', '2024-03-03 09:10:00', 'RESUELTO', '2024-03-03 12:00:00', 'Se explica que el pedido salio desde dos ubicaciones por stock.', 'CONSULTA'),
(2, 2, 2, 3, 'Devolucion de smartphone', 'El cliente solicita devolver el smartphone por fallo de bateria.', '2024-03-12 16:30:00', 'EN_GESTION', NULL, NULL, 'DEVOLUCION_ONLINE'),
(3, NULL, NULL, 3, 'Horario tienda Madrid', 'Consulta general sin cliente registrado.', '2024-03-14 10:00:00', 'ABIERTO', NULL, NULL, 'CONSULTA');

INSERT INTO devoluciones_online (id_devolucion_online, id_ticket, id_pedido, fecha_solicitud, estado, importe_estimado) VALUES
(1, 2, 2, '2024-03-12 16:45:00', 'SOLICITADA', 699.00);

INSERT INTO devolucion_online_lineas (id_linea_devolucion_online, id_devolucion_online, id_producto, cantidad, motivo, importe_linea) VALUES
(1, 1, 5, 1, 'Fallo de bateria comunicado por el cliente', 699.00);

INSERT INTO envios_recogida (id_recogida, id_devolucion_online, id_transportista, numero_seguimiento, fecha_solicitud, fecha_estimada_recogida, estado) VALUES
(1, 1, 2, 'CE-REC-20240312-001', '2024-03-12 17:00:00', '2024-03-14', 'SOLICITADA');

INSERT INTO stock_ubicacion (id_ubicacion, id_producto, stock_actual, stock_minimo) VALUES
(1, 1, 14, 5), (1, 2, 20, 5), (1, 3, 120, 20), (1, 4, 15, 5), (1, 5, 18, 5), (1, 6, 200, 30),
(2, 1, 2, 1), (2, 2, 4, 1), (2, 3, 25, 5), (2, 4, 3, 1), (2, 5, 2, 1), (2, 6, 30, 5),
(3, 1, 1, 1), (3, 2, 5, 1), (3, 3, 15, 5), (3, 4, 4, 1), (3, 5, 8, 2), (3, 6, 12, 5),
(4, 1, 1, 1), (4, 2, 3, 1), (4, 3, 18, 5), (4, 4, 2, 1), (4, 5, 4, 2), (4, 6, 20, 5);

INSERT INTO transferencias_stock (id_transferencia, id_ubicacion_origen, id_ubicacion_destino, id_producto, cantidad, fecha_transferencia, id_empleado_autoriza, estado) VALUES
(1, 1, 3, 1, 2, '2024-03-07 09:00:00', 2, 'RECIBIDA'),
(2, 2, 4, 3, 5, '2024-04-01 13:30:00', 2, 'ENVIADA');

INSERT INTO valoraciones (id_valoracion, id_cliente, id_producto, puntuacion, comentario, fecha_valoracion, verificada) VALUES
(1, 1, 1, 5, 'Muy buen rendimiento para juegos.', '2024-03-08 20:15:00', TRUE),
(2, 2, 5, 2, 'La bateria fallo a los pocos dias.', '2024-03-12 18:00:00', TRUE),
(3, 3, 6, 4, 'Buena bombilla para el precio.', '2024-03-20 09:30:00', FALSE);

INSERT INTO movimientos_puntos (id_movimiento, id_cliente, id_pedido, tipo, puntos, fecha_movimiento, descripcion) VALUES
(1, 1, 1, 'GANADO', 11340, '2024-03-02 11:10:00', 'Puntos ganados por pedido online 1'),
(2, 2, 2, 'CANJEADO', 500, '2024-03-08 17:45:00', 'Puntos canjeados en pedido online 2'),
(3, 2, 2, 'GANADO', 6940, '2024-03-08 17:45:00', 'Puntos ganados por pedido online 2'),
(4, 4, 4, 'GANADO', 7460, '2024-09-05 14:05:00', 'Puntos ganados por pedido online 4');

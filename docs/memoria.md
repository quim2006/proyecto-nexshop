# Memoria de análisis

# NexShop Group S.A.

## 1. Enfoque general

El modelo se ha construido a partir del texto del cliente. La prioridad ha sido no dejar sin representar ninguna entidad o relación relevante del enunciado: tienda online, tiendas físicas, empleados, catálogo, proveedores, precios históricos, promociones, pedidos, envíos parciales, stock por ubicación, transferencias, tickets, devoluciones, valoraciones y fidelización.

Para cada tabla he usado uno de estos criterios:

- **Lo pide el cliente:** aparece explícitamente o se deduce directamente del funcionamiento descrito.
- **Lo propongo yo:** no aparece como tabla literal, pero es necesaria para mantener integridad, resolver una relación N:M, guardar histórico o separar procesos distintos.

## 2. Entidades identificadas y justificación

| Entidad / tabla | Motivo | Justificación resumida |
|---|---|---|
| `ubicaciones` | Lo pide el cliente | Almacén central y tiendas físicas; stock, empleados, envíos y transferencias dependen de la ubicación. |
| `empleados` | Lo pide el cliente | Empleado de venta presencial, agente de ticket, autorizador de transferencia y representante comercial. |
| `categorias` | Lo pide el cliente | Catálogo organizado en categorías. |
| `subcategorias` | Lo pide el cliente | Cada producto pertenece a una única subcategoría; se permite jerarquía para Portátiles > Gaming/Oficina. |
| `productos` | Lo pide el cliente | Referencias del catálogo compartido por tienda online y tiendas físicas. |
| `precios_producto` | Lo pide el cliente | Histórico de PVP con vigencias porque el precio cambia con el tiempo. |
| `promociones` | Lo pide el cliente | Descuentos porcentuales durante rangos de fechas. |
| `promocion_productos` | Lo propongo yo | Tabla intermedia para resolver la relación N:M entre promociones y productos. |
| `proveedores` | Lo pide el cliente | Suministran productos al almacén central. |
| `condiciones_proveedor_producto` | Lo pide el cliente | Producto con varios proveedores y condiciones históricas de coste/plazo. |
| `pedidos_proveedor` | Lo pide el cliente | La sede central coordina pedidos a proveedores. |
| `pedido_proveedor_lineas` | Lo propongo yo | Un pedido a proveedor puede incluir varios productos. |
| `clientes` | Lo pide el cliente | Clientes registrados online con datos personales y fecha de nacimiento opcional. |
| `direcciones_cliente` | Lo pide el cliente | Un cliente puede guardar múltiples direcciones. |
| `pedidos_online` | Lo propongo yo | Pedido online con cliente, dirección, estado y totales. |
| `pedido_online_lineas` | Lo propongo yo | Un pedido contiene varios productos y cantidades. |
| `transportistas` | Lo pide el cliente | Cada envío tiene transportista; la propia tabla evita duplicidad. |
| `envios` | Lo propongo yo | Un pedido online puede generar varios envíos parciales. |
| `envio_lineas` | Lo pide el cliente | Permite saber qué productos van en cada envío parcial. |
| `ventas_presenciales` | Lo propongo yo | Tickets de venta en tienda, distintos de pedidos online. |
| `venta_presencial_lineas` | Lo pide el cliente | Un ticket presencial puede incluir varios productos. |
| `devoluciones_presenciales` | Lo pide el cliente | Devoluciones de tienda vinculadas al ticket original. |
| `devolucion_presencial_lineas` | Lo propongo yo | Una devolución puede ser parcial. |
| `tickets_incidencia` | Lo pide el cliente | Incidencias con asunto, descripción, estado, fechas y agente. |
| `devoluciones_online` | Lo pide el cliente | Las devoluciones online se gestionan como incidencias. |
| `devolucion_online_lineas` | Lo propongo yo | Detalla productos devueltos online. |
| `envios_recogida` | Lo pide el cliente | Una devolución online genera envío de recogida. |
| `stock_ubicacion` | Lo pide el cliente | Stock por producto y ubicación. |
| `transferencias_stock` | Lo pide el cliente | Transferencias internas con origen, destino, producto, cantidad y autorizador. |
| `valoraciones` | Lo pide el cliente | Puntuación y comentario por cliente registrado y producto. |
| `movimientos_puntos` | Lo pide el cliente | Histórico de puntos ganados/canjeados para calcular saldo. |

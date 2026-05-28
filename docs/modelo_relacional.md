# Modelo relacional  
## NexShop Group S.A.

## Notación

- **PK** indica clave primaria.
- **FK** indica clave foránea.
- Las relaciones **N:M** se resuelven con tablas intermedias o tablas de líneas.

---

# Relaciones

## 1. Ubicaciones y empleados

```text
UBICACIONES(
  id_ubicacion PK,
  nombre,
  tipo,
  direccion,
  codigo_postal,
  ciudad,
  provincia,
  pais,
  activa
)
```

```text
EMPLEADOS(
  id_empleado PK,
  nombre,
  apellidos,
  dni UNIQUE,
  email_corporativo UNIQUE,
  fecha_incorporacion,
  rol,
  id_ubicacion FK -> UBICACIONES.id_ubicacion
)
```

---

## 2. Catálogo

```text
CATEGORIAS(
  id_categoria PK,
  nombre UNIQUE,
  descripcion
)
```

```text
SUBCATEGORIAS(
  id_subcategoria PK,
  id_categoria FK -> CATEGORIAS.id_categoria,
  id_subcategoria_padre FK -> SUBCATEGORIAS.id_subcategoria,
  nombre,
  descripcion,
  UNIQUE(id_categoria, id_subcategoria_padre, nombre)
)
```

```text
PRODUCTOS(
  id_producto PK,
  sku UNIQUE,
  nombre,
  descripcion,
  id_subcategoria FK -> SUBCATEGORIAS.id_subcategoria,
  activo
)
```

```text
PRECIOS_PRODUCTO(
  id_precio PK,
  id_producto FK -> PRODUCTOS.id_producto,
  pvp,
  fecha_inicio,
  fecha_fin,
  UNIQUE(id_producto, fecha_inicio)
)
```

---

## 3. Promociones

```text
PROMOCIONES(
  id_promocion PK,
  nombre,
  descripcion,
  descuento_porcentaje,
  fecha_inicio,
  fecha_fin
)
```

```text
PROMOCION_PRODUCTOS(
  id_promocion PK/FK -> PROMOCIONES.id_promocion,
  id_producto PK/FK -> PRODUCTOS.id_producto
)
```

**Justificación:** resuelve la relación **N:M** entre productos y promociones.

---

## 4. Proveedores y compras

```text
PROVEEDORES(
  id_proveedor PK,
  nombre,
  cif UNIQUE,
  telefono,
  email,
  direccion,
  ciudad,
  pais,
  id_representante FK -> EMPLEADOS.id_empleado
)
```

```text
CONDICIONES_PROVEEDOR_PRODUCTO(
  id_condicion PK,
  id_proveedor FK -> PROVEEDORES.id_proveedor,
  id_producto FK -> PRODUCTOS.id_producto,
  precio_coste,
  plazo_entrega_dias,
  fecha_inicio,
  fecha_fin,
  UNIQUE(id_proveedor, id_producto, fecha_inicio)
)
```

**Justificación:** resuelve una relación **N:M histórica** entre proveedores y productos, guardando el coste, el plazo de entrega y las fechas de vigencia.

```text
PEDIDOS_PROVEEDOR(
  id_pedido_proveedor PK,
  id_proveedor FK -> PROVEEDORES.id_proveedor,
  id_ubicacion_destino FK -> UBICACIONES.id_ubicacion,
  id_empleado_compras FK -> EMPLEADOS.id_empleado,
  fecha_pedido,
  estado,
  total_estimado
)
```

```text
PEDIDO_PROVEEDOR_LINEAS(
  id_pedido_proveedor PK/FK -> PEDIDOS_PROVEEDOR.id_pedido_proveedor,
  id_producto PK/FK -> PRODUCTOS.id_producto,
  cantidad,
  precio_coste_unitario
)
```

---

## 5. Clientes y direcciones

```text
CLIENTES(
  id_cliente PK,
  nombre,
  apellidos,
  email UNIQUE,
  password_hash,
  fecha_nacimiento,
  fecha_registro
)
```

```text
DIRECCIONES_CLIENTE(
  id_direccion PK,
  id_cliente FK -> CLIENTES.id_cliente,
  alias,
  calle,
  numero,
  piso,
  codigo_postal,
  ciudad,
  provincia,
  pais,
  es_predeterminada
)
```

---

## 6. Pedidos online y envíos

```text
PEDIDOS_ONLINE(
  id_pedido PK,
  id_cliente FK -> CLIENTES.id_cliente,
  id_direccion_envio FK -> DIRECCIONES_CLIENTE.id_direccion,
  fecha_pedido,
  estado,
  total_productos,
  puntos_canjeados,
  descuento_puntos_eur,
  total_final
)
```

```text
PEDIDO_ONLINE_LINEAS(
  id_linea_pedido PK,
  id_pedido FK -> PEDIDOS_ONLINE.id_pedido,
  id_producto FK -> PRODUCTOS.id_producto,
  cantidad,
  precio_unitario_pvp,
  descuento_promocion_pct,
  subtotal
)
```

```text
TRANSPORTISTAS(
  id_transportista PK,
  nombre UNIQUE,
  telefono,
  email
)
```

```text
ENVIOS(
  id_envio PK,
  id_pedido FK -> PEDIDOS_ONLINE.id_pedido,
  id_ubicacion_origen FK -> UBICACIONES.id_ubicacion,
  id_transportista FK -> TRANSPORTISTAS.id_transportista,
  numero_seguimiento UNIQUE,
  fecha_salida,
  fecha_estimada_entrega,
  estado
)
```

```text
ENVIO_LINEAS(
  id_envio PK/FK -> ENVIOS.id_envio,
  id_producto PK/FK -> PRODUCTOS.id_producto,
  cantidad
)
```

---

## 7. Ventas presenciales y devoluciones de tienda

```text
VENTAS_PRESENCIALES(
  id_venta PK,
  id_ubicacion FK -> UBICACIONES.id_ubicacion,
  id_empleado FK -> EMPLEADOS.id_empleado,
  id_cliente FK -> CLIENTES.id_cliente NULL,
  codigo_cliente_invitado,
  fecha_venta,
  metodo_pago,
  total
)
```

```text
VENTA_PRESENCIAL_LINEAS(
  id_linea_venta PK,
  id_venta FK -> VENTAS_PRESENCIALES.id_venta,
  id_producto FK -> PRODUCTOS.id_producto,
  cantidad,
  precio_unitario,
  descuento_pct,
  subtotal
)
```

```text
DEVOLUCIONES_PRESENCIALES(
  id_devolucion_presencial PK,
  id_venta FK -> VENTAS_PRESENCIALES.id_venta,
  id_empleado FK -> EMPLEADOS.id_empleado,
  fecha_devolucion,
  motivo,
  importe_total
)
```

```text
DEVOLUCION_PRESENCIAL_LINEAS(
  id_linea_devolucion PK,
  id_devolucion_presencial FK -> DEVOLUCIONES_PRESENCIALES.id_devolucion_presencial,
  id_producto FK -> PRODUCTOS.id_producto,
  cantidad,
  importe_linea
)
```

---

## 8. Incidencias y devoluciones online

```text
TICKETS_INCIDENCIA(
  id_ticket PK,
  id_cliente FK -> CLIENTES.id_cliente NULL,
  id_pedido FK -> PEDIDOS_ONLINE.id_pedido NULL,
  id_agente FK -> EMPLEADOS.id_empleado,
  asunto,
  descripcion,
  fecha_apertura,
  estado,
  fecha_cierre,
  nota_resolucion,
  tipo
)
```

```text
DEVOLUCIONES_ONLINE(
  id_devolucion_online PK,
  id_ticket FK -> TICKETS_INCIDENCIA.id_ticket,
  id_pedido FK -> PEDIDOS_ONLINE.id_pedido,
  fecha_solicitud,
  estado,
  importe_estimado
)
```

```text
DEVOLUCION_ONLINE_LINEAS(
  id_linea_devolucion_online PK,
  id_devolucion_online FK -> DEVOLUCIONES_ONLINE.id_devolucion_online,
  id_producto FK -> PRODUCTOS.id_producto,
  cantidad,
  motivo,
  importe_linea
)
```

```text
ENVIOS_RECOGIDA(
  id_recogida PK,
  id_devolucion_online FK -> DEVOLUCIONES_ONLINE.id_devolucion_online,
  id_transportista FK -> TRANSPORTISTAS.id_transportista,
  numero_seguimiento UNIQUE,
  fecha_solicitud,
  fecha_estimada_recogida,
  estado
)
```

---

## 9. Stock y transferencias

```text
STOCK_UBICACION(
  id_ubicacion PK/FK -> UBICACIONES.id_ubicacion,
  id_producto PK/FK -> PRODUCTOS.id_producto,
  stock_actual,
  stock_minimo
)
```

**Justificación:** resuelve la relación **N:M** entre ubicaciones y productos, añadiendo atributos propios de stock.

```text
TRANSFERENCIAS_STOCK(
  id_transferencia PK,
  id_ubicacion_origen FK -> UBICACIONES.id_ubicacion,
  id_ubicacion_destino FK -> UBICACIONES.id_ubicacion,
  id_producto FK -> PRODUCTOS.id_producto,
  cantidad,
  fecha_transferencia,
  id_empleado_autoriza FK -> EMPLEADOS.id_empleado,
  estado
)
```

---

## 10. Valoraciones y fidelización

```text
VALORACIONES(
  id_valoracion PK,
  id_cliente FK -> CLIENTES.id_cliente,
  id_producto FK -> PRODUCTOS.id_producto,
  puntuacion,
  comentario,
  fecha_valoracion,
  verificada,
  UNIQUE(id_cliente, id_producto)
)
```

```text
MOVIMIENTOS_PUNTOS(
  id_movimiento PK,
  id_cliente FK -> CLIENTES.id_cliente,
  id_pedido FK -> PEDIDOS_ONLINE.id_pedido,
  tipo,
  puntos,
  fecha_movimiento,
  descripcion
)
```

```text
VW_SALDO_PUNTOS_CLIENTE(
  id_cliente,
  nombre,
  apellidos,
  saldo_puntos
)
```

**Justificación:** es una vista derivada. No sustituye al histórico de movimientos de puntos.

---

# Restricciones principales

- `puntuacion` en valoraciones debe estar entre **1 y 5**.
- `descuento_porcentaje` y los descuentos de línea deben estar entre **0 y 100**.
- Importes, precios, cantidades y stock no pueden ser negativos.
- Una valoración solo puede existir una vez por cliente y producto.
- Un producto solo pertenece a una subcategoría mediante `productos.id_subcategoria`.
- El saldo de puntos se calcula con `GANADO` como suma y `CANJEADO` como resta.

# Proyecto NexShop - Base de Datos

## Descripción

Este repositorio contiene el análisis, diseño e implementación de una base de datos relacional para NexShop Group S.A., una empresa con tienda online y tres tiendas fisicas. El modelo cubre productos, categorias, precios historicos, promociones, proveedores, pedidos online, ventas presenciales, envios, stock, devoluciones, incidencias, valoraciones, empleados y fidelizacion por puntos.

## Estructura

```text
proyecto-nexshop/
|-- README.md
|-- docs/
|   |-- memoria.pdf
|   |-- memoria.md
|   |-- diagrama_er.png
|   |-- modelo_relacional.pdf
|   |-- modelo_relacional.md
|-- sql/
|   |-- schema.sql
|   |-- datos.sql
|-- consultas/
|   |-- consultas.sql
```

## Como ejecutar la base de datos

1. Abrir un entorno MySQL.
2. Ejecutar primero `sql/schema.sql`.
3. Ejecutar después `sql/datos.sql`.
4. Ejecutar finalmente `consultas/consultas.sql` para probar las 14 consultas obligatorias.

## Notas importantes

- El saldo de fidelización no se guarda como campo fijo: se calcula desde `movimientos_puntos`.
- Las ventas presenciales y pedidos online se separan porque son procesos distintos, aunque comparten productos y clientes.
- El histórico de PVP se guarda en `precios_producto`; las promociones se guardan aparte porque son descuentos temporales sobre el PVP.
- Las relaciones N:M se resuelven con tablas intermedias o tablas de lineas, por ejemplo `promocion_productos`, `stock_ubicacion`, `pedido_online_lineas` y `condiciones_proveedor_producto`.

## Diagrama ER

El diagrama esta en `docs/diagrama_er.png`.

-- schema.sql - Base de datos NexShop Group S.A.
-- MySQL 8.x

DROP DATABASE IF EXISTS nexshop;
CREATE DATABASE nexshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexshop;

CREATE TABLE ubicaciones (
    id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('TIENDA','ALMACEN_CENTRAL') NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    provincia VARCHAR(80) NOT NULL,
    pais VARCHAR(80) NOT NULL DEFAULT 'Espana',
    activa BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni VARCHAR(12) NOT NULL UNIQUE,
    email_corporativo VARCHAR(120) NOT NULL UNIQUE,
    fecha_incorporacion DATE NOT NULL,
    rol ENUM('ENCARGADO_TIENDA','VENDEDOR','RESPONSABLE_ALMACEN','LOGISTICA','COMPRAS','ATENCION_CLIENTE','IT','MARKETING','COMERCIAL','DIRECCION') NOT NULL,
    id_ubicacion INT NOT NULL,
    CONSTRAINT fk_empleados_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
) ENGINE=InnoDB;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE subcategorias (
    id_subcategoria INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_subcategoria_padre INT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255),
    CONSTRAINT uq_subcategoria UNIQUE (id_categoria, id_subcategoria_padre, nombre),
    CONSTRAINT fk_subcategorias_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT fk_subcategorias_padre FOREIGN KEY (id_subcategoria_padre) REFERENCES subcategorias(id_subcategoria)
) ENGINE=InnoDB;

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    id_subcategoria INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_productos_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES subcategorias(id_subcategoria)
) ENGINE=InnoDB;

CREATE TABLE precios_producto (
    id_precio INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    pvp DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    CONSTRAINT fk_precios_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT uq_precio_producto_fecha UNIQUE (id_producto, fecha_inicio),
    CONSTRAINT chk_pvp CHECK (pvp >= 0),
    CONSTRAINT chk_fechas_precio CHECK (fecha_fin IS NULL OR fecha_fin > fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE promociones (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(255),
    descuento_porcentaje DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CONSTRAINT chk_descuento_promocion CHECK (descuento_porcentaje > 0 AND descuento_porcentaje <= 100),
    CONSTRAINT chk_fechas_promocion CHECK (fecha_fin >= fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE promocion_productos (
    id_promocion INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_promocion, id_producto),
    CONSTRAINT fk_promoprod_promocion FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion),
    CONSTRAINT fk_promoprod_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB;

CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    cif VARCHAR(15) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    email VARCHAR(120),
    direccion VARCHAR(150),
    ciudad VARCHAR(80),
    pais VARCHAR(80) DEFAULT 'Espana',
    id_representante INT NOT NULL,
    CONSTRAINT fk_proveedores_representante FOREIGN KEY (id_representante) REFERENCES empleados(id_empleado)
) ENGINE=InnoDB;

CREATE TABLE condiciones_proveedor_producto (
    id_condicion INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_producto INT NOT NULL,
    precio_coste DECIMAL(10,2) NOT NULL,
    plazo_entrega_dias INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    CONSTRAINT fk_condiciones_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_condiciones_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT uq_condicion_fecha UNIQUE (id_proveedor, id_producto, fecha_inicio),
    CONSTRAINT chk_precio_coste CHECK (precio_coste >= 0),
    CONSTRAINT chk_plazo_entrega CHECK (plazo_entrega_dias > 0),
    CONSTRAINT chk_fechas_condicion CHECK (fecha_fin IS NULL OR fecha_fin > fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE pedidos_proveedor (
    id_pedido_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_ubicacion_destino INT NOT NULL,
    id_empleado_compras INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    estado ENUM('SOLICITADO','CONFIRMADO','RECIBIDO','CANCELADO') NOT NULL DEFAULT 'SOLICITADO',
    total_estimado DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_pedprov_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_pedprov_ubicacion FOREIGN KEY (id_ubicacion_destino) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_pedprov_empleado FOREIGN KEY (id_empleado_compras) REFERENCES empleados(id_empleado),
    CONSTRAINT chk_total_estimado CHECK (total_estimado >= 0)
) ENGINE=InnoDB;

CREATE TABLE pedido_proveedor_lineas (
    id_pedido_proveedor INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_coste_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido_proveedor, id_producto),
    CONSTRAINT fk_pedprovlin_pedido FOREIGN KEY (id_pedido_proveedor) REFERENCES pedidos_proveedor(id_pedido_proveedor),
    CONSTRAINT fk_pedprovlin_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_pedprovlin_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_pedprovlin_precio CHECK (precio_coste_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE direcciones_cliente (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    alias VARCHAR(40) NOT NULL,
    calle VARCHAR(120) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    piso VARCHAR(20),
    codigo_postal VARCHAR(10) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    provincia VARCHAR(80),
    pais VARCHAR(80) NOT NULL DEFAULT 'Espana',
    es_predeterminada BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_direcciones_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
) ENGINE=InnoDB;

CREATE TABLE pedidos_online (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_direccion_envio INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    estado ENUM('PENDIENTE','PAGADO','PREPARACION','ENVIADO','ENTREGADO','CANCELADO','DEVUELTO') NOT NULL DEFAULT 'PENDIENTE',
    total_productos DECIMAL(12,2) NOT NULL DEFAULT 0,
    puntos_canjeados INT NOT NULL DEFAULT 0,
    descuento_puntos_eur DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_final DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_pedidos_direccion FOREIGN KEY (id_direccion_envio) REFERENCES direcciones_cliente(id_direccion),
    CONSTRAINT chk_pedidos_totales CHECK (total_productos >= 0 AND puntos_canjeados >= 0 AND descuento_puntos_eur >= 0 AND total_final >= 0)
) ENGINE=InnoDB;

CREATE TABLE pedido_online_lineas (
    id_linea_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_pvp DECIMAL(10,2) NOT NULL,
    descuento_promocion_pct DECIMAL(5,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_lineaspedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_online(id_pedido),
    CONSTRAINT fk_lineaspedido_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_lineaspedido_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_lineaspedido_importes CHECK (precio_unitario_pvp >= 0 AND descuento_promocion_pct >= 0 AND descuento_promocion_pct <= 100 AND subtotal >= 0)
) ENGINE=InnoDB;

CREATE TABLE transportistas (
    id_transportista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    email VARCHAR(120)
) ENGINE=InnoDB;

CREATE TABLE envios (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_ubicacion_origen INT NOT NULL,
    id_transportista INT NOT NULL,
    numero_seguimiento VARCHAR(60) NOT NULL UNIQUE,
    fecha_salida DATETIME NULL,
    fecha_estimada_entrega DATE NOT NULL,
    estado ENUM('PENDIENTE','EN_TRANSITO','ENTREGADO','INCIDENCIA','CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    CONSTRAINT fk_envios_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_online(id_pedido),
    CONSTRAINT fk_envios_ubicacion FOREIGN KEY (id_ubicacion_origen) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_envios_transportista FOREIGN KEY (id_transportista) REFERENCES transportistas(id_transportista)
) ENGINE=InnoDB;

CREATE TABLE envio_lineas (
    id_envio INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id_envio, id_producto),
    CONSTRAINT fk_enviolineas_envio FOREIGN KEY (id_envio) REFERENCES envios(id_envio),
    CONSTRAINT fk_enviolineas_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_enviolineas_cantidad CHECK (cantidad > 0)
) ENGINE=InnoDB;

CREATE TABLE ventas_presenciales (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_ubicacion INT NOT NULL,
    id_empleado INT NOT NULL,
    id_cliente INT NULL,
    codigo_cliente_invitado VARCHAR(40) NULL,
    fecha_venta DATETIME NOT NULL,
    metodo_pago ENUM('EFECTIVO','TARJETA','BIZUM','OTRO') NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ventas_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_ventas_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT chk_ventas_total CHECK (total >= 0)
) ENGINE=InnoDB;

CREATE TABLE venta_presencial_lineas (
    id_linea_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_pct DECIMAL(5,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_lineasventa_venta FOREIGN KEY (id_venta) REFERENCES ventas_presenciales(id_venta),
    CONSTRAINT fk_lineasventa_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_lineasventa_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_lineasventa_importes CHECK (precio_unitario >= 0 AND descuento_pct >= 0 AND descuento_pct <= 100 AND subtotal >= 0)
) ENGINE=InnoDB;

CREATE TABLE devoluciones_presenciales (
    id_devolucion_presencial INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_devolucion DATETIME NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    importe_total DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_devpres_venta FOREIGN KEY (id_venta) REFERENCES ventas_presenciales(id_venta),
    CONSTRAINT fk_devpres_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    CONSTRAINT chk_devpres_importe CHECK (importe_total >= 0)
) ENGINE=InnoDB;

CREATE TABLE devolucion_presencial_lineas (
    id_linea_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    id_devolucion_presencial INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    importe_linea DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_devpreslin_devolucion FOREIGN KEY (id_devolucion_presencial) REFERENCES devoluciones_presenciales(id_devolucion_presencial),
    CONSTRAINT fk_devpreslin_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_devpreslin_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_devpreslin_importe CHECK (importe_linea >= 0)
) ENGINE=InnoDB;

CREATE TABLE tickets_incidencia (
    id_ticket INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NULL,
    id_pedido INT NULL,
    id_agente INT NOT NULL,
    asunto VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    estado ENUM('ABIERTO','EN_GESTION','RESUELTO') NOT NULL DEFAULT 'ABIERTO',
    fecha_cierre DATETIME NULL,
    nota_resolucion TEXT NULL,
    tipo ENUM('CONSULTA','QUEJA','DEVOLUCION_ONLINE','OTRO') NOT NULL DEFAULT 'CONSULTA',
    CONSTRAINT fk_tickets_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_tickets_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_online(id_pedido),
    CONSTRAINT fk_tickets_agente FOREIGN KEY (id_agente) REFERENCES empleados(id_empleado),
    CONSTRAINT chk_tickets_fechas CHECK (fecha_cierre IS NULL OR fecha_cierre >= fecha_apertura)
) ENGINE=InnoDB;

CREATE TABLE devoluciones_online (
    id_devolucion_online INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_pedido INT NOT NULL,
    fecha_solicitud DATETIME NOT NULL,
    estado ENUM('SOLICITADA','RECOGIDA','RECIBIDA','REEMBOLSADA','RECHAZADA') NOT NULL DEFAULT 'SOLICITADA',
    importe_estimado DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_devonline_ticket FOREIGN KEY (id_ticket) REFERENCES tickets_incidencia(id_ticket),
    CONSTRAINT fk_devonline_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_online(id_pedido),
    CONSTRAINT chk_devonline_importe CHECK (importe_estimado >= 0)
) ENGINE=InnoDB;

CREATE TABLE devolucion_online_lineas (
    id_linea_devolucion_online INT AUTO_INCREMENT PRIMARY KEY,
    id_devolucion_online INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(255),
    importe_linea DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_devonlinelin_dev FOREIGN KEY (id_devolucion_online) REFERENCES devoluciones_online(id_devolucion_online),
    CONSTRAINT fk_devonlinelin_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_devonlinelin_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_devonlinelin_importe CHECK (importe_linea >= 0)
) ENGINE=InnoDB;

CREATE TABLE envios_recogida (
    id_recogida INT AUTO_INCREMENT PRIMARY KEY,
    id_devolucion_online INT NOT NULL,
    id_transportista INT NOT NULL,
    numero_seguimiento VARCHAR(60) NOT NULL UNIQUE,
    fecha_solicitud DATETIME NOT NULL,
    fecha_estimada_recogida DATE NOT NULL,
    estado ENUM('SOLICITADA','EN_RUTA','RECOGIDA','ENTREGADA_ALMACEN','CANCELADA') NOT NULL DEFAULT 'SOLICITADA',
    CONSTRAINT fk_recogida_devonline FOREIGN KEY (id_devolucion_online) REFERENCES devoluciones_online(id_devolucion_online),
    CONSTRAINT fk_recogida_transportista FOREIGN KEY (id_transportista) REFERENCES transportistas(id_transportista)
) ENGINE=InnoDB;

CREATE TABLE stock_ubicacion (
    id_ubicacion INT NOT NULL,
    id_producto INT NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_ubicacion, id_producto),
    CONSTRAINT fk_stock_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_stock_valores CHECK (stock_actual >= 0 AND stock_minimo >= 0)
) ENGINE=InnoDB;

CREATE TABLE transferencias_stock (
    id_transferencia INT AUTO_INCREMENT PRIMARY KEY,
    id_ubicacion_origen INT NOT NULL,
    id_ubicacion_destino INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_transferencia DATETIME NOT NULL,
    id_empleado_autoriza INT NOT NULL,
    estado ENUM('SOLICITADA','AUTORIZADA','ENVIADA','RECIBIDA','CANCELADA') NOT NULL DEFAULT 'SOLICITADA',
    CONSTRAINT fk_transfer_origen FOREIGN KEY (id_ubicacion_origen) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_transfer_destino FOREIGN KEY (id_ubicacion_destino) REFERENCES ubicaciones(id_ubicacion),
    CONSTRAINT fk_transfer_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_transfer_empleado FOREIGN KEY (id_empleado_autoriza) REFERENCES empleados(id_empleado),
    CONSTRAINT chk_transfer_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_transfer_ubicaciones CHECK (id_ubicacion_origen <> id_ubicacion_destino)
) ENGINE=InnoDB;

CREATE TABLE valoraciones (
    id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    puntuacion TINYINT NOT NULL,
    comentario TEXT,
    fecha_valoracion DATETIME NOT NULL,
    verificada BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_valoraciones_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_valoraciones_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT uq_valoracion_cliente_producto UNIQUE (id_cliente, id_producto),
    CONSTRAINT chk_valoracion_puntuacion CHECK (puntuacion BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE movimientos_puntos (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_pedido INT NOT NULL,
    tipo ENUM('GANADO','CANJEADO') NOT NULL,
    puntos INT NOT NULL,
    fecha_movimiento DATETIME NOT NULL,
    descripcion VARCHAR(255),
    CONSTRAINT fk_movpuntos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_movpuntos_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_online(id_pedido),
    CONSTRAINT chk_movpuntos_puntos CHECK (puntos > 0)
) ENGINE=InnoDB;

-- Vista opcional para calcular el saldo actual desde el historico, sin duplicar el dato en clientes.
CREATE VIEW vw_saldo_puntos_cliente AS
SELECT
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COALESCE(SUM(CASE WHEN mp.tipo = 'GANADO' THEN mp.puntos ELSE -mp.puntos END), 0) AS saldo_puntos
FROM clientes c
LEFT JOIN movimientos_puntos mp ON mp.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellidos;

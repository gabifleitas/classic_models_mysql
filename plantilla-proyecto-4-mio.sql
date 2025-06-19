/*
PROYECTO 4 - SQL - mio
*/

/*
ANALISIS PREVIO AL PROBLEMA
*/

-- 1. ¿Que fuentes de datos tiene la empresa?
-- R: Estos datos vienen de un ERP

-- 2. ¿En que formato nos entregan los datos en crudo?
-- R: .csv y .sql

-- 3. ¿Que datos tenemos?
-- R: datos de ventas de una empresa

-- 4. Modelo de datos.
-- R: Modelos de datos relacionales

-- 5. Análisis exploratorio de las tablas.
-- Revisar que tienen las bases de datos
SELECT * 
FROM customers
Limit 10;

SELECT * 
FROM orderdetails
Limit 10;

SELECT * 
FROM orders
Limit 10;

SELECT * 
FROM payments
Limit 10;

SELECT * 
FROM products
Limit 10;

/*
Ejecución
Parte I -  Creación de un nuevo esquema para almacenar el modelo de datos definitivo
*/


-- 1. Crea una nueva base de datos en MySQL llamada “classicModels”.
CREATE DATABASE classicModels;

-- 2. Identifica que tablas serán dimensiones y cuales serán hechos basandote en los datos en crudo.
/*
1. customer: dimension
2. orderdetails: dimension
3. orders: hechos
4. payments: hechos
5. products: dimension
*/

/*
3. Crea la tabla de productos llamada **xxx_productos** (siendo xxx DIM o FAC según corresponda) a partir de los datos en crudo.
	3.1. Revisa como vienen los datos en orígen (crudo).
	3.2. Diseña la estructura de la tabla, teniendo en cuenta:
		3.2.1. Nombre de los campos.
		3.2.2 Tipo de datos.
		3.2.3. Longitud de datos.
		3.2.4. Claves primarias.
*/
SELECT *
FROM products
LIMIT 10;

--
DESCRIBE products;

--
SELECT 
	MAX(buyprice)
FROM products
LIMIT 10;

-- 103.42 decimal (3,2)

SELECT 
	MAX(LENGTH(productcode)) AS product_code,
    MAX(LENGTH(productname)) AS product_name,
    MAX(LENGTH(productline)) AS product_line,
    MAX(LENGTH(productscale)) AS productscale,
    MAX(LENGTH(productvendor)) AS product_vendor,
    MAX(LENGTH(productdescription)) AS product_description,
    MAX(quantityinstock) AS quantityInStock,
    MAX(buyprice) AS buyPrice,
    MAX(MSRP) AS MSRP
FROM products;

-- product_code, product_name, product_line, productscale, product_vendor, product_description, quantityInStock, buyPrice, MSRP
-- '9', '43', '16', '5', '25', '495', '9997', '103.42', '214.30'

SELECT COUNT(DISTINCT(productcode))
FROM products;
-- 110 codigos de productos unicos

CREATE TABLE classicmodels.dim_productos(
pk_producto VARCHAR(255) PRIMARY KEY,
nombre_producto VARCHAR(255),
linea_producto VARCHAR(255),
escala VARCHAR(255),
proveedor VARCHAR(255),
descripcion TEXT,
cantidad INT,
imp_compra DECIMAL(15,2),
imp_venta DECIMAL(15,2)
);


/*
3.3 Inserta los campos a la nueva tabla.
	3.3.1. Traduce el tipo de linea de producto del inglés al castellano.
*/

SELECT DISTINCT (productline)
FROM raw_classicmodels.products;

-- Haciendo --> 3.3.1. Traduce el tipo de linea de producto del inglés al castellano.
SELECT
	DISTINCT (productline),
	CASE 
		WHEN productline = 'Motorcycles' THEN 'Motos'
        WHEN productline = 'Classic Cars' THEN 'Carros Clasicos'
        WHEN productline = 'Trucks and Buses' THEN 'Camiones y autobuses'
        WHEN productline = 'Vintage Cars' THEN 'Coches Vintage'
        WHEN productline = 'Planes' THEN 'Aviones'
        WHEN productline = 'Ships' THEN 'Buques'
        WHEN productline = 'Trains' THEN 'Trenes'
        ELSE 'Otros'
	END AS traduccion
FROM products;


-- Haciendo --> Inserta los campos a la nueva tabla.
INSERT INTO classicmodels.dim_productos
SELECT 	
	productcode,
    productname,
    CASE 
		WHEN productline = 'Motorcycles' THEN 'Motos'
        WHEN productline = 'Classic Cars' THEN 'Carros Clasicos'
        WHEN productline = 'Trucks and Buses' THEN 'Camiones y autobuses'
        WHEN productline = 'Vintage Cars' THEN 'Coches Vintage'
        WHEN productline = 'Planes' THEN 'Aviones'
        WHEN productline = 'Ships' THEN 'Buques'
        WHEN productline = 'Trains' THEN 'Trenes'
        ELSE 'Otros'
	END AS productline,
    productscale,
    productvendor,
    productDescription,
    quantityInStock,
    buyPrice,
    MSRP
FROM raw_classicmodels.products;

/*
4. Crea la tabla de clientes llamada **xxx_clientes** (siendo xxx DIM o FAC según corresponda) a partir de los datos en crudo.
	4.1. Revisa como vienen los datos en orígen (crudo).
    4.2. Diseña la estructura de la tabla, teniendo en cuenta:
        4.2.1. Nombre de los campos.
        4.2.2. Tipo de datos.
        4.2.3. Longitud de datos.
        4.2.4. Claves primarias.
*/

SELECT *
FROM raw_classicmodels.customers;

-- longitud de los datos
SELECT
	MAX(customerNumber) AS customerNumber,
    MAX(LENGTH(customername)) AS customername,
    MAX(phone) AS phone,
	MAX(LENGTH(addressline1)) AS addressline1,
    MAX(LENGTH(addressline2)) AS addressline2,
    MAX(LENGTH(city)) AS city,
    MAX(LENGTH(state)) AS state,
    MAX(LENGTH(postalcode)) AS postalcode,
    MAX(LENGTH(country)) AS country,
    MAX(salesRepEmployeeNumber) AS salesrepemployeenumber,
    MAX(creditlimit) AS creditlimit,
     MAX(LENGTH(lastnamefirstname)) AS lastnamefirstname
FROM raw_classicmodels.customers;

-- Calculo de primary key

SELECT COUNT(*)
FROM raw_classicmodels.customers;
-- 122

SELECT COUNT(DISTINCT(customernumber))
FROM raw_classicmodels.customers;
-- 122

-- crear tabla
CREATE TABLE IF NOT EXISTS classicmodels.clientes(
	pk_clientes INT PRIMARY KEY,
    nombre_empresa VARCHAR(50),
    nom_contact_emp VARCHAR(50),
    apellido_contact_emp VARCHAR(50),
    direccion_emp VARCHAR(100),
    cod_postal VARCHAR(50),
    ciudad VARCHAR(50),
    pais VARCHAR(50),
    cod_representante_int INT,
    imp_limite_cred DECIMAL (15,2)
);


/*
	4.3. Inserta los campos a la nueva tabla
        4.3.1. Separa el nombre del contacto del cliente para tenerlo en dos columnas diferentes.
        4.3.2. Junta los campos de dirección en uno solo.
*/        

SELECT 
	lastNameFirstName
FROM raw_classicmodels.customers
LIMIT 10;
-- objetivo es separar: Schmitt,Carine 
-- Schmitt
-- Carine 

-- viendo como funciona SUBSTR (campo,inicio,fin) y INSTR
SELECT 
	lastNameFirstName,
    SUBSTR(lastNameFirstName,9,50) AS nombre,
    INSTR(lastNameFirstName,',') AS coma,
    SUBSTR(lastNameFirstName,INSTR(lastNameFirstName,',') +1 ,50) AS nombre
FROM raw_classicmodels.customers
LIMIT 10;

-- nombre y apellido separados
SELECT 
	lastNameFirstName,
    SUBSTR(lastNameFirstName,INSTR(lastNameFirstName,',') +1 ,50) AS nombre,
    SUBSTR(lastNameFirstName,1 ,INSTR(lastNameFirstName,',') -1) AS apellido
FROM raw_classicmodels.customers
LIMIT 10;

--  4.3.2. Junta los campos de dirección en uno solo.

SELECT 
	addressline2
FROM customers
WHERE addressline2 IS NULL;

SELECT 
	addressline1,
	addressline2,
    CONCAT(addressline1,addressline2) AS concatenado,
    COALESCE(addressline2,'Es nulo')
FROM customers
WHERE addressline2 IS NULL;

-- direcciones unidas
SELECT 
	addressline1,
	addressline2,
    CONCAT(addressline1,' ',COALESCE(addressline2,'')) AS concatenado
FROM customers
WHERE addressline2 IS NULL;


-- Inserta los campos a la nueva tabla
INSERT INTO classicmodels.clientes
SELECT 
	customerNumber,
    customerName,
    SUBSTR(lastNameFirstName,INSTR(lastNameFirstName,',') +1 ,50) AS nombre,
    SUBSTR(lastNameFirstName,1 ,INSTR(lastNameFirstName,',') -1) AS apellido,
    RTRIM(CONCAT(addressline1,' ',COALESCE(addressline2,''))) AS concatenado,
    postalCode,
    city,
    country,
    salesRepEmployeeNumber,
    creditLimit
FROM raw_classicmodels.customers;


/*
5. Crea la tabla de pagos llamada **xxx_pagos** (siendo xxx DIM o FAC según corresponda) a partir de los datos en crudo.
    5.1. Revisa como vienen los datos en orígen (crudo).
    5.2. Diseña la estructura de la tabla, teniendo en cuenta:
        5.2.1. Nombre de los campos.
        5.2.2. Tipo de datos.
        5.2.3. Longitud de datos.
        5.2.4. Claves primarias.
            5.2.4.1. Añade una clave compuesta. 
*/


-- datos crudos
SELECT * FROM raw_classicmodels.payments;

-- Datos crudos fecha
-- paymentdate: 20041019 10:42:46
-- YYYY/MM/DD HH:MM:SS --> DATETIME o TIMESTAMP
-- YYYY/MM/DD HH:MM:SS --> 19 caracteres
-- paymentdate: 20041019 10:42:46 --> 17 caracteres (maximo)
-- paymentdate: 20041019 1:42:46 --> 16 caracteres (minimo)

-- longitud de los datos
SELECT 
	MAX(LENGTH(customerName)),
    MAX(LENGTH(checkNumber)),
	MAX(LENGTH(paymentDate)) AS max_paymentDate,
    MIN(LENGTH(paymentDate)) AS min_paymentDate,
    MAX(LENGTH(amount))
FROM raw_classicmodels.payments;

-- claves primarias
SELECT COUNT(*)
FROM raw_classicmodels.payments;
-- 273


SELECT 
	COUNT(DISTINCT(checkNumber))
FROM raw_classicmodels.payments;
-- 273. Clave primaria


-- Arreglar la fecha
-- max_paymentDate, min_paymentDate
-- '26', '16'

SELECT *
FROM raw_classicmodels.payments
WHERE LENGTH(paymentDate) > 17;

-- # customerName, checkNumber, paymentDate, amount
-- 'Osaka Souveniers Co.', 'CI381435', '20040119 17:40:39 16:55:38', '47177.59'
-- en este caso, tomar la primera fecha. En general, hablar con el ingeniero de datos.

SELECT 
	paymentDate,
    SUBSTR(paymentDate,1,17) AS paymentDate_2
FROM raw_classicmodels.payments;

-- STR_TO_DATE: cadena de caracteres a formato fecha

SELECT 
	paymentDate,
    -- '20041019 10:42:46'
    STR_TO_DATE(paymentDate,'%Y%m%d %H:%i:%S') AS new_datetime
FROM raw_classicmodels.payments
LIMIT 1;

-- Fecha en formato Datetime
SELECT 
	paymentDate,
    STR_TO_DATE(SUBSTR(paymentDate,1,17),'%Y%m%d %H:%i:%S') AS new_paymentDate
FROM raw_classicmodels.payments;
-- 2004-10-19 10:42:46


-- crear tabla de pagos llamada **xxx_pagos** 
CREATE TABLE IF NOT EXISTS classicmodels.fac_pagos(
	pk_pago VARCHAR(255),
    id_cliente INT,
    fecha_pago DATETIME,
    importe_pago DECIMAL (15,2),
    PRIMARY KEY (pk_pago,id_cliente)
);
-- la combinacion del id_cliente + check_number de la transaccion : clave compuesta (son unicas)


/*
    5.3. Inserta los campos a la nueva tabla
        5.3.1. Cambia el nombre de la empresa por el id de la empresa.
        5.3.2. Guarda la fecha del pago en formato datetime.
*/

INSERT INTO classicmodels.fac_pagos
SELECT  
	p.checkNumber AS pk_pago,
    COALESCE(c.pk_clientes,0) AS id_cliente, -- como la clave 1ria es compuesta, no importa el cero. Ya que el checkNumber es unico
    STR_TO_DATE(SUBSTR(p.paymentDate,1,17),'%Y%m%d %H:%i:%S') AS fecha_pago,
    p.amount AS importe_pago
FROM raw_classicmodels.payments AS p
LEFT JOIN classicmodels.clientes AS c ON c.nombre_empresa = p.customerName;



/*
6. Crea la tabla de pedidos llamada **xxx_pedidos** (siendo xxx DIM o FAC según corresponda) a partir de los datos en crudo.
    6.1. Revisa como vienen los datos en orígen (crudo).
    6.2. Diseña la estructura de la tabla, teniendo en cuenta:
        6.2.1. Nombre de los campos.
        6.2.2. Tipo de datos.
        6.2.3. Longitud de datos.
        6.2.4. Claves primarias.
*/
-- ver datos crudos
SELECT *
FROM raw_classicmodels.orders;

-- longitud de los datos
SELECT 
	MAX(LENGTH(ordernumber)),
    MAX(LENGTH(orderdate)),
    MAX(LENGTH(requireddate)),
    MAX(LENGTH(shippeddate)),
    MAX(LENGTH(status)),
    MAX(LENGTH(comments)),
    MAX(LENGTH(customernumber))
FROM raw_classicmodels.orders;


-- primary key
SELECT COUNT(*)
FROM raw_classicmodels.orders;
-- 326

SELECT COUNT(ordernumber)
FROM raw_classicmodels.orders;
-- 326. primary key


-- crear la tabla
CREATE TABLE IF NOT EXISTS classicmodels.fac_pedidos(
	pk_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    fecha_entrega DATE,
    fecha_envio DATE,
    estado VARCHAR(255),
    comentarios VARCHAR(255)
);


/*    
	6.3. Inserta los campos a la nueva tabla.
        6.3.1. Guarda los tres campos de fecha en formato Date.
*/
-- traducir status
SELECT 
	DISTINCT(status),
    CASE
		WHEN status = 'Shipped' THEN 'Enviado'
        WHEN status = 'Resolved' THEN 'Resuelto'
        WHEN status = 'Cancelled' THEN 'Cancelado'
        WHEN status = 'On Hold' THEN 'En espera'
        WHEN status = 'Disputed' THEN 'Con problemas'
        WHEN status = 'In Process' THEN 'En proceso'
		ELSE 'Sin estado'
	END AS estado
FROM raw_classicmodels.orders;



INSERT INTO classicmodels.fac_pedidos
SELECT 
	ordernumber AS pk_pedido,
    customernumber AS id_cliente,
    STR_TO_DATE(orderdate,'%Y%m%d') AS fecha_pedido,
    STR_TO_DATE(requireddate,'%Y%m%d') AS fecha_entrega,
    STR_TO_DATE(shippedDate,'%Y%m%d') AS fecha_envio,
    CASE
		WHEN status = 'Shipped' THEN 'Enviado'
        WHEN status = 'Resolved' THEN 'Resuelto'
        WHEN status = 'Cancelled' THEN 'Cancelado'
        WHEN status = 'On Hold' THEN 'En espera'
        WHEN status = 'Disputed' THEN 'Con problemas'
        WHEN status = 'In Process' THEN 'En proceso'
		ELSE 'Otros'
	END AS estado,
    COALESCE(comments,'Sin Comentarios') AS comentarios
FROM raw_classicmodels.orders;



/*
7. Crea la tabla de detalle_pedidos llamada **xxx_detalle_pedidos** (siendo xxx DIM o FAC según corresponda) 
a partir de los datos en crudo.
    7.1. Revisa como vienen los datos en orígen (crudo).
    7.2. Diseña la estructura de la tabla, teniendo en cuenta:
        7.2.1. Nombre de los campos.
        7.2.2. Tipo de datos.
        7.2.3. Longitud de datos.
        7.2.4. Claves primarias.
*/
-- datos crudos
SELECT *
FROM raw_classicmodels.orderdetails;

-- clave primaria
SELECT COUNT(*)
FROM raw_classicmodels.orderdetails;
-- 1000

SELECT COUNT(orderNumber)
FROM raw_classicmodels.orderdetails;
-- 1000

-- crear tabla
CREATE TABLE IF NOT EXISTS classicmodels.dim_detalle_pedidos(
	id INT PRIMARY KEY AUTO_INCREMENT,
    pk_pedido INT,
    codigo_producto VARCHAR(255),
    cantidad_ordenada INT,
    precio_unitario DECIMAL(15,2),
    nro_linea_orden INT
);


/*
	7.3. Inserta los campos a la nueva tabla
*/

INSERT INTO classicmodels.dim_detalle_pedidos (
pk_pedido, 
codigo_producto, 
cantidad_ordenada, 
precio_unitario, 
nro_linea_orden
) 
-- estoy especificando en que columnas (de la nueva tabla) voy a insertar valores. 
-- hago esto porque sino, en el valor de id se van a insertar valores incorrectos
-- en este caso, tabla original = tabla nueva, por eso usamos el *. Sino, ibamos a tener que especificar en el SELECT
SELECT 
	*
FROM raw_classicmodels.orderdetails;


/*
Parte II - Limpieza de datos en tablas 
*/

USE classicmodels;

-- 1. Identifica si existen campos nulos en las tablas y propon en qué casos tiene sentido poner un valor comodín y en cuál no. 
SELECT *
FROM clientes
WHERE cod_postal IS NULL;

SELECT *
FROM fac_pedidos
WHERE fecha_envio IS NULL;

-- 2. Realiza consultas para jugar con las fechas en diferentes formatos.

SELECT 
	paymentDate,
    STR_TO_DATE(SUBSTR(paymentDate,1,17),'%Y%m%d %H:%i:%s') AS fecha_hora,
    CAST((STR_TO_DATE(SUBSTR(paymentDate,1,10), '%Y%m%d'))  AS DATETIME) AS fecha,
    -- datetime tiene con hora 00:00:00
    MONTHNAME(STR_TO_DATE(SUBSTR(paymentDate,1,17),'%Y%m%d %H:%i:%s')) AS mes
FROM raw_classicmodels.payments;

-- 3. Identifica que JOINs se pueden hacer entre las tablas.
SELECT *
FROM fac_pagos AS p
LEFT JOIN clientes AS c ON p.id_cliente = c.pk_clientes
LEFT JOIN dim_detalle_pedidos AS dp ON p.pk_pago = dp.pk_pedido;



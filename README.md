# Classic Models – Data Warehouse Project

## Description

The project was developed for the American company Classic Models, which sells miniature vehicles. The objective was to transform raw data into a structured and clean database in MySQL, ready for analytical queries and future KPI visualisations.

Part of the Unicorn Academy Data Analyst Bootcamp.

The focus was on organising information about products, customers, sales, and shipments, enabling answers to questions such as:

* What are the best-selling products?
* Which customers generate the most revenue?
* Which areas experience the most delays in shipments?

## Methodology and Tools

1. Analysis of data sources and understanding of the business model.
2. Dimensional model design: fact tables and dimensions.
3. Data transformation and normalisation: cleaning of nulls and duplicates, separation of combined fields, standardisation of formats, and translation of categories.
4. Data loading and validation: implementation of primary and composite keys, use of SQL functions (COALESCE, STR_TO_DATE, CASE, SUBSTR, CAST).
5. Final review of the model to ensure data integrity and quality.

Tools: MySQL

## Results and Conclusions

* Functional and scalable dimensional model for sales, customers, and product analysis.
* Normalised and standardised data, with categories translated into Spanish.
* Identification of limitations in the original data (missing shipping dates and postcodes, inconsistencies in company names).
* Recommendations: add a time dimension, a table of sales representatives, and establish continuous data quality monitoring.

This project lays the foundation for future financial and operational dashboards, facilitating strategic decisions based on reliable data.


---------------------------------------------------


# Classic Models – Data Warehouse Project

## Descripción

Proyecto desarrollado para la empresa estadounidense Classic Models, dedicada a la venta de miniaturas de vehículos. El objetivo fue transformar datos crudos en una base de datos estructurada y limpia en MySQL, lista para consultas analíticas y futuras visualizaciones de KPIs.

Proyecto realizado como parte del bootcamp de Análisis de datos de Unicorn Academy.

Se enfocó en organizar información sobre productos, clientes, ventas y envíos, permitiendo responder preguntas como:
* ¿Cuáles son los productos más vendidos?
* ¿Qué clientes generan mayores ingresos?
* ¿Qué zonas presentan más demoras en envíos?

## Metodología y Herramientas

1. Análisis de fuentes de datos y comprensión del modelo de negocio.
2. Diseño de modelo dimensional: tablas de hechos y dimensiones.
3. Transformación y normalización de datos: limpieza de nulos y duplicados, separación de campos combinados, estandarización de formatos y traducción de categorías.
4. Carga y validación de datos: implementación de claves primarias y compuestas, uso de funciones SQL (COALESCE, STR_TO_DATE, CASE, SUBSTR, CAST).
5. Revisión final del modelo para asegurar integridad y calidad de datos.

Herramientas: MySQL

## Resultados y Conclusiones

* Modelo dimensional funcional y escalable para análisis de ventas, clientes y productos.
* Datos normalizados y estandarizados, con traducción de categorías al español.
* Identificación de limitaciones en los datos originales (nulos en fechas de envío y códigos postales, inconsistencias en nombres de empresas).
* Recomendaciones: añadir dimensión temporal, tabla de representantes comerciales y establecer monitoreo continuo de calidad de datos.

Este proyecto sienta las bases para futuros dashboards financieros y operativos, facilitando decisiones estratégicas basadas en datos confiables.

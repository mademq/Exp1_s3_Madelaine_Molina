/* =========================================================
   PRY2205 - Experiencia 1 - Semana 3
   Alumno(a): Madelaine De Los Angeles Molina Quiñones
   ========================================================= */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

------------------------------------------------------------
-- CASO 1: Listado de Clientes con Rango de Renta
------------------------------------------------------------


-- CASO 1
SELECT
    REPLACE(TO_CHAR(c.numrut_cli, 'FM999G999G999G999'), ',', '.') 
        || '-' || c.dvrut_cli                      AS "RUT Cliente",
    INITCAP(c.appaterno_cli || ' ' || c.apmaterno_cli
            || ' ' || c.nombre_cli)               AS "Nombre Completo Cliente",
    c.direccion_cli                               AS "Dirección Cliente",
    TO_CHAR(c.renta_cli, '$999G999G999')          AS "Renta Cliente",
    TO_CHAR(c.celular_cli)                        AS "Celular Cliente",

    CASE
        WHEN c.renta_cli > 500000 THEN 'TRAMO 1'
        WHEN c.renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
        WHEN c.renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
        ELSE 'TRAMO 4'
    END                                           AS "Tramo Renta Cliente"
FROM cliente c
WHERE c.renta_cli BETWEEN &RENTA_MINIMA AND &RENTA_MAXIMA
  AND c.celular_cli IS NOT NULL
ORDER BY "Nombre Completo Cliente" ASC;



------------------------------------------------------------
-- CASO 2: Sueldo Promedio por Categoría de Empleado
------------------------------------------------------------

SELECT
    e.id_sucursal                                         AS "COD SUC",
    INITCAP(s.desc_sucursal)                              AS "SUCURSAL",
    e.id_categoria_emp                                    AS "COD CAT",
    INITCAP(ce.desc_categoria_emp)                        AS "CATEGORIA",
    COUNT(*)                                              AS "TOTAL EMPLEADOS",
    TO_CHAR(
        NVL(ROUND(AVG(e.sueldo_emp)), 0),
        'L999G999G999'
    )                                                     AS "SUELDO PROMEDIO",
    TO_CHAR(SYSDATE, 'DD/MM/YYYY')                        AS "FECHA REPORTE"
FROM empleado e
JOIN sucursal s
  ON e.id_sucursal = s.id_sucursal
JOIN categoria_empleado ce
  ON e.id_categoria_emp = ce.id_categoria_emp
GROUP BY
    e.id_sucursal,
    INITCAP(s.desc_sucursal),
    e.id_categoria_emp,
    INITCAP(ce.desc_categoria_emp),
    TO_CHAR(SYSDATE, 'DD/MM/YYYY')
HAVING AVG(e.sueldo_emp) >= &SUELDO_PROMEDIO_MINIMO
ORDER BY AVG(e.sueldo_emp) DESC;


------------------------------------------------------------
-- CASO 3: Arriendo Promedio por Tipo de Propiedad
------------------------------------------------------------

SELECT
    p.id_tipo_propiedad                                   AS "COD TIPO",
    UPPER(tp.desc_tipo_propiedad)                         AS "TIPO PROPIEDAD",
    COUNT(*)                                              AS "TOTAL PROPIEDADES",
    TO_CHAR(ROUND(AVG(p.valor_arriendo)),
            'L999G999G999')                               AS "PROM ARRIENDO",
    ROUND(AVG(p.superficie), 2)                           AS "PROM SUPERFICIE",
    ROUND(AVG(p.valor_arriendo / p.superficie), 0)        AS "PROM ARRIENDO M2",
    CASE
        WHEN AVG(p.valor_arriendo / p.superficie) < 5000 THEN 'Economico'
        WHEN AVG(p.valor_arriendo / p.superficie)
             BETWEEN 5000 AND 10000 THEN 'Medio'
        ELSE 'Alto'
    END                                                   AS "CLASIFICACION",
    TO_CHAR(SYSDATE, 'DD/MM/YYYY')                        AS "FECHA REPORTE"
FROM propiedad p
JOIN tipo_propiedad tp
  ON p.id_tipo_propiedad = tp.id_tipo_propiedad
GROUP BY
    p.id_tipo_propiedad,
    UPPER(tp.desc_tipo_propiedad),
    TO_CHAR(SYSDATE, 'DD/MM/YYYY')
HAVING AVG(p.valor_arriendo / p.superficie) > 1000
ORDER BY AVG(p.valor_arriendo / p.superficie) DESC;

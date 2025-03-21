-- Drop tables
DELETE FROM AutopartesConstelacion.dbo.FactFactura;
DELETE FROM AutopartesConstelacion.dbo.FactEntrada;
DELETE FROM AutopartesConstelacion.dbo.FactSalida;
DELETE FROM AutopartesConstelacion.dbo.DimFecha;
DELETE FROM AutopartesConstelacion.dbo.DimCliente;
DELETE FROM AutopartesConstelacion.dbo.DimVendedor;
DELETE FROM AutopartesConstelacion.dbo.DimMedioEmbarque;
DELETE FROM AutopartesConstelacion.dbo.DimCondicionPago;
DELETE FROM AutopartesConstelacion.dbo.DimArticulo;
DELETE FROM AutopartesConstelacion.dbo.DimSubFactura;
DELETE FROM AutopartesConstelacion.dbo.DimSubEntrada;
DELETE FROM AutopartesConstelacion.dbo.DimSubSalida;

-- DimFecha
SELECT DISTINCT
     CONVERT(INT, CONVERT(CHAR(8), FE.Fecha, 112)) AS FechaID,
     CAST(FE.Fecha AS DATE) AS Fecha,
     YEAR(FE.Fecha) AS Anio,
     CASE WHEN MONTH(FE.Fecha) <= 6 THEN 1 ELSE 2 END AS Semestre,
     ((MONTH(FE.Fecha) - 1) / 4) + 1 AS Cuatrimestre,
     ((MONTH(FE.Fecha) - 1) / 3) + 1 AS Trimestre,
     MONTH(FE.Fecha) AS Mes,
     DAY(FE.Fecha) AS Dia,
     DATENAME(WEEKDAY, FE.Fecha) AS NombreDia
FROM AutopartesP2025.dbo.FacturaEncabezado AS FE
WHERE FE.Fecha IS NOT NULL;

-- DimCliente
SELECT 
     UPPER(C.Clave) AS Clave,
     C.RazonSocial,
     C.CalleNumero,
     C.Colonia,
     C.Ciudad,
     C.Estado,
     C.Pais,
     C.CodigoPostal,
     C.ClienteTipo,
     C.ClienteGrupo,
     C.Vendedor,
     C.Moneda,
     C.CondicionPago,
     C.ZonaVenta
FROM AutopartesP2025.dbo.Cliente AS C
UNION
SELECT 
     '999' AS Clave,
     'Desconocido' AS RazonSocial,
     'Desconocido' AS CalleNumero,
     'Desconocido' AS Colonia,
     'Desconocido' AS Ciudad,
     'Desconocido' AS Estado,
     'Desconocido' AS Pais,
     'Desconocido' AS CodigoPostal,
     'Desconocido' AS ClienteTipo,
     'Desconocido' AS ClienteGrupo,
     'Desconocido' AS Vendedor,
     'Desconocido' AS Moneda,
     'Desconocido' AS CondicionPago,
     'Desconocido' AS ZonaVenta;

-- DimVendedor
SELECT DISTINCT
     UPPER(V.Clave) AS Clave,
     V.Nombre
FROM AutopartesP2025.dbo.Vendedor AS V
UNION
SELECT '999' AS Clave, 'Desconocido' AS Nombre;

-- DimMedioEmbarque
SELECT DISTINCT
     M.Clave,
     M.Descripcion
FROM AutopartesP2025.dbo.MedioEmbarque AS M
UNION 
SELECT '999' AS Clave,
	'Desonocido' AS Descripcion;

-- DimCondicionPago
SELECT DISTINCT
     CP.Clave,
     CP.Descripcion
FROM AutopartesP2025.dbo.CondicionPago AS CP
UNION 
SELECT '999' AS Clave,
	'Desconocido' AS Descripcion;

-- DimArticulo
SELECT DISTINCT
     UPPER(A.Clave) AS Clave,
     UPPER(A.Descripcion) AS Descripcion,
     LOWER(A.Identificacion) AS Marca,
     A.ArticuloTipo AS Tipo,
     A.ArticuloGrupo AS Grupo,
     A.ArticuloClase AS Clase,
     A.Almacenable,
     A.UMedInv,
     A.UMedVta,
     A.UMedCpa,
     A.Moneda,
     A.Precio,
     A.pctDescuento,
     A.UbicacionAlmacen,
     A.UbicacionClave
FROM AutopartesP2025.dbo.Articulo AS A
UNION 
SELECT '999' AS Clave, 
     'Desconocido' AS Descripcion,
     'Desconocido' AS Marca,
     'Desconocido' AS Tipo,
     'Desconocido' AS Grupo,
     'Desconocido' AS Clase,
     'D' AS Almacenable,
     'Desconocido' AS UMedInv,
     'Desconocido' AS UMedVta,
     'Desconocido' AS UMedCpa,
     'Desconocido' AS Moneda,
     0 AS Precio,
     0 AS pctDescuento,
     'Desconocido' AS UbicacionAlmacen,
     'Desconocido' AS UbicacionClave;

-- DimSubFactura
SELECT DISTINCT FE.Folio AS FacturaFolio
FROM AutopartesP2025.dbo.FacturaEncabezado AS FE;

-- DimSubEntrada
SELECT DISTINCT EE.Folio AS EntradaFolio
FROM dbo.EntradaEncabezado EE;

-- DimSubSalida
SELECT DISTINCT SE.Folio AS SalidaFolio
FROM dbo.SalidaEncabezado SE;

-- FactFactura
SELECT
     FD.Folio AS FacturaFolio,
     ROW_NUMBER() OVER (PARTITION BY FD.Folio ORDER BY FD.Articulo) AS NumeroLinea,
     CONVERT(INT, CONVERT(CHAR(8), FE.Fecha, 112)) AS FechaClave,
     UPPER(FE.Cliente) AS ClienteClave,
     FE.Vendedor AS VendedorClave,
     UPPER(FE.MedioEmbarque) AS MedioEmbarqueClave,
     FE.CondicionPago AS CondicionPagoClave,
     FD.Articulo AS ArticuloClave,
     FD.Cantidad,
     FD.Precio AS PrecioUnitario,
     FE.pctDescuentoGlobal,
     FE.RacIVA,
     FD.TotalImporte,
     FD.TotalDescuento,
     FE.TotalRetencion,
     FD.Total
FROM AutopartesP2025.dbo.FacturaDetalle AS FD
INNER JOIN AutopartesP2025.dbo.FacturaEncabezado AS FE ON FD.Folio = FE.Folio
WHERE FE.Fecha IS NOT NULL;

-- FactEntrada
SELECT
    EE.Folio AS EntradaFolio,
    ROW_NUMBER() OVER (PARTITION BY EE.Folio ORDER BY ED.Articulo) AS NumeroLinea,
    CONVERT(INT, CONVERT(CHAR(8), EE.Fecha, 112)) AS FechaClave,
    COALESCE(NULLIF(UPPER(EE.Cliente), ''), '999') AS ClienteClave,
    COALESCE(NULLIF(UPPER(EE.Vendedor), ''), '999') AS VendedorClave,
    COALESCE(NULLIF(UPPER(ED.Articulo), ''), '999') AS ArticuloClave,
    ED.Cantidad,
    ED.Precio AS PrecioUnitario,
    ED.pctDescuento,
    EE.pctDescuentoGlobal,
    ED.pctImpuesto,
    ED.TotalImporte,
    ED.TotalDescuento, 
    ED.TotalImpuesto,
    ED.Total
FROM AutopartesP2025.dbo.EntradaEncabezado EE
INNER JOIN AutopartesP2025.dbo.EntradaDetalle ED
    ON EE.Folio = ED.Folio
WHERE EE.Fecha IS NOT NULL;

-- FactSalida
SELECT
    SE.Folio AS SalidaFolio,
    ROW_NUMBER() OVER (PARTITION BY SE.Folio ORDER BY SD.Partida) AS NumeroLinea,
    CONVERT(INT, CONVERT(CHAR(8), SE.Fecha, 112)) AS FechaClave,
    COALESCE(NULLIF(UPPER(SE.Cliente), ''), '999') AS ClienteClave,
    COALESCE(NULLIF(UPPER(SE.Vendedor), ''), '999') AS VendedorClave,
    COALESCE(NULLIF(UPPER(SE.MedioEmbarque), ''), '999') AS MedioEmbarqueClave,
    COALESCE(NULLIF(UPPER(SE.CondicionPago), ''), '999') AS CondicionPagoClave,
    COALESCE(NULLIF(UPPER(SD.Articulo), ''), '999') AS ArticuloClave,
    SD.Cantidad,
    SD.Precio AS PrecioUnitario,
    SD.pctDescuento,
    SE.pctDescuentoGlobal,
    SD.pctImpuesto,
    SD.TotalImporte,
    SD.TotalDescuento,
    0 AS TotalRetencion,
    SD.TotalImpuesto,
    SD.Total
FROM dbo.SalidaEncabezado SE
INNER JOIN dbo.SalidaDetalle SD
    ON SE.Folio = SD.Folio
WHERE SE.Fecha IS NOT NULL;

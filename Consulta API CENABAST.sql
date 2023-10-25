
SELECT
nventa.RetiradoPor AS Doc_Cenabast
, CASE WHEN gsaen.Tipo = 'F' THEN '1' ELSE '0' END as FacturaGuia,
CONVERT(int, gsaen.folio) AS Folio,
CONVERT(datetime, gsaen.Fecha) AS FechaCreacion,
CONVERT(varchar(30), gmovi.DetProd) AS Producto,
CONVERT(varchar(30),gmovi.Partida) AS Lote,
CONVERT(int, gmovi.CantFacturada) AS Cantidad
FROM softland.iw_gsaen gsaen
INNER JOIN softland.iw_gmovi gmovi
ON gsaen.NroInt = gmovi.NroInt AND gsaen.Tipo = gmovi.Tipo
INNER JOIN softland.nw_nventa nventa
ON nventa.NVNumero = gsaen.nvnumero
WHERE gsaen.Fecha BETWEEN  CONVERT(datetime,@fecha_inicio ,103)   AND  CONVERT(datetime,@fecha_termino ,103)
AND gsaen.CodBode = '03'
AND gsaen.tipo = 'F'
AND gsaen.SubTipoDocto = 'T'
AND LEN(LTRIM(RTRIM(nventa.RetiradoPor))) > 0
UNION ALL
SELECT
nventa.RetiradoPor AS Doc_Cenabast
, CASE WHEN gsaen.Tipo = 'F' THEN '1' ELSE '0' END as FacturaGuia,
CONVERT(int, gsaen.folio) AS Folio,
CONVERT(datetime, gsaen.Fecha) AS FechaCreacion,
CONVERT(varchar(30), gmovi.DetProd) AS Producto,
CONVERT(varchar(30),gmovi.Partida) AS Lote,
CONVERT(int, gmovi.CantDespachada) AS Cantidad
FROM softland.iw_gsaen gsaen
INNER JOIN softland.iw_gmovi gmovi
ON gsaen.NroInt = gmovi.NroInt AND gsaen.Tipo = gmovi.Tipo
INNER JOIN softland.nw_nventa nventa ON nventa.NVNumero = gsaen.nvnumero
WHERE gsaen.Fecha BETWEEN  CONVERT(datetime,@fecha_inicio ,103)   AND  CONVERT(datetime,@fecha_termino ,103)
AND gsaen.CodBode = '03'
AND gsaen.tipo = 'S'
AND gsaen.SubTipoDocto = 'T'
AND LEN(LTRIM(RTRIM(nventa.RetiradoPor))) > 0

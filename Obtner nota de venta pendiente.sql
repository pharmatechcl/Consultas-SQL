USE PHARMATECH
SELECT 

NW_vsnpDetNV.CodProd, 
iw_tprod.DesProd,
NW_vsnpDetNV.NVNumero, 
nw_nventa.FechaHoraCreacion,
nw_nventa.NumOC,
nw_nventa.CodAux,
cwtauxi.NomAux,
NW_vsnpDetNV.nvCant, 
NW_vsnpDetNV.nvPrecio, 
NW_vsnpDetNV.NVCantFact, 
NW_vsnpDetNV.NVCantDesp,
(nvCant - NVCantFact) AS PendienteFacturar,
((nvCant - NVCantFact)*nvPrecio) AS PendienteValorizado,
cwtvend.VenDes,
MST_Producto.Linea

FROM softland.NW_vsnpDetNV 
INNER JOIN softland.nw_nventa 
ON NW_vsnpDetNV.NVNumero = nw_nventa.NVNumero 

INNER JOIN softland.iw_tprod 
ON NW_vsnpDetNV.CodProd = iw_tprod.CodProd

INNER JOIN softland.cwtauxi
ON nw_nventa.CodAux = cwtauxi.CodAux

INNER JOIN softland.cwtvend
ON nw_nventa.VenCod = cwtvend.VenCod

INNER JOIN PHARMATECH2.dbo.MST_Producto
ON NW_vsnpDetNV.CodProd = MST_Producto.CodProd


WHERE FechaHoraCreacion BETWEEN '20231001' AND GETDATE()
AND nw_nventa.VenCod <> 'CE'
AND nw_nventa.VenCod <> 'OF'
AND nvCant > NVCantFact

ORDER BY PendienteValorizado DESC

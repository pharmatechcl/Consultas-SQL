SELECT	

		isnull([DOCUMENTOSII].[DocDes],'SinDco') AS DescDoc,
		isnull([SALIDAYENTRADA].[Folio], 'Sin folio') AS Folio, 
		isnull([SALIDAYENTRADA].[AuxDocNum], '0000') AS NumDocAsoc,
		isnull(CONVERT(VARCHAR(10),[SALIDAYENTRADA].[AuxDocfec], 103), '') AS NumDocFec,
		isnull(convert(numeric(10),[SALIDAYENTRADA].[Fecha]-[SALIDAYENTRADA].[AuxDocfec], 1), '0000') as DifDías,
        case when nw_nventa.NumOC = '0' THEN 'Sin NV asociada' when nw_nventa.NumOC IS NULL THEN 'Sin NV asociada' when nw_nventa.NumOC = ' ' THEN 'Sin NV asociada' ELSE nw_nventa.NumOC END AS NumeroOC,
        case when iw_gsaen.nvnumero = 0 THEN 'Sin NV asociada' ELSE CAST(iw_gsaen.nvnumero AS nvarchar(20)) end as NumeroNV,
        
  

	
		DATEPART(year,[SALIDAYENTRADA].[Fecha]) as Año,
		DATEPART(month,[SALIDAYENTRADA].[Fecha]) as  Mes,
		DATEPART(day,[SALIDAYENTRADA].[Fecha]) as  Dia,
		isnull([AUXILIARES].CodAux,'OF') AS CodAux,
		isnull([AUXILIARES].NomAux,'OFICINA') AS Nombre_Aux,
		isnull([MOVIMIENTOS].Partida, 'Sin Lote') as Lote,
		isnull([MOVIMIENTOS].[CodProd], '0000') as CodProducto,
		isnull([TABLA_PRODUCTO].[DesProd], 'VENTAS SIN PRODUCTO ASOCIADO') as DescProducto,
		

		 (Select Top 1 round([PHARMATECH].[softland].[iw_costop].CostoUnitario,0) From [PHARMATECH].[softland].[iw_costop]
							Where [PHARMATECH].[softland].[iw_costop].CodProd = MOVIMIENTOS.CodProd 
							AND [PHARMATECH].[softland].[iw_costop].Fecha <= convert(datetime,SALIDAYENTRADA.fecha,103)
						Order by [PHARMATECH].[softland].[iw_costop].Fecha Desc) as Costo,
						
						
		round(MOVIMIENTOS.PreUniMB,0) as pventa,
		SUM(MOVIMIENTOS.CantFacturada) AS CantFact,

		SUM(round((MOVIMIENTOS.PreUniMB * MOVIMIENTOS.CantFacturada ),0)) AS TOTAL_SIN_DESCUENTO,
					   MOVIMIENTOS.DescMov01 AS Descto1,
					   MOVIMIENTOS.DescMov02 AS Descto2,
		round(MOVIMIENTOS.TotLinea,0) AS TOTAL_CON_DESCUENTO,

		(Select Top 1 round([PHARMATECH].[softland].[iw_costop].CostoUnitario,0) From [PHARMATECH].[softland].[iw_costop]
							Where [PHARMATECH].[softland].[iw_costop].CodProd = MOVIMIENTOS.CodProd 
							AND [PHARMATECH].[softland].[iw_costop].Fecha <= convert(datetime,SALIDAYENTRADA.fecha,103)
						Order by [PHARMATECH].[softland].[iw_costop].Fecha Desc) * SUM(MOVIMIENTOS.CantFacturada) as CostoTotal,
				
						(Select Top 1 round((((MOVIMIENTOS.PreUniMB - [PHARMATECH].[softland].[iw_costop].CostoUnitario) * SUM(MOVIMIENTOS.CantFacturada)) - (MOVIMIENTOS.TotalDescMov )  ),0) From [PHARMATECH].[softland].[iw_costop]
							Where [PHARMATECH].[softland].[iw_costop].CodProd = MOVIMIENTOS.CodProd 
							AND [PHARMATECH].[softland].[iw_costop].Fecha <= convert(datetime,SALIDAYENTRADA.fecha,103)
						Order by [PHARMATECH].[softland].[iw_costop].Fecha Desc) as Contribucion,

		isnull([VENDEDORES].[VenDes],'SIN VENDEDOR') as Vendedor,
		isnull(MST_Producto.Proveedor, 'PRODUCTO SIN PROVEEDOR') as Proveedor,
		
		isnull(MST_Producto.tipo, 'PRODUCTO SIN TIPO') as 'Tipo Producto',
		
		isnull(MST_Producto.Linea, 'PRODUCTO SIN LINEA') as 'Linea Producto',
		isnull(MST_Producto.sublinea, 'PRODUCTO SIN SUBLINEA') as 'Sublinea Producto',
		isnull(MST_Producto.modelo, 'PRODUCTO SIN MODELO') as 'Modelo Producto',
		
		
		isnull([MST_Cliente].categoria1, 'SIN CATEGORIA 1') as categoria_1,
		isnull([MST_Cliente].categoria2, 'SIN CATEGORIA 2') as categoria_2,
		isnull([TABLA_PRODUCTO].CtaVentas, '0000') as CtaVentas,
		isnull([TABLA_PRODUCTO].CtaCosto, '0000') as CtaCosto

FROM [PHARMATECH].[softland].[iw_gmovi] AS [MOVIMIENTOS]
	LEFT JOIN [PHARMATECH].[softland].[iw_tprod] AS [TABLA_PRODUCTO]
	ON [TABLA_PRODUCTO].[CodProd] = [MOVIMIENTOS].[CodProd] 
	INNER JOIN [PHARMATECH].[softland].[iw_gsaen] AS [SALIDAYENTRADA]
	ON [MOVIMIENTOS].[Tipo] = [SALIDAYENTRADA].[Tipo]
	AND [MOVIMIENTOS].[NroInt] = [SALIDAYENTRADA].[NroInt]
	LEFT JOIN [PHARMATECH].[softland].[cwtvend] AS [VENDEDORES]
	ON [VENDEDORES].[VenCod] = [SALIDAYENTRADA].[CodVendedor]
	LEFT JOIN [PHARMATECH].[softland].[cwtauxi] AS [AUXILIARES]
	ON [SALIDAYENTRADA].[CodAux] = [AUXILIARES].[CodAux]
	LEFT JOIN [PHARMATECH].[softland].[Vsnp_DTE_SiiTDoc] AS [DOCUMENTOSII]
	ON  [SALIDAYENTRADA].[Tipo] = [DOCUMENTOSII].[Tipo] 
	AND [SALIDAYENTRADA].[SubTipoDocto] = [DOCUMENTOSII].[SubTipoDocto]
	LEFT JOIN  [PHARMATECH].[softland].[iw_cocod] AS [DOCUCONCEPTOS]
	ON [SALIDAYENTRADA].[Tipo] = [DOCUCONCEPTOS].[TipoDoc]
	AND [SALIDAYENTRADA].[Concepto] = [DOCUCONCEPTOS].[Concepto]
	LEFT JOIN [PHARMATECH2].[dbo].[MST_Cliente] AS [MST_Cliente] 
	ON [MST_Cliente].[CodAux] = [AUXILIARES].CodAux
	LEFT JOIN [PHARMATECH2].[dbo].[MST_Producto] AS [MST_Producto] 
	ON [MST_Producto].[CodProd] = [MOVIMIENTOS].[CodProd]
	LEFT JOIN [PHARMATECH].[softland].[cwpctas] AS [Cuentas]
	ON [Cuentas].PCCODI = [TABLA_PRODUCTO].CtaVentas
    INNER JOIN [PHARMATECH].[softland].[iw_gsaen] 
    ON [iw_gsaen].[NroInt] = [MOVIMIENTOS].[NroInt]
    INNER JOIN [PHARMATECH].[softland].[nw_nventa] 
    ON [nw_nventa].[NVNumero] = [iw_gsaen].[nvnumero]

	

WHERE  [SALIDAYENTRADA].[Estado] = 'V'
				AND	   [SALIDAYENTRADA].[Folio]  > 0
				AND	   [SALIDAYENTRADA].[Tipo]  in ('F','B','N','D') -- AND DOCUCONCEPTOS.Concepto IN ('01','04') -- 'F','B','N','D',
				AND DATEPART(year, [SALIDAYENTRADA].[Fecha]) IN ('2021','2022','2023')


GROUP BY   MOVIMIENTOS.TotalDescMov,MOVIMIENTOS.TotLinea, MOVIMIENTOS.DescMov01, MOVIMIENTOS.DescMov02,AUXILIARES.CodAux,MOVIMIENTOS.PreUniMB,DOCUMENTOSII.DocDes,MOVIMIENTOS.Partida,MOVIMIENTOS.CodProd, TABLA_PRODUCTO.DesProd,SALIDAYENTRADA.Tipo, SALIDAYENTRADA.Folio,VENDEDORES.VenDes,SALIDAYENTRADA.fecha,AUXILIARES.NomAux,
				[MST_Cliente].categoria1,[MST_Cliente].categoria2,
				MST_Producto.tipo, MST_Producto.linea, MST_Producto.sublinea, MST_Producto.modelo,MST_Producto.proveedor, [DOCUCONCEPTOS].DesCodDr, [SALIDAYENTRADA].[AuxDocNum],[SALIDAYENTRADA].[AuxDocfec],
				[TABLA_PRODUCTO].CtaVentas,[TABLA_PRODUCTO].CtaCosto,iw_gsaen.Orden,iw_gsaen.nvnumero,nw_nventa.NumOC
				ORDER BY  SALIDAYENTRADA.fecha DESC

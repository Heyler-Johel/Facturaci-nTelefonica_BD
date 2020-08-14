USE [FacturacionTelefonica]
GO
/****** Object:  StoredProcedure [dbo].[spCargarConfiguracionTarifas]    Script Date: 13/8/2020 00:00:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spCargarConfiguracionTarifas]
AS
BEGIN
	SET NOCOUNT ON;                                                                                                                                                                                                                                                                                             

	-- VARIABLES --
	DECLARE @Configuracion XML

	BEGIN TRY

		--Insercion de los tipos de CCobro
		SELECT @Configuracion = Cf
		--FROM OPENROWSET (Bulk 'D:\Base de datos\FacturacionTelefonica_BD\Base de Datos\XML\configuracionTarifas.xml', Single_BLOB) 
		FROM OPENROWSET (Bulk 'C:\Users\Johel Mora\Desktop\FacturacionTelefonica_BD\Base de Datos\XML\configuracionTarifas.xml', Single_BLOB) 

		AS Configuracion(Cf);

		--Insertamos el tipo de Movimiento 
		INSERT INTO [dbo].[TIpoMovimiento](ID, Nombre)
		SELECT	tm.value('@ID', 'INT')
			   ,tm.value('@Nombre', 'VARCHAR(100)')
		FROM @Configuracion.nodes('/configTarifas/TipoMovimientp') AS t(tm);

		--Insertamos el tipo de relacion familiar
		INSERT INTO [dbo].[TipoRelacion](ID, Nombre)
		SELECT	cf.value('@ID', 'INT')
				,	cf.value('@Nombre', 'VARCHAR(100)')
		FROM @Configuracion.nodes('/configTarifas/TipoRelacionFamiliar') AS t(cf);
		

		INSERT INTO [dbo].[TipoTarifa](ID, Nombre)
		SELECT	tt.value('@ID','INT')
				,	tt.value('@Nombre', 'VARCHAR(100)')

		FROM @Configuracion.nodes('/configTarifas/TipoTarifa') AS t(tt);

		INSERT INTO [dbo].[TipoElemento](ID, Nombre, TipoValor)
		SELECT	te.value('@ID', 'INT')
				,	te.value('@Nombre', 'VARCHAR(100)')
				, te.value('@TipoValor', 'VARCHAR(100)')
		FROM @Configuracion.nodes('/configTarifas/TipoElemento') AS t(te);

		INSERT INTO [dbo].[ElementoDeTipoTarifa](IdTipoTarifa, IdTipoElemento, Valor)
		SELECT et.value('@IDTipoTarifa', 'INT')
				, et.value('@IDTipoElemento', 'INT')
				, et.value('@Valor', 'MONEY')
		FROM @Configuracion.nodes('/configTarifas/ElementoDeTipoTarifa') AS t(et);

		RETURN 1
		
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
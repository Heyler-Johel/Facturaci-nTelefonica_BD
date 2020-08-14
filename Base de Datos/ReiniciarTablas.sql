USE [FacturacionTelefonica]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kevin Fallas, Johel Mora>
-- Create date: <13/8/2020>
-- Description:	<Reinicio de las tablas>
-- =============================================
CREATE OR ALTER PROCEDURE ReiniciarTablas
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [FacturacionTelefonica].[dbo].[RelacionFamiliar]
		DBCC CHECKIDENT ('[RelacionFamiliar]', RESEED, 0) --reinicia identity

	DELETE FROM [FacturacionTelefonica].[dbo].[ElementoDeTipoTarifa]

	DELETE FROM [FacturacionTelefonica].[dbo].[TipoRelacion]

	DELETE FROM [FacturacionTelefonica].[dbo].[TipoElemento]
	
	DELETE FROM [FacturacionTelefonica].[dbo].[Contrato]
		DBCC CHECKIDENT ('[Contrato]', RESEED, 0) 

	DELETE FROM [FacturacionTelefonica].[dbo].[Cliente]
		DBCC CHECKIDENT ('[Cliente]', RESEED, 0) 

	DELETE FROM [FacturacionTelefonica].[dbo].[TipoTarifa]
END

EXEC ReiniciarTablas
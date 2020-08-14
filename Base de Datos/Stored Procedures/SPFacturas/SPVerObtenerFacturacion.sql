SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kevin Fallas y Johel Mora
-- Create date: 13/08/2020
-- Description:	SP para obtener facturas de un número teléfonico
-- =============================================
CREATE OR ALTER PROCEDURE dbo.spObtenerFacturas
@Tel int, @Estado bit
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT F.ID, F.Fecha FROM Factura AS F
		INNER JOIN Contrato AS C ON C.ID = F.IdContrato
		WHERE @Tel = C.NumTelefono AND @Estado = F.Estado
	END TRY
	BEGIN CATCH
		THROW 60000,'Error: No se ha podido buscar Facturas',1;
	END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.spVerFactura
@ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT ID, Fecha, FechaPago, SaldoUsoMega, SaldoMinutos110, SaldoMinutos800, SaldoMinutos900, MontoTotalAPagar FROM Factura AS F
		WHERE @ID = F.ID
	END TRY
	BEGIN CATCH
		THROW 60000,'Error: No se ha podido buscar Factura',1;
	END CATCH
END
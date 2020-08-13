SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kevin y Johel
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
		INNER JOIN Detalle AS D ON D.IdFactura = F.ID
		INNER JOIN ElementoDeTipoTarifa AS ETT ON ETT.ID = D.IdElementoTarifa
		INNER JOIN TipoTarifa AS TT ON TT.ID = ETT.IdTipoTarifa
		INNER JOIN Contrato AS C ON C.IdTipoTarifa = TT.ID
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
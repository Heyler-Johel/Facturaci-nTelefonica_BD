 
-- ==========================================================================================
-- Autores:		<Kevin Fallas y Johel Mora>
-- Fecha de creacion: <13/8/2020>
-- Descripcion:	<SP para hacer la simulacion de actividades diarias de la telefonia>
-- ==========================================================================================


-- precondición, los nodos para la fecha de operación en el XML vienen en orden ascendente.

/****** Object:  StoredProcedure [dbo].[SimulacionOperacionesDiarias]    Script Date: 13/8/2020  ******/
USE [FacturacionTelefonica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [dbo].[SimulacionOperacionesDiarias]
AS

BEGIN
	SET NOCOUNT ON 

	/*
	
	DECLARE @Table TABLE
	(
		
	)
	
	*/
	--Tablas definidas
	DECLARE @LlamadasTelefonicas LlamadasTelefonicasType
	DECLARE @UsoDatos UsoDatosType

	-- se extraen fechas operación
	DECLARE @FechaOperacion DATE

	DECLARE @FechasAProcesar TABLE 
	(
	   sec INT IDENTITY(1,1) PRIMARY KEY, 
	   fecha DATE
	);

	-- Variables para leer xml
	DECLARE @DocumentoXML xml

	--Obtenemos informacion del XML
	SELECT @DocumentoXML = DXML
	FROM OPENROWSET (Bulk 'D:\Base de datos\FacturacionTelefonica_BD\Base de Datos\XML\Operaciones.xml', Single_BLOB) AS DocumentoXML(DXML)

	BEGIN TRY
		INSERT @FechasAProcesar (fecha)
		SELECT f.value('@fecha', 'DATE')
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia') AS t(f);
	END TRY
	BEGIN CATCH
		PRINT 'Hubo un error de cargar fechas'
		RETURN @@ERROR * -1;
	END CATCH;

	-- Variables para controlar la iteración
	DECLARE @Lo1 INT, 
			@Hi1 INT, 
			@Lo2 INT, 
			@Hi2 INT;

	DECLARE @minfecha DATE, 
			@maxfecha DATE;

	-- iterando de la fecha más antigua a la menos antigua
	SELECT @minfecha = MIN(F.fecha), @maxfecha = MAX(F.fecha)  
	FROM @FechasAProcesar F;

	SELECT @Lo1 = F.sec
	FROM @FechasAProcesar F
	WHERE F.Fecha = @minfecha;

	SELECT @Hi1 = F.sec
	FROM @FechasAProcesar F
	WHERE F.Fecha=@maxfecha;
	
	--iteramos por fecha para simular operaciones diarias
	WHILE @Lo1<=@Hi1
	BEGIN
		
		--Para poder filtrar los clientes de un solo día
		SELECT @FechaOperacion = F.Fecha 
		FROM @FechasAProcesar F 
		WHERE sec = @Lo1;
		
		--Insertamos los clientes del dia en que se esta iterando
		INSERT INTO [dbo].[Cliente](Nombre, Identificacion)
		SELECT  c.value('@Nombre', 'VARCHAR(100)')
			  , c.value('@Identificacion', 'INT')
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia[@fecha eq sql:variable("@FechaOperacion")]/ClienteNuevo') AS t(c);
		
		--Insertamos los contratos hechos en un día
		INSERT INTO [dbo].[Contrato](IdCliente, IdTipoTarifa, Fecha, NumTelefono)
		SELECT  C.ID
			  , ct.value('@TipoTarifa', 'INT')
			  , @FechaOperacion AS Fecha
			  , ct.value('@Numero', 'VARCHAR(100)')
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia[@fecha eq sql:variable("@FechaOperacion")]/NuevoContrato') AS t(ct)
		INNER JOIN Cliente C ON C.Identificacion = t.ct.value('@Identificacion','INT')

		--Insertamos relaciones familiares
		INSERT INTO [dbo].[RelacionFamiliar](IdCliente, IdFamiliar, idTipoRelacion)
		SELECT	CD.ID
			  , CA.ID
			  , r.value('@TipoRelacion', 'INT')
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia[@fecha eq sql:variable("@FechaOperacion")]/RelacionFamiliar') AS t(r)
		INNER JOIN Cliente CD ON CD.Identificacion = t.r.value('@IdentificacionDe','INT')
		INNER JOIN Cliente CA ON CA.Identificacion = t.r.value('@IdentificacionA', 'INT');

		--Guardamos todas las llamadas en una tabla definida, para luego ser procesadas
		DELETE @LlamadasTelefonicas
		INSERT INTO @LlamadasTelefonicas(NumeroDe, NumeroA, HoraInicio, HoraFin)
		SELECT lt.value('@NumeroDe','VARCHAR(100)')
			 , lt.value('@NumeroA', 'VARCHAR(100)')
			 , lt.value('@Inicio', 'TIME')
			 , lt.value('@Fin', 'TIME')
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia[@fecha eq sql:variable("@FechaOperacion")]/LlamadaTelefonica') AS t(lt);
		--TODO: hacer sp para procesar llamadas

		--Guardamos los consumos de megas
		DELETE @UsoDatos
		INSERT INTO @UsoDatos(Numero, CantMegas)
		SELECT	ud.value('@Numero','VARCHAR(100)')
		      , ud.value('@CantMegas', 'FLOAT') 
		FROM @DocumentoXML.nodes('/Operaciones_por_Dia/OperacionDia[@fecha eq sql:variable("@FechaOperacion")]/UsoDatos') AS t(ud);
		--sp para procesar el consumo de megas

		SET @Lo1 = @Lo1 + 1;
		
	END
	
END

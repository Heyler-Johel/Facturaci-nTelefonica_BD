Use [FacturacionTelefonica]
GO

IF type_id('[dbo].[LlamadasTelefonicasType]') IS NOT NULL
        DROP TYPE [dbo].[LlamadasTelefonicasType]; 

CREATE TYPE LlamadasTelefonicasType AS TABLE 
(
	ID INT IDENTITY(1,1),
	NumeroDe VARCHAR(100),
	NumeroA VARCHAR(100),
	HoraInicio TIME(0),
	HoraFin TIME(0)
);


IF type_id('[dbo].[UsoDatosType]') IS NOT NULL
        DROP TYPE [dbo].[UsoDatosType]; 

CREATE TYPE UsoDatosType AS TABLE
(
	ID INT IDENTITY(1,1),
	Numero VARCHAR(100),
	CantMegas FLOAT
);



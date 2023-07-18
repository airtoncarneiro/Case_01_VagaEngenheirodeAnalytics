DROP TABLE IF EXISTS [dbo].[FatoDespesas]
DROP TABLE IF EXISTS [dbo].[DimFavorecido]
DROP TABLE IF EXISTS [dbo].[DimMunicipio]
DROP TABLE IF EXISTS [dbo].[DimOrgaoSuperior]
DROP TABLE IF EXISTS [dbo].[DimOrgaoUndGestora]
DROP TABLE IF EXISTS [dbo].[DimOrgaoVinculado]
DROP TABLE IF EXISTS [dbo].[DimTipoFavorecido]
DROP TABLE IF EXISTS [dbo].[stage]
DROP TABLE IF EXISTS [dbo].[log_error]
GO

BEGIN TRY
	BEGIN TRAN

		CREATE TABLE [dbo].[DimFavorecido] (
			id_favorecido		INT NOT NULL	IDENTITY,
			cpfcnpjfavorecido	NVARCHAR(14) NOT NULL,
			nomefavorecido		NVARCHAR(250) NOT NULL,
			PRIMARY KEY (id_favorecido))

		CREATE TABLE [dbo].[DimTipoFavorecido] (
			id_tipofavorecido	INT NOT NULL	IDENTITY,
			tipoFavorecido		NVARCHAR(250) NOT NULL,
			PRIMARY KEY (id_tipofavorecido))

		CREATE TABLE [dbo].[DimMunicipio] (
			id_municipio		INT NOT NULL	IDENTITY,
			uf					CHAR(2) NOT NULL,
			nomemunicipio		NVARCHAR(250) NOT NULL,
			PRIMARY KEY (id_municipio))

		CREATE TABLE [dbo].[DimOrgaoSuperior] (
			id_orgaosuperior	INT NOT NULL,
			nmorgaosuperior		NVARCHAR(250) NOT NULL,
			PRIMARY KEY (id_orgaosuperior))

		CREATE TABLE [dbo].[DimOrgaoVinculado] (
			id_orgaovinculado	INT NOT NULL,
			nomeorgaovinculado	VARCHAR(250) NOT NULL,
			PRIMARY KEY (id_orgaovinculado))

		CREATE TABLE [dbo].[DimOrgaoUndGestora] (
			id_orgaoundgestora	INT NOT NULL,
			nomeundgestora		NVARCHAR(250) NOT NULL,
			PRIMARY KEY (id_orgaoundgestora))


		CREATE TABLE [dbo].[FatoDespesas] (
			anoMes				INT NOT NULL,
			id_favorecido		INT NOT NULL,
			id_tipofavorecido	INT NOT NULL,
			uf					CHAR(2) NOT NULL,
			id_municipio		INT NOT NULL,
			id_orgaosuperior	INT NOT NULL,
			id_orgaovinculado	INT NOT NULL,
			id_orgaoundgestora	INT NOT NULL,
			valorrecebido		FLOAT NOT NULL,
			linkdetalhe			NVARCHAR(250) NOT NULL,
	
			FOREIGN KEY (id_favorecido)		REFERENCES [dbo].[DimFavorecido]		(id_favorecido),
			FOREIGN KEY (id_tipofavorecido)	REFERENCES [dbo].[DimTipoFavorecido]	(id_tipofavorecido),
			FOREIGN KEY (id_municipio)		REFERENCES [dbo].[DimMunicipio]			(id_municipio),
			FOREIGN KEY (id_orgaosuperior)	REFERENCES [dbo].[DimOrgaoSuperior]		(id_orgaosuperior),
			FOREIGN KEY (id_orgaovinculado)	REFERENCES [dbo].[DimOrgaoVinculado]	(id_orgaovinculado),
			FOREIGN KEY (id_orgaoundgestora)REFERENCES [dbo].[DimOrgaoUndGestora]	(id_orgaoundgestora)
			)


		CREATE TABLE [dbo].[stage] (
			mesAno				varchar(7),
			cpfcnpjfavorecido	nvarchar(14),
			nomefavorecido		nvarchar(250),
			tipoFavorecido		varchar(50),
			ufFavorecido		varchar(2),
			municipioFavorecido varchar(250),
			orgaoSupCod			int,
			orgaoSupDesc		nvarchar(250),
			orgaoVinculadoCod	int,
			orgaoVinculadoDesc	nvarchar(250),
			unidadeGestoraCod	int,
			unidadeGestoraDesc	nvarchar(250),
			valorRecebido		real,
			linkDetalhamento	varchar(164)
		)	
		
		CREATE TABLE [dbo].[log_error] (
			[Flat File Source Error Output Column] varchar(max),
			[ErrorCode] int,
			[ErrorColumn] int
		)
		
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
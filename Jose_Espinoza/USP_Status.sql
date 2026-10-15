CREATE TABLE [SQM_CATALOGS].[TBL_Status]
(
	statusId INT PRIMARY KEY IDENTITY (1,1),
	statusName VARCHAR(80) NOT NULL,
	statusCreationDate DATETIME NOT NULL,
	statusCreatorId INT NOT NULL,
	statusModificationDate DATETIME NOT NULL,
	statusModificatorId INT NULL,
	statusEnable BIT NOT NULL
);

-- Insertar--


CREATE PROCEDURE SQM_CATALOGS.sp_InsertStatus
    @statusName VARCHAR(80),
    @statusCreatorId INT,
    @statusEnable BIT
AS
BEGIN
    INSERT INTO SQM_CATALOGS.TBL_Status
    (
        statusName,
        statusCreationDate,
        statusCreatorId,
        statusModificationDate,
        statusModificatorId,
        statusEnable
    )
    VALUES
    (
        @statusName,
        GETDATE(),
        @statusCreatorId,
        GETDATE(),
        NULL,
        @statusEnable
    );
END;

 -- Actualizar--


CREATE PROCEDURE SQM_CATALOGS.sp_UpdateStatus
    @statusId INT,
    @statusName VARCHAR(80),
    @statusModificatorId INT,
    @statusEnable BIT
AS
BEGIN
    UPDATE SQM_CATALOGS.TBL_Status
    SET
        statusName = @statusName,
        statusModificationDate = GETDATE(),
        statusModificatorId = @statusModificatorId,
        statusEnable = @statusEnable
    WHERE statusId = @statusId;
END;

 -- Eliminar--


CREATE PROCEDURE SQM_CATALOGS.sp_DisableStatus
    @statusId INT,
    @statusModificatorId INT
AS
BEGIN
    UPDATE SQM_CATALOGS.TBL_Status
    SET
        statusEnable = 0,
        statusModificationDate = GETDATE(),
        statusModificatorId = @statusModificatorId
    WHERE statusId = @statusId;
END;


 --Consultar--

CREATE PROCEDURE SQM_CATALOGS.sp_GetStatus
    @statusId INT = NULL
AS
BEGIN
    IF @statusId IS NULL
        SELECT * FROM SQM_CATALOGS.TBL_Status;
    ELSE
        SELECT * FROM SQM_CATALOGS.TBL_Status WHERE statusId = @statusId;
END;
CREATE TABLE [SQM_CATALOGS].[TBL_Priorities]
(
	priorityId INT PRIMARY KEY IDENTITY (1,1),
	priorityName VARCHAR(80) NOT NULL,
	priorityCreationDate DATETIME NOT NULL,
	priorityCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	priorityModificationDate DATETIME NULL,
	priorityModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	priorityEnable BIT NOT NULL
);


--Insertar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_InsertPriority]
    @priorityName VARCHAR(80),
    @priorityCreatorId INT
AS
BEGIN
    
    INSERT INTO [SQM_CATALOGS].[TBL_Priorities]
    (
        priorityName,
        priorityCreationDate,
        priorityCreatorId,
        priorityModificationDate,
        priorityModificatorId,
        priorityEnable
    )
    VALUES
    (
        @priorityName,
        GETDATE(),
        @priorityCreatorId,
        NULL,
        NULL,
        1
    );
END;


--Actualizar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_UpdatePriority]
    @priorityId INT,
    @priorityName VARCHAR(80),
    @priorityModificatorId INT
AS
BEGIN
   

    UPDATE [SQM_CATALOGS].[TBL_Priorities]
    SET
        priorityName = @priorityName,
        priorityModificationDate = GETDATE(),
        priorityModificatorId = @priorityModificatorId
    WHERE priorityId = @priorityId;
END;


--Deshabilitar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_DisablePriority]
    @priorityId INT,
    @priorityModificatorId INT
AS
BEGIN
   

    UPDATE [SQM_CATALOGS].[TBL_Priorities]
    SET
        priorityEnable = 0,
        priorityModificationDate = GETDATE(),
        priorityModificatorId = @priorityModificatorId
    WHERE priorityId = @priorityId;
END;


--Eliminar--


CREATE PROCEDURE [SQM_CATALOGS].[sp_DeletePriority]
    @priorityId INT
AS
BEGIN
   

    DELETE FROM [SQM_CATALOGS].[TBL_Priorities]
    WHERE priorityId = @priorityId;
END;


--Consultar--


CREATE PROCEDURE [SQM_CATALOGS].[sp_GetPriorities]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.priorityId,
        p.priorityName,
        p.priorityCreationDate,
        p.priorityEnable,
        u.userFullName AS CreatorName,
        m.userFullName AS ModificatorName
    FROM [SQM_CATALOGS].[TBL_Priorities] p
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON p.priorityCreatorId = u.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON p.priorityModificatorId = m.userId;
END;



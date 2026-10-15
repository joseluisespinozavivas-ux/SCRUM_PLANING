CREATE TABLE [SQM_SECURITY].[TBL_Roles]
(
	rolId INT PRIMARY KEY IDENTITY (1,1),
	rolName VARCHAR(80) NOT NULL,
	rolCreationDate DATETIME NOT NULL,
	rolCreatorId INT NOT NULL,
	rolModificationDate DATETIME NOT NULL,
	rolModificatorId INT NULL,
	rolEnable BIT NOT NULL
);

-- Insertar--

CREATE PROCEDURE [SQM_SECURITY].[sp_InsertRole]
    @rolName VARCHAR(80),
    @rolCreatorId INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_SECURITY].[TBL_Roles]
    (
        rolName,
        rolCreationDate,
        rolCreatorId,
        rolModificationDate,
        rolModificatorId,
        rolEnable
    )
    VALUES
    (
        @rolName,
        GETDATE(),
        @rolCreatorId,
        GETDATE(),
        NULL,
        1
    );
END;



---Actualizar--

CREATE PROCEDURE [SQM_SECURITY].[sp_UpdateRole]
    @rolId INT,
    @rolName VARCHAR(80),
    @rolModificatorId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_SECURITY].[TBL_Roles]
    SET
        rolName = @rolName,
        rolModificationDate = GETDATE(),
        rolModificatorId = @rolModificatorId
    WHERE rolId = @rolId;
END;

 --Deshabilitar-----

CREATE PROCEDURE [SQM_SECURITY].[sp_DisableRole]
    @rolId INT,
    @rolModificatorId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_SECURITY].[TBL_Roles]
    SET
        rolEnable = 0,
        rolModificationDate = GETDATE(),
        rolModificatorId = @rolModificatorId
    WHERE rolId = @rolId;
END;

 --Eliminar rol---------


CREATE PROCEDURE [SQM_SECURITY].[sp_DeleteRole]
    @rolId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM [SQM_SECURITY].[TBL_Roles]
    WHERE rolId = @rolId;
END;

 --Consultar roles---

CREATE PROCEDURE [SQM_SECURITY].[sp_GetRoles]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        rolId,
        rolName,
        rolCreationDate,
        rolEnable
    FROM [SQM_SECURITY].[TBL_Roles];
END;
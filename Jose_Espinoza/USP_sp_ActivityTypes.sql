CREATE TABLE [SQM_CATALOGS].[TBL_ActivityTypes]
(
	activityTypeId INT PRIMARY KEY IDENTITY (1,1),
	activityTypeName VARCHAR(80) NOT NULL,
	activityTypeCreationDate DATETIME NOT NULL,
	activityTypeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	activityTypeModificationDate DATETIME NULL,
	activityTypeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	activityTypeEnable BIT NOT NULL
);

--Insertar--


CREATE PROCEDURE [SQM_CATALOGS].[sp_InsertActivityType]
    @activityTypeName VARCHAR(80),
    @activityTypeCreatorId INT,
    @activityTypeEnable BIT
AS
BEGIN
    INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes]
    (
        activityTypeName,
        activityTypeCreationDate,
        activityTypeCreatorId,
        activityTypeModificationDate,
        activityTypeModificatorId,
        activityTypeEnable
    )
    VALUES
    (
        @activityTypeName,
        GETDATE(),
        @activityTypeCreatorId,
        NULL,
        NULL,
        @activityTypeEnable
    );
END;


--Actualizar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_UpdateActivityType]
    @activityTypeId INT,
    @activityTypeName VARCHAR(80),
    @activityTypeModificatorId INT,
    @activityTypeEnable BIT
AS
BEGIN
    UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
    SET
        activityTypeName = @activityTypeName,
        activityTypeModificationDate = GETDATE(),
        activityTypeModificatorId = @activityTypeModificatorId,
        activityTypeEnable = @activityTypeEnable
    WHERE activityTypeId = @activityTypeId;
END;


--Eliminar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_DeleteActivityType]
    @activityTypeId INT
AS
BEGIN
    DELETE FROM [SQM_CATALOGS].[TBL_ActivityTypes]
    WHERE activityTypeId = @activityTypeId;
END;

--Consultar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_GetActivityTypes]
AS
BEGIN
    SELECT 
        a.activityTypeId,
        a.activityTypeName,
        a.activityTypeCreationDate,
        c.userFullName AS CreatorName,
        a.activityTypeModificationDate,
        m.userFullName AS ModificatorName,
        a.activityTypeEnable
    FROM [SQM_CATALOGS].[TBL_ActivityTypes] a
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON a.activityTypeCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON a.activityTypeModificatorId = m.userId;
END;
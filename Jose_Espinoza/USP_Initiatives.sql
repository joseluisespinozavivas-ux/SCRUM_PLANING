CREATE TABLE [SQM_GENERAL].[TBL_Initiatives]
(
	initiativeId INT PRIMARY KEY IDENTITY (1,1),
	initiativeSummary VARCHAR(200) NOT NULL,
	initiativeDescription VARCHAR(2000) NOT NULL,
	initiativeOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeGoals VARCHAR(255) NULL,
	initiativeBusinessValue INT REFERENCES [SQM_CATALOGS].[TBL_BusinessValues](BusinessValueId) NOT NULL,
	initiativeTargetStart DATE NULL,
	initiativeTargetEnd DATE NULL,
	initiativeCreationDate DATETIME NOT NULL,
	initiativeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeModificationDate DATETIME NULL,
	initiativeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	initiativeStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);


--Insertar--

CREATE PROCEDURE [SQM_GENERAL].[sp_InsertInitiative]
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255),
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE,
    @initiativeTargetEnd DATE,
    @initiativeCreatorId INT,
    @initiativeStatus INT
AS
BEGIN
    
    INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
    (
        initiativeSummary,
        initiativeDescription,
        initiativeOwner,
        initiativeGoals,
        initiativeBusinessValue,
        initiativeTargetStart,
        initiativeTargetEnd,
        initiativeCreationDate,
        initiativeCreatorId,
        initiativeModificationDate,
        initiativeModificatorId,
        initiativeStatus
    )
    VALUES
    (
        @initiativeSummary,
        @initiativeDescription,
        @initiativeOwner,
        @initiativeGoals,
        @initiativeBusinessValue,
        @initiativeTargetStart,
        @initiativeTargetEnd,
        GETDATE(),
        @initiativeCreatorId,
        NULL,
        NULL,
        @initiativeStatus
    );
END;


--Actualizar--


CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateInitiative]
    @initiativeId INT,
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255),
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE,
    @initiativeTargetEnd DATE,
    @initiativeModificatorId INT,
    @initiativeStatus INT
AS
BEGIN
   

    UPDATE [SQM_GENERAL].[TBL_Initiatives]
    SET
        initiativeSummary = @initiativeSummary,
        initiativeDescription = @initiativeDescription,
        initiativeOwner = @initiativeOwner,
        initiativeGoals = @initiativeGoals,
        initiativeBusinessValue = @initiativeBusinessValue,
        initiativeTargetStart = @initiativeTargetStart,
        initiativeTargetEnd = @initiativeTargetEnd,
        initiativeModificationDate = GETDATE(),
        initiativeModificatorId = @initiativeModificatorId,
        initiativeStatus = @initiativeStatus
    WHERE initiativeId = @initiativeId;
END;


--Eliminar--


CREATE PROCEDURE [SQM_GENERAL].[sp_DeleteInitiative]
    @initiativeId INT
AS
BEGIN
  

    DELETE FROM [SQM_GENERAL].[TBL_Initiatives]
    WHERE initiativeId = @initiativeId;
END;


--Consultar--


CREATE PROCEDURE [SQM_GENERAL].[sp_GetInitiatives]
AS
BEGIN
  

    SELECT 
        i.initiativeId,
        i.initiativeSummary,
        i.initiativeDescription,
        u.userFullName AS OwnerName,
        i.initiativeGoals,
        bv.businessValueName,
        i.initiativeTargetStart,
        i.initiativeTargetEnd,
        i.initiativeCreationDate,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        s.statusName
    FROM [SQM_GENERAL].[TBL_Initiatives] i
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON i.initiativeOwner = u.userId
    INNER JOIN [SQM_CATALOGS].[TBL_BusinessValues] bv ON i.initiativeBusinessValue = bv.businessValueId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON i.initiativeCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON i.initiativeModificatorId = m.userId
    INNER JOIN [SQM_CATALOGS].[TBL_Status] s ON i.initiativeStatus = s.statusId;
END;

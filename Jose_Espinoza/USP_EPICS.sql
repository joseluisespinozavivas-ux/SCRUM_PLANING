CREATE TABLE [SQM_GENERAL].[TBL_Epics]
(
	epicId INT PRIMARY KEY IDENTITY (1,1),
	epicName VARCHAR(100) NOT NULL,
	epicSummary VARCHAR(500) NOT NULL,
	epicDescription VARCHAR(4000) NOT NULL,
	epicParentLink INT REFERENCES [SQM_GENERAL].[TBL_Initiatives](initiativeId) NOT NULL,
	epicOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicStartDate DATE NULL,
	epicDueDate DATE NULL,
	epicPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	epicCreationDate DATETIME NOT NULL,
	epicCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicModificationDate DATETIME NULL,
	epicModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	epicStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);


--Insertar--

CREATE PROCEDURE [SQM_GENERAL].[sp_InsertEpic]
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE,
    @epicDueDate DATE,
    @epicPriority INT,
    @epicCreatorId INT,
    @epicStatus INT
AS
BEGIN
  

    INSERT INTO [SQM_GENERAL].[TBL_Epics]
    (
        epicName,
        epicSummary,
        epicDescription,
        epicParentLink,
        epicOwner,
        epicStartDate,
        epicDueDate,
        epicPriority,
        epicCreationDate,
        epicCreatorId,
        epicModificationDate,
        epicModificatorId,
        epicStatus
    )
    VALUES
    (
        @epicName,
        @epicSummary,
        @epicDescription,
        @epicParentLink,
        @epicOwner,
        @epicStartDate,
        @epicDueDate,
        @epicPriority,
        GETDATE(),
        @epicCreatorId,
        NULL,
        NULL,
        @epicStatus
    );
END;


--Actualizar--


CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateEpic]
    @epicId INT,
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE,
    @epicDueDate DATE,
    @epicPriority INT,
    @epicModificatorId INT,
    @epicStatus INT
AS
BEGIN
   

    UPDATE [SQM_GENERAL].[TBL_Epics]
    SET
        epicName = @epicName,
        epicSummary = @epicSummary,
        epicDescription = @epicDescription,
        epicParentLink = @epicParentLink,
        epicOwner = @epicOwner,
        epicStartDate = @epicStartDate,
        epicDueDate = @epicDueDate,
        epicPriority = @epicPriority,
        epicModificationDate = GETDATE(),
        epicModificatorId = @epicModificatorId,
        epicStatus = @epicStatus
    WHERE epicId = @epicId;
END;



--Eliminar--



CREATE PROCEDURE [SQM_GENERAL].[sp_DeleteEpic]
    @epicId INT
AS
BEGIN
   

    DELETE FROM [SQM_GENERAL].[TBL_Epics]
    WHERE epicId = @epicId;
END;



--Consultar--


CREATE PROCEDURE [SQM_GENERAL].[sp_GetEpics]
AS
BEGIN
    

    SELECT 
        e.epicId,
        e.epicName,
        e.epicSummary,
        e.epicDescription,
        i.initiativeSummary AS ParentInitiative,
        u.userFullName AS OwnerName,
        e.epicStartDate,
        e.epicDueDate,
        p.priorityName,
        e.epicCreationDate,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        s.statusName
    FROM [SQM_GENERAL].[TBL_Epics] e
    INNER JOIN [SQM_GENERAL].[TBL_Initiatives] i ON e.epicParentLink = i.initiativeId
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON e.epicOwner = u.userId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON e.epicCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON e.epicModificatorId = m.userId
    LEFT JOIN [SQM_CATALOGS].[TBL_Priorities] p ON e.epicPriority = p.priorityId
    INNER JOIN [SQM_CATALOGS].[TBL_Status] s ON e.epicStatus = s.statusId;
END;



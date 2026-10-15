CREATE TABLE [SQM_GENERAL].[TBL_Features]
(
	featureId INT PRIMARY KEY IDENTITY (1,1),
	featureSummary VARCHAR(500) NOT NULL,
	featureDescription VARCHAR(2000) NOT NULL,
	featuresAcceptanceCriteria VARCHAR(4000) NOT NULL,
	featureParentLink INT REFERENCES [SQM_GENERAL].[TBL_Epics](epicId) NOT NULL,
	featureOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureStartDate DATE NULL,
	featureDueDate DATE NULL,
	featurePriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	featureCreationDate DATETIME NOT NULL,
	featureCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureModificationDate DATETIME NULL,
	featureModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	featureStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

--Insertar--


CREATE PROCEDURE [SQM_GENERAL].[sp_InsertFeature]
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE,
    @featureDueDate DATE,
    @featurePriority INT,
    @featureCreatorId INT,
    @featureStatus INT
AS
BEGIN
    

    INSERT INTO [SQM_GENERAL].[TBL_Features]
    (
        featureSummary,
        featureDescription,
        featuresAcceptanceCriteria,
        featureParentLink,
        featureOwner,
        featureStartDate,
        featureDueDate,
        featurePriority,
        featureCreationDate,
        featureCreatorId,
        featureModificationDate,
        featureModificatorId,
        featureStatus
    )
    VALUES
    (
        @featureSummary,
        @featureDescription,
        @featuresAcceptanceCriteria,
        @featureParentLink,
        @featureOwner,
        @featureStartDate,
        @featureDueDate,
        @featurePriority,
        GETDATE(),
        @featureCreatorId,
        NULL,
        NULL,
        @featureStatus
    );
END;


--Actualizar--


CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateFeature]
    @featureId INT,
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE,
    @featureDueDate DATE,
    @featurePriority INT,
    @featureModificatorId INT,
    @featureStatus INT
AS
BEGIN
    

    UPDATE [SQM_GENERAL].[TBL_Features]
    SET
        featureSummary = @featureSummary,
        featureDescription = @featureDescription,
        featuresAcceptanceCriteria = @featuresAcceptanceCriteria,
        featureParentLink = @featureParentLink,
        featureOwner = @featureOwner,
        featureStartDate = @featureStartDate,
        featureDueDate = @featureDueDate,
        featurePriority = @featurePriority,
        featureModificationDate = GETDATE(),
        featureModificatorId = @featureModificatorId,
        featureStatus = @featureStatus
    WHERE featureId = @featureId;
END;


CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateFeature]
    @featureId INT,
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE,
    @featureDueDate DATE,
    @featurePriority INT,
    @featureModificatorId INT,
    @featureStatus INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_Features]
    SET
        featureSummary = @featureSummary,
        featureDescription = @featureDescription,
        featuresAcceptanceCriteria = @featuresAcceptanceCriteria,
        featureParentLink = @featureParentLink,
        featureOwner = @featureOwner,
        featureStartDate = @featureStartDate,
        featureDueDate = @featureDueDate,
        featurePriority = @featurePriority,
        featureModificationDate = GETDATE(),
        featureModificatorId = @featureModificatorId,
        featureStatus = @featureStatus
    WHERE featureId = @featureId;
END;


--Eliminar--


CREATE PROCEDURE [SQM_GENERAL].[sp_DeleteFeature]
    @featureId INT
AS
BEGIN
   

    DELETE FROM [SQM_GENERAL].[TBL_Features]
    WHERE featureId = @featureId;
END;


--Consultar--


CREATE PROCEDURE [SQM_GENERAL].[sp_GetFeatures]
AS
BEGIN
    

    SELECT 
        f.featureId,
        f.featureSummary,
        f.featureDescription,
        f.featuresAcceptanceCriteria,
        e.epicName AS ParentEpic,
        u.userFullName AS OwnerName,
        f.featureStartDate,
        f.featureDueDate,
        p.priorityName,
        f.featureCreationDate,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        s.statusName
    FROM [SQM_GENERAL].[TBL_Features] f
    INNER JOIN [SQM_GENERAL].[TBL_Epics] e ON f.featureParentLink = e.epicId
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON f.featureOwner = u.userId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON f.featureCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON f.featureModificatorId = m.userId
    LEFT JOIN [SQM_CATALOGS].[TBL_Priorities] p ON f.featurePriority = p.priorityId
    INNER JOIN [SQM_CATALOGS].[TBL_Status] s ON f.featureStatus = s.statusId;
END;

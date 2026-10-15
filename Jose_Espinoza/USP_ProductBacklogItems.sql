CREATE TABLE [SQM_GENERAL].[TBL_ProductBacklogItems]
(
	PBIId INT PRIMARY KEY IDENTITY (1,1),
	PBISummary VARCHAR(500) NOT NULL,
	PBIDescription VARCHAR(2000) NOT NULL,
	PBIsAcceptanceCriteria VARCHAR(4000) NOT NULL,
	PBIOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIParentLink INT REFERENCES [SQM_GENERAL].[TBL_Features](featureId) NOT NULL,
	PBIStoryPoint INT,
	PBIStartDate DATE NULL,
	PBIDueDate DATE NULL,
	PBIPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	PBICreationDate DATETIME NOT NULL,
	PBICreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIModificationDate DATETIME NULL,
	PBIModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	PBIStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);


--Insertar--


CREATE PROCEDURE [SQM_GENERAL].[sp_InsertPBI]
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT,
    @PBIStartDate DATE,
    @PBIDueDate DATE,
    @PBIPriority INT,
    @PBICreatorId INT,
    @PBIStatus INT
AS
BEGIN
    INSERT INTO [SQM_GENERAL].[TBL_ProductBacklogItems]
    (
        PBISummary,
        PBIDescription,
        PBIsAcceptanceCriteria,
        PBIOwner,
        PBIParentLink,
        PBIStoryPoint,
        PBIStartDate,
        PBIDueDate,
        PBIPriority,
        PBICreationDate,
        PBICreatorId,
        PBIModificationDate,
        PBIModificatorId,
        PBIStatus
    )
    VALUES
    (
        @PBISummary,
        @PBIDescription,
        @PBIsAcceptanceCriteria,
        @PBIOwner,
        @PBIParentLink,
        @PBIStoryPoint,
        @PBIStartDate,
        @PBIDueDate,
        @PBIPriority,
        GETDATE(),
        @PBICreatorId,
        NULL,
        NULL,
        @PBIStatus
    );
END;

--Actualizar--

CREATE PROCEDURE [SQM_GENERAL].[sp_UpdatePBI]
    @PBIId INT,
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT,
    @PBIStartDate DATE,
    @PBIDueDate DATE,
    @PBIPriority INT,
    @PBIModificatorId INT,
    @PBIStatus INT
AS
BEGIN
    UPDATE [SQM_GENERAL].[TBL_ProductBacklogItems]
    SET
        PBISummary = @PBISummary,
        PBIDescription = @PBIDescription,
        PBIsAcceptanceCriteria = @PBIsAcceptanceCriteria,
        PBIOwner = @PBIOwner,
        PBIParentLink = @PBIParentLink,
        PBIStoryPoint = @PBIStoryPoint,
        PBIStartDate = @PBIStartDate,
        PBIDueDate = @PBIDueDate,
        PBIPriority = @PBIPriority,
        PBIModificationDate = GETDATE(),
        PBIModificatorId = @PBIModificatorId,
        PBIStatus = @PBIStatus
    WHERE PBIId = @PBIId;
END;


CREATE PROCEDURE [SQM_GENERAL].[sp_DeletePBI]
    @PBIId INT
AS
BEGIN
    DELETE FROM [SQM_GENERAL].[TBL_ProductBacklogItems]
    WHERE PBIId = @PBIId;
END;


--Consultar--

	CREATE PROCEDURE [SQM_GENERAL].[sp_GetPBIs]
AS
BEGIN
    SELECT 
        p.PBIId,
        p.PBISummary,
        p.PBIDescription,
        p.PBIsAcceptanceCriteria,
        f.featureSummary AS ParentFeature,
        u.userFullName AS OwnerName,
        p.PBIStoryPoint,
        p.PBIStartDate,
        p.PBIDueDate,
        pr.priorityName,
        p.PBICreationDate,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        s.statusName
    FROM [SQM_GENERAL].[TBL_ProductBacklogItems] p
    INNER JOIN [SQM_GENERAL].[TBL_Features] f ON p.PBIParentLink = f.featureId
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON p.PBIOwner = u.userId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON p.PBICreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON p.PBIModificatorId = m.userId
    LEFT JOIN [SQM_CATALOGS].[TBL_Priorities] pr ON p.PBIPriority = pr.priorityId
    INNER JOIN [SQM_CATALOGS].[TBL_Status] s ON p.PBIStatus = s.statusId;
END;

CREATE TABLE [SQM_GENERAL].[TBL_Tasks]
(
	taskId INT PRIMARY KEY IDENTITY (1,1),
	taskSummary VARCHAR(500) NOT NULL,
	taskDescription VARCHAR(2000) NOT NULL,
	taskOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskParentLink INT REFERENCES [SQM_GENERAL].[TBL_ProductBacklogItems](PBIId) NOT NULL,
	taskOriginalEstimate DECIMAL(4,2) NULL, --5
	taskCompletedWork DECIMAL(4,2) NULL, --6
	taskRemaningWork DECIMAL(4,2) NULL,
	taskStartDate DATE NULL,
	taskCompletedDate DATE NULL,
	taskDueDate DATE NULL,
	taskActivityType INT REFERENCES [SQM_CATALOGS].[TBL_ActivityTypes] (activityTypeId),
	taskCreationDate DATETIME NOT NULL,
	taskCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskModificationDate DATETIME NULL,
	taskModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);


--Insertar--

CREATE PROCEDURE [SQM_GENERAL].[sp_InsertTask]
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2),
    @taskCompletedWork DECIMAL(4,2),
    @taskRemaningWork DECIMAL(4,2),
    @taskStartDate DATE,
    @taskCompletedDate DATE,
    @taskDueDate DATE,
    @taskActivityType INT,
    @taskCreatorId INT,
    @taskStatus INT
AS
BEGIN
    INSERT INTO [SQM_GENERAL].[TBL_Tasks]
    (
        taskSummary,
        taskDescription,
        taskOwner,
        taskParentLink,
        taskOriginalEstimate,
        taskCompletedWork,
        taskRemaningWork,
        taskStartDate,
        taskCompletedDate,
        taskDueDate,
        taskActivityType,
        taskCreationDate,
        taskCreatorId,
        taskModificationDate,
        taskModificatorId,
        taskStatus
    )
    VALUES
    (
        @taskSummary,
        @taskDescription,
        @taskOwner,
        @taskParentLink,
        @taskOriginalEstimate,
        @taskCompletedWork,
        @taskRemaningWork,
        @taskStartDate,
        @taskCompletedDate,
        @taskDueDate,
        @taskActivityType,
        GETDATE(),
        @taskCreatorId,
        NULL,
        NULL,
        @taskStatus
    );
END;

--Actualizar--

CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateTask]
    @taskId INT,
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2),
    @taskCompletedWork DECIMAL(4,2),
    @taskRemaningWork DECIMAL(4,2),
    @taskStartDate DATE,
    @taskCompletedDate DATE,
    @taskDueDate DATE,
    @taskActivityType INT,
    @taskModificatorId INT,
    @taskStatus INT
AS
BEGIN
    UPDATE [SQM_GENERAL].[TBL_Tasks]
    SET
        taskSummary = @taskSummary,
        taskDescription = @taskDescription,
        taskOwner = @taskOwner,
        taskParentLink = @taskParentLink,
        taskOriginalEstimate = @taskOriginalEstimate,
        taskCompletedWork = @taskCompletedWork,
        taskRemaningWork = @taskRemaningWork,
        taskStartDate = @taskStartDate,
        taskCompletedDate = @taskCompletedDate,
        taskDueDate = @taskDueDate,
        taskActivityType = @taskActivityType,
        taskModificationDate = GETDATE(),
        taskModificatorId = @taskModificatorId,
        taskStatus = @taskStatus
    WHERE taskId = @taskId;
END;


--Eliminar--


CREATE PROCEDURE [SQM_GENERAL].[sp_DeleteTask]
    @taskId INT
AS
BEGIN
    DELETE FROM [SQM_GENERAL].[TBL_Tasks]
    WHERE taskId = @taskId;
END;

--Consultar--

CREATE PROCEDURE [SQM_GENERAL].[sp_GetTasks]
AS
BEGIN
    SELECT 
        t.taskId,
        t.taskSummary,
        t.taskDescription,
        u.userFullName AS OwnerName,
        p.PBISummary AS ParentPBI,
        t.taskOriginalEstimate,
        t.taskCompletedWork,
        t.taskRemaningWork,
        t.taskStartDate,
        t.taskCompletedDate,
        t.taskDueDate,
        a.activityTypeName AS ActivityType,
        t.taskCreationDate,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        s.statusName
    FROM [SQM_GENERAL].[TBL_Tasks] t
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON t.taskOwner = u.userId
    INNER JOIN [SQM_GENERAL].[TBL_ProductBacklogItems] p ON t.taskParentLink = p.PBIId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON t.taskCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON t.taskModificatorId = m.userId
    LEFT JOIN [SQM_CATALOGS].[TBL_ActivityTypes] a ON t.taskActivityType = a.activityTypeId
    INNER JOIN [SQM_CATALOGS].[TBL_Status] s ON t.taskStatus = s.statusId;
END;


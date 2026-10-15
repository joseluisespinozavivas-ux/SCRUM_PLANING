CREATE TABLE [SQM_GENERAL].[TBL_TaskComments]
(
	taskCommentId INT PRIMARY KEY IDENTITY (1,1),
	taskCommentParentLink INT REFERENCES [SQM_GENERAL].[TBL_Tasks](TaskId) NOT NULL,
	taskCommentOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentText NVARCHAR(4000) NOT NULL,
	taskCommentCreationDate DATETIME NOT NULL,
	taskCommentCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentModificationDate DATETIME NULL,
	taskCommentModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskCommentStatus BIT NOT NULL
);


--Insertar--

CREATE PROCEDURE [SQM_GENERAL].[sp_InsertTaskComment]
    @taskCommentParentLink INT,
    @taskCommentOwner INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentCreatorId INT,
    @taskCommentStatus BIT
AS
BEGIN
    INSERT INTO [SQM_GENERAL].[TBL_TaskComments]
    (
        taskCommentParentLink,
        taskCommentOwner,
        taskCommentText,
        taskCommentCreationDate,
        taskCommentCreatorId,
        taskCommentModificationDate,
        taskCommentModificatorId,
        taskCommentStatus
    )
    VALUES
    (
        @taskCommentParentLink,
        @taskCommentOwner,
        @taskCommentText,
        GETDATE(),
        @taskCommentCreatorId,
        NULL,
        NULL,
        @taskCommentStatus
    );
END;
	

--Actualizar--

CREATE PROCEDURE [SQM_GENERAL].[sp_UpdateTaskComment]
    @taskCommentId INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentModificatorId INT,
    @taskCommentStatus BIT
AS
BEGIN
    UPDATE [SQM_GENERAL].[TBL_TaskComments]
    SET
        taskCommentText = @taskCommentText,
        taskCommentModificationDate = GETDATE(),
        taskCommentModificatorId = @taskCommentModificatorId,
        taskCommentStatus = @taskCommentStatus
    WHERE taskCommentId = @taskCommentId;
END;

--Eliminar--

CREATE PROCEDURE [SQM_GENERAL].[sp_DeleteTaskComment]
    @taskCommentId INT
AS
BEGIN
    DELETE FROM [SQM_GENERAL].[TBL_TaskComments]
    WHERE taskCommentId = @taskCommentId;
END;


--Consultar--

CREATE PROCEDURE [SQM_GENERAL].[sp_GetTaskComments]
AS
BEGIN
    SELECT 
        tc.taskCommentId,
        tc.taskCommentText,
        tc.taskCommentCreationDate,
        u.userFullName AS OwnerName,
        c.userFullName AS CreatorName,
        m.userFullName AS ModificatorName,
        t.taskSummary AS ParentTask,
        tc.taskCommentStatus
    FROM [SQM_GENERAL].[TBL_TaskComments] tc
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON tc.taskCommentOwner = u.userId
    INNER JOIN [SQM_SECURITY].[TBL_Users] c ON tc.taskCommentCreatorId = c.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON tc.taskCommentModificatorId = m.userId
    INNER JOIN [SQM_GENERAL].[TBL_Tasks] t ON tc.taskCommentParentLink = t.taskId;
END;

CREATE TABLE [SQM_CATALOGS].[TBL_BusinessValues]
(
	businessValueId INT PRIMARY KEY IDENTITY (1,1),
	businessValueName VARCHAR(80) NOT NULL,
	businessValueCreationDate DATETIME NOT NULL,
	businessValueCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	businessValueModificationDate DATETIME NULL,
	businessValueModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	businessValueEnable BIT NOT NULL
);



---Insertar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_InsertBusinessValue]
    @businessValueName VARCHAR(80),
    @businessValueCreatorId INT
AS
BEGIN
   

    INSERT INTO [SQM_CATALOGS].[TBL_BusinessValues]
    (
        businessValueName,
        businessValueCreationDate,
        businessValueCreatorId,
        businessValueModificationDate,
        businessValueModificatorId,
        businessValueEnable
    )
    VALUES
    (
        @businessValueName,
        GETDATE(),
        @businessValueCreatorId,
        NULL,
        NULL,
        1
    );
END;

 ----Actualizar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_UpdateBusinessValue]
    @businessValueId INT,
    @businessValueName VARCHAR(80),
    @businessValueModificatorId INT
AS
BEGIN
   

    UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
    SET
        businessValueName = @businessValueName,
        businessValueModificationDate = GETDATE(),
        businessValueModificatorId = @businessValueModificatorId
    WHERE businessValueId = @businessValueId;
END;


--Deshabilitar--


CREATE PROCEDURE [SQM_CATALOGS].[sp_DisableBusinessValue]
    @businessValueId INT,
    @businessValueModificatorId INT
AS
BEGIN
  

    UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
    SET
        businessValueEnable = 0,
        businessValueModificationDate = GETDATE(),
        businessValueModificatorId = @businessValueModificatorId
    WHERE businessValueId = @businessValueId;
END;


--Eliminar--

CREATE PROCEDURE [SQM_CATALOGS].[sp_DeleteBusinessValue]
    @businessValueId INT
AS
BEGIN
   

    DELETE FROM [SQM_CATALOGS].[TBL_BusinessValues]
    WHERE businessValueId = @businessValueId;
END;


--Consultar--


CREATE PROCEDURE [SQM_CATALOGS].[sp_GetBusinessValues]
AS
BEGIN


    SELECT 
        bv.businessValueId,
        bv.businessValueName,
        bv.businessValueCreationDate,
        bv.businessValueEnable,
        u.userFullName AS CreatorName,
        m.userFullName AS ModificatorName
    FROM [SQM_CATALOGS].[TBL_BusinessValues] bv
    INNER JOIN [SQM_SECURITY].[TBL_Users] u ON bv.businessValueCreatorId = u.userId
    LEFT JOIN [SQM_SECURITY].[TBL_Users] m ON bv.businessValueModificatorId = m.userId;
END;





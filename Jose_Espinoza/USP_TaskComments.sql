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


CREATE OR ALTER PROC [SQM_GENERAL].[USP_TaskComments]
(
    @i_taskCommentId INT = NULL,
    @i_taskCommentParentLink INT = NULL,
    @i_taskCommentOwner INT = NULL,
    @i_taskCommentText NVARCHAR(4000) = NULL,
    @i_taskCommentCreationDate DATETIME = NULL,
    @i_taskCommentCreatorId INT = NULL,
    @i_taskCommentModificationDate DATETIME = NULL,
    @i_taskCommentModificatorId INT = NULL,
    @i_taskCommentStatus BIT = NULL,
    @i_PageNumber INT = NULL,
    @i_RowsPerPage INT = NULL,
    @w_Accion CHAR(1),
    @o_Numero INT = NULL OUT,
    @o_MensajeTecnico VARCHAR(500) = NULL OUT,
    @o_MensajeUsuario VARCHAR(500) = NULL OUT
)
AS
BEGIN
    DECLARE @w_totalRows INT;

    IF @i_taskCommentCreationDate IS NULL
        SET @i_taskCommentCreationDate = GETDATE();

    IF @i_taskCommentModificationDate IS NULL
        SET @i_taskCommentModificationDate = GETDATE();

    -- INSERTAR TASK COMMENT --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_taskCommentParentLink,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ENLACE PADRE (TAREA) DEL COMENTARIO ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskCommentOwner,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DEL COMENTARIO ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskCommentText,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL TEXTO DEL COMENTARIO ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskCommentCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_TASKCOMMENT;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_TaskComments]
                (
                    taskCommentParentLink, taskCommentOwner, taskCommentText, 
                    taskCommentCreationDate, taskCommentCreatorId, taskCommentStatus
                )
                VALUES
                (
                    @i_taskCommentParentLink, @i_taskCommentOwner, @i_taskCommentText, 
                    @i_taskCommentCreationDate, @i_taskCommentCreatorId, COALESCE(@i_taskCommentStatus, 1)
                );

                COMMIT TRANSACTION TRX_INS_TASKCOMMENT;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'COMENTARIO DE TAREA REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_TASKCOMMENT;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR COMENTARIO DE TAREA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR COMENTARIO DE TAREA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE TASK COMMENT --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_taskCommentId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL COMENTARIO DE TAREA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskCommentModificatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_TaskComments] (NOLOCK) WHERE taskCommentId = @i_taskCommentId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL COMENTARIO DE TAREA NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_TASKCOMMENT;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_TaskComments]
                SET taskCommentParentLink = COALESCE(@i_taskCommentParentLink, taskCommentParentLink),
                    taskCommentOwner = COALESCE(@i_taskCommentOwner, taskCommentOwner),
                    taskCommentText = COALESCE(@i_taskCommentText, taskCommentText),
                    taskCommentModificationDate = @i_taskCommentModificationDate,
                    taskCommentModificatorId = @i_taskCommentModificatorId,
                    taskCommentStatus = COALESCE(@i_taskCommentStatus, taskCommentStatus)
                WHERE taskCommentId = @i_taskCommentId;

                COMMIT TRANSACTION TRX_UPD_TASKCOMMENT;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'COMENTARIO DE TAREA ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_TASKCOMMENT;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR COMENTARIO DE TAREA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR COMENTARIO DE TAREA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT TASK COMMENT --
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber,0) <= 0 OR ISNULL(@i_RowsPerPage,0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS PARAMETROS DE PAGINACION SON OBLIGATORIOS Y DEBEN SER MAYORES A CERO';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SELECT 
                    taskCommentId,
                    taskCommentParentLink,
                    taskCommentOwner,
                    taskCommentText,
                    taskCommentCreationDate,
                    taskCommentCreatorId,
                    taskCommentModificationDate,
                    taskCommentModificatorId,
                    taskCommentStatus
                FROM [SQM_GENERAL].[TBL_TaskComments] (NOLOCK)
                ORDER BY taskCommentId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'COMENTARIOS DE TAREA LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR COMENTARIOS DE TAREA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR COMENTARIOS DE TAREA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- ACCION INVALIDA --
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico = 'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END
END;
GO

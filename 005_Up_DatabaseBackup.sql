Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientsVisitOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_DatabaseBackup]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_DatabaseBackup]
Go 
CREATE procedure [dbo].[Up_DatabaseBackup] 
@p_OPERTION_TYPE varchar(5) =null,
@p_filepath varchar(200)  =null,
@p_backupName varchar(50)  =NULL,
@p_databaseName varchar(50)  =null,
@p_ModifiedBy int=null,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT

  
as
begin
	
    if @p_OPERTION_TYPE='BAK'
	BEGIN
    SET NOCOUNT ON
	
    BEGIN TRY
	  BACKUP DATABASE @p_databaseName  
            TO DISK = @p_filepath;  
	  begin transaction
      delete from DbBackupDetails
            INSERT INTO DbBackupDetails 
			(BackupName,Location,BackupDate,ModifiedBy,ModifiedOn)
			VALUES (@p_backupName,@p_filepath,current_timestamp,@p_ModifiedBy,current_timestamp)              
    
	    commit
        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
	    rollback
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,ERROR_STATE() AS ErrorState,  
        ERROR_PROCEDURE() AS ErrorProcedure,ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;  

    END CATCH

	

END
   if @p_OPERTION_TYPE='SEL'
	begin
	   select 'Last backup was taken on '+ Convert(varchar(100),BackupDate)+ ' in location : '+Location as BackupInfo from DbBackupDetails
	end
END


GO
Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientsVisitOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_AdminOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_AdminOperations]
Go 
CREATE procedure [dbo].[Up_AdminOperations]
@p_OPERTION_TYPE varchar(5) =null,
@p_clinicName varchar(64) =null,
@p_address varchar(64) =null,
@p_phoneNumber varchar(15) =null,
@p_email varchar(50) =null,
@p_website varchar(50) =null,
@p_fax varchar(15) =null,
@p_reportHeader varbinary(max) =null,
@p_ModifiedBy int=null,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin  

if @p_OPERTION_TYPE='SEL'
begin
 
  select * from [CinicDetails]

end
if @p_OPERTION_TYPE='INS'
begin
 BEGIN TRY
 
   Begin transaction
   delete from [CinicDetails] 
   insert into CinicDetails (
	ClinicName,
	ClinicAddress,
	PhoneNumber,
	ReportHeader,
	Email,
	Website,
	Fax,
	ModifiedBy,
	ModifiedOn
   )
   values( 
     @p_clinicName,
	 @p_address,
	 @p_phoneNumber,
	@p_reportHeader,
	@p_email,
	@p_website,
	@p_fax,
	@p_ModifiedBy,
	CURRENT_TIMESTAMP
	)
    commit  
    SET @responseMessage='Success'
	SET @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		SET @status='0'
		rollback 
    END CATCH
end
end
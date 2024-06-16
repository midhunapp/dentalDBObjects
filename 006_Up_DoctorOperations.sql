Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_DoctorOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_DoctorOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_DoctorOperations]
Go 
CREATE procedure [dbo].[Up_DoctorOperations]
@p_OPERTION_TYPE varchar(5) =null,
@p_OPERTION_SUB_TYPE  varchar(5) =null,
@p_chiefComplaintId int =null,
@p_chiefComplaintText varchar(200) =null,
@p_attachementsDescr varchar(200) =null,
@p_planOfCare varchar(200) =null,
@p_pastHistory varchar(200) =null,
@p_othersystemicIllness varchar(200) =null,
@p_ModifiedBy int=null,
@p_visitId int=null,
@p_caseSheetId int=null,
@p_diagnosisId int=null,
@p_type TeethTreatmentsTyp READONLY  ,
@p_sysType SystemicIllnessTyp READONLY,
@p_image varbinary(max) =null,
@p_imageName varchar(30) =null,
@p_fileId int=null,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin
	

    
	if @p_OPERTION_TYPE='CSINS' and @p_OPERTION_SUB_TYPE='CHIEF'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	BEGIN TRANSACTION 
	   if(isnull(@p_chiefComplaintId,-1)=-1)
		 begin
		  insert into SysIllnessAndChiefComplaints_Mf (Name,EntryType)
		  values(@p_chiefComplaintText,'CHIEFCOMP')
		  select  @p_chiefComplaintId=Id from SysIllnessAndChiefComplaints_Mf where Name=@p_chiefComplaintText
		 end
       if(@p_caseSheetId<=0)
	   begin
	     insert into [PatientCaseSheet]
					(
					  VisitId,
					  ChiefComplaintId,
					  PastHistory,
					  OtherSysIllness,
					  ModifiedBy,
					  ModifiedOn
					)
					values
					(
					  @p_visitId,
					  @p_chiefComplaintId,
					  @p_pastHistory,
					  @p_othersystemicIllness,
					  @p_ModifiedBy,
					  current_timestamp
					)
		 insert into [dbo].[PatientCaseSheetSystemicIllNess]
					(
						VisitId,
						SysId,
						ModifiedBy,
						ModifiedOn
					)
					select VisitId,SystemicIllnessId,@p_ModifiedBy,CURRENT_TIMESTAMP from @p_sysType		
	   end
	   else
	   begin
	    update [PatientCaseSheet]
			   set ChiefComplaintId=@p_chiefComplaintId,
			   PastHistory=@p_pastHistory,
			   OtherSysIllness=@p_othersystemicIllness,
			   ModifiedBy=@p_ModifiedBy,
			   ModifiedOn=current_timestamp
			   where Id=@p_caseSheetId
		delete from [PatientCaseSheetSystemicIllNess] where VisitId=@p_visitId
		insert into [dbo].[PatientCaseSheetSystemicIllNess]
					(
						VisitId,
						SysId,
						ModifiedBy,
						ModifiedOn
					)
					select VisitId,SystemicIllnessId,@p_ModifiedBy,CURRENT_TIMESTAMP from @p_sysType	
	   end
	 COMMIT   

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		ROLLBACK 
    END CATCH

END
	if @p_OPERTION_TYPE='CSSEL'  and @p_OPERTION_SUB_TYPE='CHIEF'
	begin

	  select 
	  CS.VisitId,
	  Mf.Name as ChiefComplaintText,
	  Mf.Id as ChiefComplaintId,
	  cs.OtherSysIllness,
	  cs.PastHistory,
	  cs.Id,
	  dmf.DiagnosisCode + ' ' +dmf.DiagnosisName as Diagnosis,
	  cs.DiagnosisId 
	   from PatientCaseSheet CS
	  inner join SysIllnessAndChiefComplaints_Mf MF on MF.Id=cs.ChiefComplaintId
	  left join Diagnosis_Mf dmf on dmf.Id=cs.DiagnosisId
	  where CS.VisitId=@p_visitId
	  
	end
	if @p_OPERTION_TYPE='TRSEL'
	begin

	select 
	TreatmentId,
	case when Teeth='FULL' and pt.IsPediatric='Y' then 'FULL Pediatric' when Teeth='FULL' and pt.IsPediatric='N' then 'FULL Adult' else Teeth end as Teeth,
	pt.Id as PlanId
	 from 
	PatientTreatments pt 
	where pt.VisitId=@p_visitId

	end
	if @p_OPERTION_TYPE='SYSEL'
	begin
	  select 
	    mf.Name,
		mf.Id,
		case when pt.Id IS null then 'F' else 'T' end as [Status]
	   from SysIllnessAndChiefComplaints_Mf mf left join PatientCaseSheetSystemicIllNess pt on (mf.Id=pt.SysId and pt.VisitId=@p_visitId)
	   where mf.EntryType='SYS'
	    order by mf.Name
	end

	if @p_OPERTION_TYPE='RDINS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	BEGIN TRANSACTION 

		 insert into [dbo].[PatientCaseSheetAttachments]
					(
						VisitId,
						Attachments,
						[Description],
						Name,
						ModifiedBy,
						ModifiedOn
					)
					values(
					@p_visitId,
					@p_image,
					@p_attachementsDescr,
					@p_imageName,
					@p_ModifiedBy,
					current_timestamp
					)		

	  
	     COMMIT   

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		ROLLBACK 
    END CATCH

END
    if @p_OPERTION_TYPE='RDSEL'
	begin
	  select 
	     Name,
		 [Description],
		 Attachments,
		 Id
	   from PatientCaseSheetAttachments where VisitId=@p_visitId
	end
	if @p_OPERTION_TYPE='RDDEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	    
        delete dbo.PatientCaseSheetAttachments where Id=@p_fileId
                       
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END
   
    if @p_OPERTION_SUB_TYPE='COMPL' and @p_OPERTION_TYPE='CHIEF'
	begin
	  select 
		mf.Id,
		 mf.Name as [Complaints]
	    from SysIllnessAndChiefComplaints_Mf mf
		where EntryType='CHIEFCOMP'
	end

	if @p_OPERTION_TYPE='SEL'  and @p_OPERTION_SUB_TYPE='PLAN'
	begin

	  select 
	  dmf.DiagnosisCode + ' ' +dmf.DiagnosisName as Diagnosis,
	  cs.DiagnosisId ,
	  cs.PlanOfCare
	   from PatientCaseSheet CS
	  left join Diagnosis_Mf dmf on dmf.Id=cs.DiagnosisId
	  where CS.VisitId=@p_visitId
	  
	  select 
	TreatmentId,
	case when Teeth='FULL' and pt.IsPediatric='Y' then 'FULL Pediatric' when Teeth='FULL' and pt.IsPediatric='N' then 'FULL Adult' else Teeth end as Teeth,
	pt.Id as PlanId
	 from 
	PatientTreatments pt 
	where pt.VisitId=@p_visitId
	end

	if @p_OPERTION_TYPE='INS' and @p_OPERTION_SUB_TYPE='PLAN'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	BEGIN TRANSACTION 
  
	    update [PatientCaseSheet]
			   set DiagnosisId=@p_diagnosisId,
			   PlanOfCare=@p_planOfCare,
			   ModifiedBy=@p_ModifiedBy,
			   ModifiedOn=current_timestamp
			   where VisitId=@p_visitId
		delete from PatientTreatments where VisitId=@p_visitId
		insert into [dbo].PatientTreatments
					(
						VisitId,
						Teeth,
						TreatmentId,
						IsPediatric,
						ModifiedBy,
						ModifiedOn
					)
					select @p_visitId,Teeth,TreatmentId,IsPediatric,@p_ModifiedBy,CURRENT_TIMESTAMP from @p_type	
	   
	 COMMIT   

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		ROLLBACK 
    END CATCH

END
END


GO
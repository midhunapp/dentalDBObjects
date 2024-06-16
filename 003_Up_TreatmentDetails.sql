Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientOperations]    Script Date: 04-07-2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_TreatmentDetails]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_TreatmentDetails]
Go 
CREATE procedure [dbo].[Up_TreatmentDetails]
@p_OPERTION_TYPE varchar(5) =null,
@p_Id int  =-1,
@p_TreatmentName varchar(64)  =null,
@p_TreatmentCode varchar(10)  =null,
@p_SysChiefType varchar(10)  =null,
@p_Amount numeric(11,2)  =NULL,
@p_Currency varchar(5)  =NULL,
@p_Remarks varchar(64)  =NULL,
@p_ModifiedBy int  =NULL,
@p_DiagnosisName varchar(64)  =null,
@p_DiagnosisCode varchar(10)  =null,
@p_DiagnosisDesc varchar(150)  =null,
@p_MedicineName varchar(100)  =null,
@p_MedicineAdditionalInfo varchar(100)  =null,
@p_LabWork char(1)  =null,
@responseMessage varchar(200) OUTPUT,
@status char(1) OUTPUT
as
begin
	
    if @p_OPERTION_TYPE='INS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if(select count(ID) from dbo.[Treatments_Mf]  where TreatmentName=@p_TreatmentName and TreatmentCode=@p_TreatmentCode)>0
	begin
	  set @status='0';
	  set @responseMessage=@p_TreatmentName+ ' ( ' + @p_TreatmentCode+ ') already exists.'
	  return 
	end

        INSERT INTO dbo.[Treatments_Mf] 
                        (
                            TreatmentName, 
                            TreatmentCode, 
                            Amount,
                            Currency,
                            ModifiedBy,
                            ModifiedOn,
                            IsActive,
							IsLabWorkIncluded
                            )
                     VALUES
                        (
                           @p_TreatmentName,
						   @p_TreatmentCode,
                           @p_Amount,
                           @p_Currency,
                           @p_ModifiedBy,
                           current_timestamp,
                           1,
						   @p_LabWork
                           )

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='SEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        SELECT Id,TreatmentName,TreatmentCode,Amount,ISNUll(IsLabWorkIncluded,'N') as [Lab Work Included] FROM dbo.[Treatments_Mf] --where TreatmentCode<>'XRAY' and TreatmentCode<>'CONSULT'

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='UPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	if(select count(ID) from dbo.[Treatments_Mf]  where TreatmentName=@p_TreatmentName and TreatmentCode=@p_TreatmentCode and Id<>@p_Id)>0
	begin
	  set @status='0';
	  set @responseMessage=@p_TreatmentName+ ' ( ' + @p_TreatmentCode+ ') already exists.'
	  return 
	end

        update dbo.[Treatments_Mf] set 
        TreatmentName=@p_TreatmentName,
		TreatmentCode=@p_TreatmentCode,
        Amount=@p_Amount,
        Currency=@p_Currency,
        ModifiedBy=@p_ModifiedBy,
        ModifiedOn=current_timestamp,
        IsActive=1,
		IsLabWorkIncluded=@p_LabWork
       where Id=@p_Id
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
   

END
     if  @p_OPERTION_TYPE='DEL'
    begin
	 BEGIN TRY
      delete from dbo.[Treatments_Mf] where Id=@p_Id
	  SET @status='1'
	   END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
    end


	if @p_OPERTION_TYPE='DSINS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if(select count(Id) from dbo.[Diagnosis_Mf]  where  DiagnosisCode=@p_DiagnosisCode)>0
	begin
	  set @status='0';
	  set @responseMessage=@p_DiagnosisName+ ' ( ' + @p_DiagnosisCode+ ') already exists.'
	  return 
	end

        INSERT INTO dbo.[Diagnosis_Mf] 
                        (
                            DiagnosisName, 
                            DiagnosisCode, 
							DiagnosisDes,
                            ModifiedBy,
                            ModifiedOn,
                            IsActive
                            )
                     VALUES
                        (
                           @p_DiagnosisName,
						   @p_DiagnosisCode,
                           @p_DiagnosisDesc,
                           @p_ModifiedBy,
                           current_timestamp,
                           1
                           )

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='DSSEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        SELECT Id,DiagnosisCode,DiagnosisName,DiagnosisDes FROM dbo.[Diagnosis_Mf] order by DiagnosisCode

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='DSUPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        update dbo.[Diagnosis_Mf] set 
        DiagnosisName=@p_DiagnosisName,
		DiagnosisCode=@p_DiagnosisCode,
        DiagnosisDes=@p_DiagnosisDesc,
        ModifiedBy=@p_ModifiedBy,
        ModifiedOn=current_timestamp,
        IsActive=1
       where Id=@p_Id
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
   

END
     if  @p_OPERTION_TYPE='DSDEL'
    begin
	 BEGIN TRY
      delete from dbo.[Diagnosis_Mf] where Id=@p_Id
	  SET @status='1'
	   END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
    end


	if @p_OPERTION_TYPE='MDINS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if(select count(ID) from dbo.Medicines_Mf  where MedicienName=@p_MedicineName )>0
	begin
	  set @status='0';
	  set @responseMessage=@p_MedicineName+ +' already exists.'
	  return 
	end

        INSERT INTO dbo.Medicines_Mf 
                        (
                            MedicienName, 
                            AdditionalInfo, 
                            ModifiedBy,
                            ModifiedOn,
                            IsActive
                            )
                     VALUES
                        (
                           @p_MedicineName,
						   @p_MedicineAdditionalInfo,
                           @p_ModifiedBy,
                           current_timestamp,
                           1
                           )

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='MDSEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        SELECT Id,MedicienName,AdditionalInfo FROM dbo.Medicines_Mf 

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='MDUPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        update dbo.Medicines_Mf set 
        MedicienName=@p_MedicineName,
		AdditionalInfo=@p_MedicineAdditionalInfo,
        ModifiedBy=@p_ModifiedBy,
        ModifiedOn=current_timestamp,
        IsActive=1
       where Id=@p_Id
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
   

END
     if  @p_OPERTION_TYPE='MDDEL'
    begin
	 BEGIN TRY
      delete from dbo.Medicines_Mf where Id=@p_Id
	  SET @status='1'
	   END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
    end


	if @p_OPERTION_TYPE='SYINS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if(select count(ID) from dbo.[SysIllnessAndChiefComplaints_Mf]  where Name=@p_TreatmentName )>0
	begin
	  set @status='0';
	  set @responseMessage=@p_TreatmentName+ +' already exists.'
	  return 
	end

        INSERT INTO dbo.[SysIllnessAndChiefComplaints_Mf] 
                        (
                            Name, 
                            EntryType, 
                            ModifiedBy,
                            ModifiedOn,
                            IsActive
                            )
                     VALUES
                        (
                           @p_TreatmentName,
						   @p_SysChiefType,
                           @p_ModifiedBy,
                           current_timestamp,
                           1
                           )

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='SYSEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        SELECT Id,Name,EntryType FROM dbo.[SysIllnessAndChiefComplaints_Mf] where (@p_SysChiefType='All' or EntryType=@p_SysChiefType)

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

    if @p_OPERTION_TYPE='SYUPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        update dbo.[SysIllnessAndChiefComplaints_Mf] set 
        Name=@p_TreatmentName,
		EntryType=@p_SysChiefType,
        ModifiedBy=@p_ModifiedBy,
        ModifiedOn=current_timestamp,
        IsActive=1
       where Id=@p_Id
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
   

END
     if  @p_OPERTION_TYPE='SYDEL'
    begin
	 BEGIN TRY
      delete from dbo.[SysIllnessAndChiefComplaints_Mf] where Id=@p_Id
	  SET @status='1'
	   END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	   SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
    end





end
GO
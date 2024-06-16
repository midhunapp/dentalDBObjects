Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientOperations]    Script Date: 04-07-2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_PatientOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_PatientOperations]
Go 
CREATE procedure [dbo].[Up_PatientOperations]
@p_OPERTION_TYPE varchar(5) =null,
@p_FirstName varchar(20)  =null,
@p_LastName varchar(20)  =null,
@p_DOB date  =null,
@p_gender char(1)  =NULL,
@p_mobile varchar(15)  =NULL,
@p_address varchar(64)  =NULL,
@p_emailId varchar(50)  =NULL,
@p_nationalityId int  =NULL,
@p_modified_by int  =NULL,
@p_idproof varbinary(8000) =null,
@p_eid varchar(20) =null,
@p_id int =null,
@p_drId int =null,
@p_patientId int=null,
@p_appdate DateTime =null,
@p_patientOnly bit =0,
@p_isAll bit=0,
@p_appId int =null,
@p_isDateSelect bit=0,
@p_Emirates varchar(25)  =NULL,
@responseMessage varchar(200)=null OUTPUT,
@status char(1) ='0'  OUTPUT
as
begin
	
    if @p_OPERTION_TYPE='INS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if ( select count(Id) from [Patient_Details] where Mobile=@p_mobile)>0
	begin
	    SET @responseMessage='Mobile number is already Registered'
        SET @status='0'
		return
	end
	
	if ( select count(Id) from [Patient_Details] where EID=@p_eid)>0
	begin
	    SET @responseMessage='EID is already Registered'
        SET @status='0'
		return
	end

        INSERT INTO dbo.[Patient_Details] 
                        (
                            FirstName, 
                            LastName, 
                            DOB, 
                            Mobile,
                            FullAddress,
                            EmailId,
                            Gender,
							EID,
                            NationalityId,
                            IdProof,
							RegDate,
                            ModifiedBy,
                            ModifiedOn,
                            IsActive,
							Emirates
                            )
                     VALUES
                        (
                           @p_FirstName,
                           @p_LastName,
                           @p_DOB,
                           @p_mobile,
                           @p_address,
                           @p_emailId,
                           @p_gender,
						   @p_eid,
                           @p_nationalityId,
                           @p_idproof,
						   current_timestamp,
                           @p_modified_by,
                           current_timestamp,
                           1,
						   @p_Emirates
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
	begin
	  	  select 
			 Pt.Id as RegNo,
			 pt.FirstName+' '+ pt.LastName as Name,
			 pt.EID,
			 pt.EmailId as Email,
			 pt.DOB,
			 pt.RegDate as RegDate,
			 pt.RegDate as LastVisit,
			 pt.FullAddress as Address,
			 nt.NationalityName as Nationality,
			 Convert(varchar(20),pt.Mobile) as Mobile,
             pt.FirstName,
             pt.LastName,
             nt.Id as NationalityId,
			 pt.Gender as Gender,
			 pt.Emirates
			 from dbo.[Patient_Details] pt
			 inner join Nationality_Mf nt on pt.NationalityId=nt.id

	end

	if @p_OPERTION_TYPE='UPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	if ( select count(Id) from [Patient_Details] where Mobile=@p_mobile and Id<>@p_id)>0
	begin
	    SET @responseMessage='Mobile number is already Registered'
        SET @status='0'
		return
	end
	
	if ( select count(Id) from [Patient_Details] where EID=@p_eid  and Id<>@p_id)>0
	begin
	    SET @responseMessage='EID is already Registered'
        SET @status='0'
		return
	end

        update dbo.[Patient_Details] 
                        set
                            FirstName=@p_FirstName, 
                            LastName=@p_LastName, 
                            DOB=@p_DOB, 
                            Mobile=@p_mobile,
                            FullAddress=@p_address,
                            EmailId=@p_emailId,
                            Gender=@p_gender,
							EID=@p_eid,
                            NationalityId=@p_nationalityId,
                            IdProof=@p_idproof,
                            ModifiedBy=@p_modified_by,
                            ModifiedOn=current_timestamp,
                            IsActive=1,
							Emirates=@p_Emirates
                            where Id=@p_id

        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END
    
	if @p_OPERTION_TYPE='DEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	    
	if ( select count(Id) from PatientVisitDetails where PatientId=@p_id )>0
	begin
	    SET @responseMessage='Could not delete this patient.Patient already has visit records'
        SET @status='0'
		return
	end
	if ( select count(Id) from Appointments where PatientId=@p_id )>0
	begin
	    SET @responseMessage='Could not delete this patient.Patient already has appointment records'
        SET @status='0'
		return
	end
        delete dbo.[Patient_Details] where Id=@p_id
                       
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END
   
    if @p_OPERTION_TYPE='VISIT'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	if (select count(*) from dbo.[PatientVisitDetails] where PatientId=@p_id and DoctorId=@p_drId and  CAST(DateOfVisit AS date) = CAST(GETDATE() AS date) and IsOpen=1)>0
	begin
	    SET @responseMessage='A Pending visit is already  there for today. You colud not create a new visit for the same doctor today'
        SET @status='0'
		return
	end
    INSERT INTO dbo.[PatientVisitDetails] 
                        (
                            PatientId, 
                            DateOfVisit, 
                            DoctorId, 
							IsOpen,
                            ModifiedBy,
                            ModifiedOn
                            )
                     VALUES
                        (
                           @p_id,
                           GETDATE(),
                           @p_drId,
                           1,
                           @p_modified_by,
                           current_timestamp
                           )
    update Appointments set IsActive=0 where PatientId=@p_id and DoctorId=@p_drId and  CAST(AppointmentDateTime AS date) = CAST(GETDATE() AS date)
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END

   
    if @p_OPERTION_TYPE='CRAPP'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        INSERT INTO dbo.[Appointments] 
                        (
                            PatientId, 
                            AppointmentDateTime, 
                            DoctorId, 
                            ModifiedBy,
                            ModifiedOn
                            )
                     VALUES
                        (
						@p_patientId,
						@p_appdate,
						@p_drId,
                        @p_modified_by,
                        current_timestamp
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
     if @p_OPERTION_TYPE='SLAPP'
	begin
	  select 
		p.FirstName + ' '+ p.LastName as Patient,
		d.FirstName +' '+ d.LastName as Doctor,
		a.AppointmentDateTime as AppointmentDate,
		a.Id
	   from Appointments a
	   inner join Patient_Details p on a.PatientId=p.Id
	   inner join [User] d on d.Id=a.DoctorId
	   where
	   (
	    (
	     (@p_patientOnly=1 and a.PatientId=@p_patientId)
		 or 
		 (@p_patientOnly=0 and @p_isAll=1 )
		 )
		 and (ISNULL(@p_drId,-1)=0 or a.DoctorId=ISNULL(@p_drId,-1))
		 and (@p_isDateSelect =0 or( @p_isDateSelect=1 and CAST(a.AppointmentDateTime As date)=CAST(@p_appdate As date)))
		 and CAST(a.AppointmentDateTime As date)>=CAST(GETDATE() As date)
       )
	   and a.IsActive=1
	   order by a.AppointmentDateTime desc
	end

	if @p_OPERTION_TYPE='DLAPP'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	    
        delete dbo.Appointments where Id=@p_appId
                       
        SET @responseMessage='Success'
        SET @status='1'
    END TRY
    BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END
	
end
GO
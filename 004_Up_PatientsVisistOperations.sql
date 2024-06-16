Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientsVisitOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_PatientsVisitOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_PatientsVisitOperations]
Go 
CREATE procedure [dbo].[Up_PatientsVisitOperations]
@p_OPERTION_TYPE varchar(5) =null,
@p_OPERTION_SUB_TYPE varchar(5) =null,
@p_TodaysVisitType char(1)  =null,
@p_AppointMent char(1)  =NULL,
@p_FromDate date  =null,
@p_ToDate date =null,
@p_ModifiedBy int=null,
@p_visitId int=null,
@p_patientId int=null,
@p_doctorId int=null,
@p_BalanceBF numeric(11,2)=0,
@p_Amount numeric(11,2)=0,
@p_AmountRecieved numeric(11,2)=0,
@p_Discount numeric(11,2)=0,
@p_BalanceCF numeric(11,2)=0,
@p_todaysVisists bit=0,
@p_CashEntryFromDR char(1)='N',
@p_type PatientInvoiceRecords_DTTyp  readonly,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin
	
    if @p_OPERTION_TYPE='SEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	  
	    IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL 
		BEGIN 
			DROP TABLE #TempTable
		END


       SELECT 
	   p.Id as [Visit No.],
	   pd.FirstName+ ' ' +pd.LastName as Name,
	   pd.id as [Reg No.],
	   case when pd.Gender='F' then 'Female' else 'Male' end as Gender ,
	   p.DateOfVisit as [Date of Visit],
	   p.EndTime,
	    'N' appointment
	   into  #TempTable
	   FROM PatientVisitDetails p
	   inner join Patient_Details pd on p.PatientId=pd.Id
	   where p.DoctorId=@p_doctorId
	   and (
	          (@p_TodaysVisitType='P' and P.IsOpen=1 and  CAST(P.DateOfVisit As date)=CAST(GETDATE() As date))
			  OR
			  (@p_TodaysVisitType='C' and P.IsOpen=0 and  CAST(P.DateOfVisit As date)=CAST(GETDATE() As date))
			  OR
			  (@p_TodaysVisitType='A' and  CAST(P.DateOfVisit As date)=CAST(GETDATE() As date))
			  OR
			  (@p_TodaysVisitType='N' and CAST(P.DateOfVisit As date) >=@p_FromDate  and CAST(P.DateOfVisit As date) <=@p_ToDate) 
			  
			  
		   ) order by p.DateOfVisit 


		if @p_AppointMent='Y'
		begin 
		   select * from #TempTable
		   union
		   SELECT 
				p.Id as [Visit No.],
				pd.FirstName+ ' ' +pd.LastName as Name,
				pd.id as [Reg No.],
				case when pd.Gender='F' then 'Female' else 'Male' end as Gender ,
				p.AppointmentDateTime as [Date of Visit],
				null as EndTime,
				 'Y' appointment
				FROM Appointments p
				inner join Patient_Details pd on p.PatientId=pd.Id
				where p.DoctorId=@p_doctorId
				and CAST(P.AppointmentDateTime As date)=CAST(GETDATE() As date)
				and pd.Id not in (select [Reg No.] from #TempTable)
			    and p.IsActive=1
				order by [Date of Visit]
	     end
		 else
		  select * from #TempTable

		  drop table #TempTable


        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
    END CATCH

END
    
	if @p_OPERTION_TYPE='SELPT'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

       SELECT 
	   p.Id as VisitNo,
	   pd.FirstName+ ' ' +pd.LastName as Name,
	   pd.id as RegNo,
	   case when pd.Gender='F' then 'Female' when pd.Gender='M'then 'Male' else 'Transgender' end as Gender,
	   p.DateOfVisit,
	   p.EndTime,
	   pd.EID as EID,
	   Datediff(YY,pd.DOB,GETDATE()) as Age
	   FROM PatientVisitDetails p
	   inner join Patient_Details pd on p.PatientId=pd.Id
	   where p.id=@p_visitId
	   

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
    END CATCH

END

	if @p_OPERTION_TYPE='PTVST' and @p_OPERTION_SUB_TYPE='BILL'
	BEGIN
    BEGIN TRY

       SELECT 
	   'Show' as [Diagnosis Report],
	   p.Id as VisitNo,
	   p.DateOfVisit,
	   pd.FirstName+ ' ' +pd.LastName+'('+ Convert(varchar,pd.Id)+')' as  [Patient(RegNo.)],
	   dd.FirstName+ ' ' +dd.LastName as Doctor,
	   pd.id as RegNo,
	   case when pd.Gender='F' then 'Female' when pd.Gender='M'then 'Male' else 'Transgender' end as Gender,
	   BalanceTable.BalanceFromPrevious as [Balance Due],
	   ISNULL(BalanceTable.Amount,0)as Amount,
	   ISNULL(BalanceTable.Discount,0) as Discount,
	   ISNULL(BalanceTable.TotalToPay,0) as [Total To be Paid],
	   ISNULL(BalanceTable.AmountRecieved,0) as [Amount Recieved],
	   ISNULL(BalanceTable.BalanceToPay,0) as [Balance to pay],
	   isnull(INV.PaidStatus,'N') as PaidStatus,
	   isnull(INV.DrApproval,'N') as DrApproval
	   FROM PatientVisitDetails p
	   inner join Patient_Details pd on p.PatientId=pd.Id
	   inner join [User] dd on dd.Id=p.DoctorId
	   Left join [PatientInvoiceRecords] inv on inv.VIsitId=p.Id
	   OUTER APPLY [dbo].[Uf_BalanceCalculation](p.Id,p.PatientId)  as BalanceTable 
	   where (p.PatientId=@p_patientId or @p_patientId=-1)
	   and (@p_todaysVisists=0 or cast(p.DateOfVisit as date)=cast(GETDATE() as date))
	   order by p.DateOfVisit desc

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
    END CATCH

END

    if @p_OPERTION_TYPE='PTVST' and @p_OPERTION_SUB_TYPE='DR'
	BEGIN
    BEGIN TRY

       SELECT 
	   'Show' as [Diagnosis Report],
	   cast(p.DateOfVisit as date) [Date],
	   pd.FirstName+ ' ' +pd.LastName as Patient,
	   dd.FirstName+ ' ' +dd.LastName as Doctor,
	  -- case when pd.Gender='F' then 'Female' when pd.Gender='M'then 'Male' else 'Transgender' end as Gender
	   cs.PlanOfCare as [Plan of care],
	   SCMF.Name as [Chief Complaint],
	   DMF.DiagnosisCode +' '+ DMF.DiagnosisName as Diagnosis,
	   p.Id
	  
	   FROM PatientVisitDetails p
	   inner join Patient_Details pd on p.PatientId=pd.Id
	   inner join [User] dd on dd.Id=p.DoctorId
	   left join PatientCaseSheet CS on CS.VisitId=P.Id
	   left join SysIllnessAndChiefComplaints_Mf SCMF on SCMF.Id=CS.ChiefComplaintId
	   left join Diagnosis_Mf DMF on DMF.Id=cs.DiagnosisId
	  
	   where p.PatientId=@p_patientId
	   order by p.DateOfVisit desc

        SET @responseMessage='Success'
		set @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
    END CATCH

END
    
	if @p_OPERTION_TYPE='BILL' and @p_OPERTION_SUB_TYPE='SEL'
	begin
	  
	  select @p_patientId=PatientId from PatientVisitDetails where Id=@p_visitId

	  if (select count(Id) from [PatientInvoiceRecords] where VisitId=@p_visitId) =0
	  begin
	  declare @treatmentWiseAmount table(
			TreatmentId int,
			TreatmentName varchar(64),
			Amount numeric(11,2)
			)
	  declare @BalanceDetails table(
			BalanceFromPrevious numeric(11,2),
			Total  numeric(11,2),
			Discount numeric(11,2),
			AmountRecieved numeric(11,2),
			PaidStatusOfCurrentVisit char(1),
			DrApproval char(1)
			)

		 insert into @treatmentWiseAmount
	     select T.Id as TreatmentId,T.TreatmentName,sum(Amount) as Amount from PatientTreatments PT 
		 inner join Treatments_Mf T on PT.TreatmentId=T.Id
	     where PT.VisitId=@p_visitId group by T.Id,T.TreatmentName
	     union 
	     select ID,TreatmentName,Amount from Treatments_Mf where TreatmentCode='XRAY'
	     and (select count(Id) from PatientCaseSheetAttachments where VisitId=@p_visitId)>0
	     and (select count(Id) from [PatientInvoiceRecords] where VisitId=@p_visitId) =0
		 UNION
		 select ID,TreatmentName,Amount from Treatments_Mf where TreatmentCode='CONSULT'
		 
		 declare @treatmentWiseTOtal numeric(11,2)=0
		 select @treatmentWiseTOtal=sum(Amount) from @treatmentWiseAmount

		 insert into @BalanceDetails
		 select top 
			    1 BalanceCF as BalanceFromPrevious,
			    BalanceCF +isnull(@treatmentWiseTOtal,0) as Total,
				0 as Discount,
				0 as AmountRecieved,
			    'N' as PaidStatusOfCurrentVisit,
				'N' as DrApproval
	         from PatientInvoiceRecords INV 
	         Inner join PatientVisitDetails PV on PV.ID=INV.VisitId 
			 where PV.PatientId=@p_patientId and INV.PaidStatus='Y' 
			 order BY ISNULL(PaidOn,'1990-01-01') desc

	    if(select count(*) from @BalanceDetails)=0
		  insert into @BalanceDetails values(0,isnull(@treatmentWiseTOtal,0),0,0,'N','N')

		  select * from @treatmentWiseAmount
		  select * from @BalanceDetails
			    
	  end
	  else
	  begin
	   declare @p_invoiceId int=null
		 select @p_invoiceId=Id from PatientInvoiceRecords where VisitId=@p_visitId
		 select T.Id as TreatmentId,T.TreatmentName,ISNULL(PNVDT.Amount,0) As Amount
		 from [PatientInvoiceRecords_DT] PNVDT 
		 inner join Treatments_Mf T on PNVDT.TreatmentId=T.Id
		 inner join [PatientInvoiceRecords] PNV on PNV.VisitId=@p_visitId
	     where PNVDT.InvoiceId=@p_invoiceId

		 select BalanceBF as BalanceFromPrevious,
				ISNULL(PaidStatus,'N') as PaidStatusOfCurrentVisit,
				ISNULL(DrApproval,'N') as DrApproval,
				 Amount+BalanceBF-Discount as Total,
			 Discount,
			 AmountRecieved
		  from [PatientInvoiceRecords]
		  where Id=@p_invoiceId
	  end

	 
	  
	  
	   
	  
	end

	if @p_OPERTION_TYPE='BILL' and @p_OPERTION_SUB_TYPE='INS'
	begin
	 BEGIN TRY
	  begin transaction
	  declare @invoiceId int=0
	  select @invoiceId=Id from [PatientInvoiceRecords] where VisitId=@p_visitId
	  if(@invoiceId>0)
	  begin
		update [PatientInvoiceRecords]
		set BalanceBF=@p_BalanceBF,
		Amount=@p_Amount-@p_BalanceBF+@p_Discount,
		AmountRecieved=@p_AmountRecieved,
		Discount=@p_Discount,
		BalanceCF=(@p_Amount-@p_AmountRecieved),
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP,
		DrApproval=case when @p_CashEntryFromDR='N' then DrApproval else @p_CashEntryFromDR end,
		PaidStatus=case when @p_CashEntryFromDR='Y' then 'N' else 'Y' end,
		Currency='AED',
		PaidOn=case when @p_CashEntryFromDR='Y' then null else CURRENT_TIMESTAMP end
		where Id=@invoiceId
		delete from [PatientInvoiceRecords_DT] where InvoiceId=@invoiceId
		 insert into [PatientInvoiceRecords_DT]
		  (
		   InvoiceId,
		   TreatmentId,
		   Amount,
		   ModifiedBy,
		   ModifiedOn
		  )
		  select 
		  @invoiceId,
		  p.TreatmentId,
		  p.Amount,
		  @p_ModifiedBy,
		  CURRENT_TIMESTAMP
		  from @p_type p
	  end
	  else
	  begin
	  set @invoiceId=0
	  select @invoiceId=Next value for PatientInvoiceRecords_SEQ
	  insert into [PatientInvoiceRecords]
	  (
	  ID,
	  VisitId,
	  BalanceBF,
	  Amount,
	  AmountRecieved,
	  Discount,
	  BalanceCF,
	  ModifiedBy,
	  ModifiedOn,
	  DrApproval,
	  PaidStatus,
	  Currency,
	  PaidOn)
	  values
	  (@invoiceId,
	  @p_visitId,
	  @p_BalanceBF,
	  @p_Amount-@p_BalanceBF+@p_Discount,
	  @p_AmountRecieved,
	  @p_Discount,
	  (@p_Amount-@p_AmountRecieved),
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP,
	  @p_CashEntryFromDR,
	  case when @p_CashEntryFromDR='Y' then 'N' else 'Y' end,
	  'AED',
	  case when @p_CashEntryFromDR='Y' then null else CURRENT_TIMESTAMP end)
	  insert into [PatientInvoiceRecords_DT]
	  (
	   InvoiceId,
	   TreatmentId,
	   Amount,
	   ModifiedBy,
	   ModifiedOn
	  )
	  select 
	  @invoiceId,
	  p.TreatmentId,
	  p.Amount,
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP
	  from @p_type p
	  end
	  if @p_CashEntryFromDR='N'
	    update PatientVisitDetails set EndTime=CURRENT_TIMESTAMP ,IsOpen=0 where id=@p_visitId
        SET @responseMessage='Success'
		set @status='1'
		commit
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		rollback
    END CATCH
	end

	if @p_OPERTION_TYPE='BILL' and @p_OPERTION_SUB_TYPE='DEL'
	begin
	 BEGIN TRY
	 begin transaction
	  select @invoiceId=Id from [PatientInvoiceRecords] where VisitId=@p_visitId
	  if(@invoiceId>0)
	  begin
	    delete from [PatientInvoiceRecords_DT] where InvoiceId=@invoiceId
		delete from [PatientInvoiceRecords] where Id=@invoiceId
		
	  end
	  SET @responseMessage='Success'
		set @status='1'
	  commit
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		set @status='0'
		rollback
    END CATCH
	end

END


GO
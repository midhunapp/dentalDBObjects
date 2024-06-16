Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientsVisitOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_rptOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_rptOperations]
Go 
CREATE procedure [dbo].[Up_rptOperations]
@p_OPERTION_TYPE varchar(20) =null,
@p_visitId int =null,
@p_Period varchar(6)=null
as
begin
declare @doctor_id int=null
declare @patient_id int=null
if @p_OPERTION_TYPE='PRESCRIPTION'
begin

select @doctor_id=DoctorId,@patient_id=PatientId from PatientVisitDetails where Id=@p_visitId
    select 
     case when md.Id=-1 then pr.OtherMedicine else md.MedicienName end as Medicine,
	 ROW_NUMBER() OVER (order by md.ID ) as   MedicineId,
	 pr.Dose,
	 pr.Days,
	 pr.Times,
	 pr.Id,
	 pr.VisitId
  from 
  [dbo].[Prescriptions] pr
  left join [Medicines_Mf] md on pr.MedicineId=md.Id
  where pr.VisitId=@p_visitId
    select ClinicName,ClinicAddress,PhoneNumber,ReportHeader,Fax,Email,Website from CinicDetails
	Select FirstName+' '+LastName as DoctorName,Designation,Moh ,Specialization from [User] where Id=@doctor_id
	Select FirstName+' '+LastName as PatientName,DATEDIFF(yy,DOB,getdate()) as Age,case when Gender='F' then 'Female' else 'Male' end as Gender,EID,Id as RegNo from Patient_Details where Id=@patient_id
	select GETDATE() as TodayDate 
end

if @p_OPERTION_TYPE='PATIENTINVOICE'
begin
  declare @invoiceid int=null
  select @patient_id=PatientId from PatientVisitDetails where Id=@p_visitId
  select ClinicName,ClinicAddress,PhoneNumber,ReportHeader,Fax,Email,Website from CinicDetails
  select FirstName+' '+LastName as PatientName,DATEDIFF(yy,DOB,getdate()) as Age,case when Gender='F' then 'Female' else 'Male' end as Gender,EID,Id as RegNo from Patient_Details where Id=@patient_id
  select @invoiceid=inv.Id from PatientInvoiceRecords inv where inv.VisitId=@p_visitId
  select Id as InvoiceNo,Amount as SubTotal,AmountRecieved,Discount,BalanceBF,BalanceCF,(Amount+BalanceBF-Discount) as Total from PatientInvoiceRecords where Id=@invoiceid
  select ROW_NUMBER() OVER (order by DT.ID ) as SLNO,tm.TreatmentName,DT.Amount from PatientInvoiceRecords_DT DT 
  inner join Treatments_Mf TM on DT.TreatmentId=TM.Id
  where DT.InvoiceId=@invoiceid
end

if @p_OPERTION_TYPE='MONTHLYREPORT'
begin

DECLARE @year INT;
DECLARE @month INT;
DECLARE @day INT;
DECLARE @startdate datetime;
declare @endate datetime;
SET @year = convert(int,SUBSTRING( @p_Period, 1, 4 ))
SET @month =  convert(int,SUBSTRING( @p_Period, 5, 2 ))
SET @day = 1
select @startdate=DATEFROMPARTS(@year, @month, @day);
SELECT @endate=EOMONTH(@startdate)

declare  @temTable Table
(
 RowNumber int null,
 [Date] varchar(15) null,
 [Description] varchar(64) null,
 [Debit] numeric(11,2) null,
 [Credit] numeric (11,2) null
)

insert into @temTable
	  select 
	  0,
	 REPLACE(CONVERT(CHAR(11), @startdate, 106),' ','-')  as [Date],
	  'Patient Revenue' as [Description],
	  0 as [Debit],
	  sum(AmountRecieved) as [Credit]
	from PatientInvoiceRecords where PaidStatus='Y' and cast(PaidOn as date)>=cast(@startdate as date) and cast(PaidOn as date)<=cast(@endate  as date)

    insert into @temTable
    select 
    1,
    REPLACE(CONVERT(CHAR(11), m.Dates, 106),' ','-')  as [Date],
	mf.ComponentName as [Description],
	case when MF.ComponentType='DED' then isnull(M.Amount,0) else 0 end as [Debit],
	case when MF.ComponentType='EAR' then isnull(M.Amount,0) else 0 end as [Credit]
	from MonthlyEarningDeduction M 
    inner join EarDedComponents_Mf MF on M.ComponentId=MF.Id
    where cast(M.Dates as date)>=cast(@startdate as date) and cast(M.dates as date)<=cast(@endate as date)

insert into @temTable
select 1,
REPLACE(CONVERT(CHAR(11), k.OrderRecievedDate, 106),' ','-') ,
SD.Name + '-'+ WK.WorkName ,
sum(k.InvoiceAmount),
0 
 from [LabWork_Order] k
inner join SupplierDetails SD on SD.Id=k.SupplierId
inner join Lab_Works_Mf WK on WK.Id=K.WorkId
where k.InvoiceNo is not null 
and  cast(k.OrderRecievedDate as date)>=cast(@startdate as date) and cast(k.OrderRecievedDate as date)<=cast(@endate as date)
group by K.OrderRecievedDate,k.SupplierId,k.WorkId,sd.Name,wk.WorkName



insert into @temTable
select 
   2,
   null,
   'Total',
   sum(Debit),
   sum(Credit)
   from @temTable

   select [Date],[Description],Debit,Credit from @temTable order by RowNumber ,[Date]
   	




	  select ClinicName,ClinicAddress,PhoneNumber,ReportHeader,Fax,Email,Website from CinicDetails
end

if @p_OPERTION_TYPE='DIAGNOSIS'
begin
declare @otherSys varchar(200)=null
declare @otherplanofCare varchar(200)=null
declare @diagnosis varchar(200)=null
declare @pasthistory varchar(200)=null
declare @chiefCOmplaint varchar(200)=null
select @chiefCOmplaint=CHF.Name,@otherSys=OtherSysIllness,@otherplanofCare=PlanOfCare,@pasthistory=PastHistory,@diagnosis=dmf.DiagnosisCode+' - '+dmf.DiagnosisName  from PatientCaseSheet PCS 
		inner join Diagnosis_Mf DMF on DMF.Id=PCS.DiagnosisId
		inner join SysIllnessAndChiefComplaints_Mf CHF on CHF.Id=PCS.ChiefComplaintId
	where VisitId=@p_visitId
    select @doctor_id=DoctorId,@patient_id=PatientId from PatientVisitDetails where Id=@p_visitId
	create table #tempMedication
	(
	 Name varchar(200)
	)

	insert into #tempMedication
    select 
     md.MedicienName+ ' '+ '- for '+ convert(varchar,pr.Days) +' Day(s) ,' + convert(varchar,pr.Times) + ' times'
  from 
  [dbo].[Prescriptions] pr
  left join [Medicines_Mf] md on pr.MedicineId=md.Id
  where pr.VisitId=@p_visitId
  if (select count(*) from #tempMedication)=0
  insert into #tempMedication values('Nothing')

  select * from #tempMedication
    select ClinicName,ClinicAddress,PhoneNumber,ReportHeader,Fax,Email,Website from CinicDetails
	Select FirstName+' '+LastName as DoctorName,Designation,Moh ,Specialization from [User] where Id=@doctor_id
	Select FirstName+' '+LastName as PatientName,DATEDIFF(yy,DOB,getdate()) as Age,case when Gender='F' then 'Female' else 'Male' end as Gender,EID,Id as RegNo from Patient_Details where Id=@patient_id

	
	create table #tempSysIllness
	(
	 Name varchar(200)
	)
	create table #tempPlanOfCare
	(
	 TreatmentName  varchar(200)
	)
	create table #tempRadio
	(
	 Test varchar(200)
	)
	insert into #tempSysIllness
	select 
	 SYMF.Name
	 from PatientCaseSheetSystemicIllNess SY 
	inner join SysIllnessAndChiefComplaints_Mf SYMF on SYMF.Id=SY.SysId
	where VisitId=@p_visitId
	
	if(select count(*) from #tempSysIllness)=0
	insert into #tempSysIllness values('Nothing')
	if (@otherSys is not null)
	insert into #tempSysIllness values(@otherSys)

	select * from #tempSysIllness
	insert into #tempPlanOfCare
	select 'Adviced '+tmf.TreatmentName + ' RTT '+ pt.Teeth from PatientTreatments pT inner join Treatments_Mf TMF on TMF.Id=pT.TreatmentId where PT.VisitId=@p_visitId
	if(@otherplanofCare  is not null)
	insert into #tempPlanOfCare values(@otherplanofCare) 
	select * from #tempPlanOfCare
	insert into #tempRadio select 'X-RAY - ' + [Description] from PatientCaseSheetAttachments where VisitId=@p_visitId
	if(select count(*) from #tempRadio)=0
	insert into #tempRadio values('Nothing')
	select * from #tempRadio
	select DateOfVisit,Id as VisitiNo,@diagnosis as Diagnosis,@chiefCOmplaint ChiefComplaint  from PatientVisitDetails where Id=@p_visitId

end

end
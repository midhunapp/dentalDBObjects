Use [DHCM]

/****** Object:  StoredProcedure [dbo].[DAH_User_Insert]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_PatientRevenue]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_PatientRevenue]
Go 
CREATE procedure [dbo].[Up_PatientRevenue]
@p_OPERTION_TYPE varchar(5) =null,
@p_period varchar(6)  =null,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
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
begin
	if @p_OPERTION_TYPE='SEL'
	begin
	declare @c_patientId int,@BalanceBF numeric(11,2),@ThisMonthAmount numeric(11,2),@BalanceCF numeric(11,2)
	
	declare @patientRevenue table(
	rowId int,
	patientId int,
	patientName varchar(50),
	BalanceBF numeric(11,2),
	ThisMonthAmount numeric(11,2),
	AmountRecieved numeric(11,2),
	BalanceCF numeric(11,2)
	)
	insert into @patientRevenue
	select 
	1,
	pd.Id,
	PD.FirstName +' '+ pd.LastName ,
	0,
	sum(PNV.Amount-isnull(PNV.Discount,0)),
	sum(PNV.AmountRecieved),
	0
	from PatientInvoiceRecords PNV
	inner join PatientVisitDetails PVD on PVD.Id=PNV.VisitId
	inner join Patient_Details PD on PD.Id=PVD.PatientId
	where Pnv.PaidStatus='Y' and CONVERT(CHAR(6), PNV.PaidOn, 112) =@p_Period
	group by PD.Id,PD.FirstName,pd.LastName

		DECLARE emp_cursor CURSOR FOR     
		SELECT patientId FROM @patientRevenue   
		open emp_cursor
		FETCH NEXT FROM emp_cursor  INTO @c_patientId      

		WHILE @@FETCH_STATUS = 0    
		begin
		  set @BalanceBF=0
		  set @BalanceCF=0
		  ----select BF record
		  select top 1 @BalanceBF= isnull(PNv.BalanceCF,0) from PatientInvoiceRecords PNV
						inner join PatientVisitDetails PVD on PNV.VisitId=PVD.Id
						where pvd.PatientId=@c_patientId
						and PNV.PaidStatus='Y' and PNV.PaidOn<@startdate
						order by PaidOn desc
		  -----select CF record 
		  select top 1 @BalanceCF= isnull(PNv.BalanceCF,0) from PatientInvoiceRecords PNV
						inner join PatientVisitDetails PVD on PNV.VisitId=PVD.Id
						where pvd.PatientId=@c_patientId
						and PNV.PaidStatus='Y' and PNV.PaidOn>=@startdate and PNV.PaidOn<=@endate
						order by PaidOn desc

		  update @patientRevenue set BalanceBF=isnull(@BalanceBF,0) ,BalanceCF=isnull(@BalanceCF,0)  where patientId=@c_patientId

		FETCH NEXT FROM emp_cursor  INTO @c_patientId
		end
		CLOSE emp_cursor;    
		DEALLOCATE emp_cursor;    

		insert into @patientRevenue
		
		  select -1,
		  0,
		  'Total',
		  sum(BalanceBF),
		  sum(ThisMonthAmount),
		  sum(AmountRecieved),
		  sum(BalanceCF)
		  from @patientRevenue

		select patientName as Patient, BalanceBF as [Balance from Previous month],
		ThisMonthAmount as [This Month Amount],
		AmountRecieved as [Amount Recieved in this Month],
		BalanceCF as [Balance Amount to Collect]
		from @patientRevenue
		order by rowId desc
		
	end

END


GO
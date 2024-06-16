use [DHCM]
/****** Object:  StoredProcedure [dbo].[Up_LabWorksOperations]    Script Date: 14-07-2020 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_LabWorksOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].Up_LabWorksOperations
Go 
CREATE procedure [dbo].Up_LabWorksOperations
@p_OPERTION_TYPE varchar(5) =null,
@p_SUB_OPERTION_TYPE varchar(5) =null,
@p_WorkId int  =null,
@p_LabRatesId int  =null,
@p_VisitId int  =null,
@p_WorkName VARCHAR(64)  =NULL,
@p_ModifiedBy int=null,
@p_SupplierId  int=null,
@p_FirstTeeth numeric(11,2)=null,
@p_AdditionalTeeth numeric(11,2)=null,
@p_FullTeeth numeric(11,2)=null,
@p_ValidFrom date=null,
@p_ValidTo date =null,
@p_newType [LabWork_NewTyp] READONLY,
@p_penType [LabWork_PendTyp] READONLY,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin


if @p_SUB_OPERTION_TYPE='WORK' and @p_OPERTION_TYPE='SEL'
begin
  select Id,
		 WorkName
   from Lab_Works_Mf
end

if  @p_SUB_OPERTION_TYPE='WORK' and @p_OPERTION_TYPE='INS' 
	begin
	 BEGIN TRY
	  begin transaction
	  insert into Lab_Works_Mf
	  (
	  WorkName,
	  ModifiedBy,
	  ModifiedOn
		)
	  values
	  (@p_WorkName,
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP
	 )
	
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

if  @p_SUB_OPERTION_TYPE='WORK' and @p_OPERTION_TYPE='UPD' 
begin
	 BEGIN TRY
	  begin transaction
      update Lab_Works_Mf
	  set 
	    WorkName=@p_WorkName,
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP
		where Id=@p_WorkId
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

if  @p_SUB_OPERTION_TYPE='WORK' and @p_OPERTION_TYPE='DEL' 
begin
	 BEGIN TRY
	  begin transaction

	  delete from Lab_Works_Mf where Id=@p_WorkId

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


if @p_SUB_OPERTION_TYPE='LABRT' and @p_OPERTION_TYPE='SEL'
begin
   select Lr.Id,
		  LR.WorkId,
		  LR.SupplierId,
		  LW.WorkName as [work],
		  SD.Name as [Lab],
		  LR.ValidFrom,
		  LR.ValidTo,
		  Lr.FirstTeeth,
		  Lr.AdditionalTeeth,
		  Lr.FullTeeth
		 WorkName
   from Lab_Rates LR inner join Lab_Works_Mf LW on LW.Id=LR.WorkId
   inner join SupplierDetails SD on sd.Id=LR.SupplierId
end


if @p_SUB_OPERTION_TYPE='LABRT' and @p_OPERTION_TYPE='INS'
begin
BEGIN TRY
	  begin transaction
	 if( select COUNT(Id) from Lab_Rates where WorkId=@p_WorkId and SupplierId=@p_SupplierId and 
	  (
	     (ValidFrom<=@p_ValidFrom and ValidTo is null)
		 or
		 (ValidFrom>=@p_ValidFrom and ISNULL(@p_ValidTo,ValidFrom)>= ValidFrom)
		 or
		 (ValidFrom<=@p_ValidFrom and ISNULL(ValidTo,@p_ValidFrom)>=@p_ValidFrom)
	  ))>0
	  begin

	    SET @responseMessage='Period overlapping entry exists.'
		set @status='0'
		return
	  end
	 insert into Lab_Rates
  ( 
    WorkId,
	SupplierId,
	FirstTeeth,
	AdditionalTeeth,
	FullTeeth,
	ValidFrom,
	ValidTo,
	ModifiedBy,
	ModifiedOn)
	values
	(
	@p_WorkId,
	@p_SupplierId,
	@p_FirstTeeth,
	@p_AdditionalTeeth,
	@p_FullTeeth,
	@p_ValidFrom,
	@p_ValidTo,
	@p_ModifiedBy,
	CURRENT_TIMESTAMP
	)
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


if @p_SUB_OPERTION_TYPE='LABRT' and @p_OPERTION_TYPE='UPD'
begin
BEGIN TRY
	  begin transaction

	   if( select COUNT(Id) from Lab_Rates where WorkId=@p_WorkId and SupplierId=@p_SupplierId and Id<>@p_LabRatesId and
	  (
	     (ValidFrom<=@p_ValidFrom and ValidTo is null)
		 or
		 (ValidFrom>=@p_ValidFrom and ISNULL(@p_ValidTo,ValidFrom)>= ValidFrom)
		 or
		 (ValidFrom<=@p_ValidFrom and ISNULL(ValidTo,@p_ValidFrom)>=@p_ValidFrom)
	  ))>0
	  begin

	    SET @responseMessage='Period overlapping entry exists.'
		set @status='0'
		return
	  end


	update Lab_Rates
   set
    WorkId=@p_WorkId,
	SupplierId=@p_SupplierId,
	FirstTeeth=@p_FirstTeeth,
	AdditionalTeeth=@p_AdditionalTeeth,
	FullTeeth=@p_FullTeeth,
	ValidFrom=@p_ValidFrom,
	ValidTo=@p_ValidTo,
	ModifiedBy=@p_ModifiedBy,
	ModifiedOn=CURRENT_TIMESTAMP
	where Id=@p_LabRatesId
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

if @p_SUB_OPERTION_TYPE='LABRT' and @p_OPERTION_TYPE='DEL'
begin
BEGIN TRY
	  begin transaction
	delete Lab_Rates where Id=@p_LabRatesId
  
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

if @p_SUB_OPERTION_TYPE='NEW' and @p_OPERTION_TYPE='SEL'
begin
  select pvd.Id as VisitNo,
		   pvd.DateOfVisit as [Visit Date],
		   pd.FirstName+ ' ' +pd.LastName as Patient,
		   pd.Id as [Reg No],
		   US.FirstName+' '+US.LastName as Doctor
		 from PatientVisitDetails  PVD 
				inner join Patient_Details PD on PD.Id=PVD.PatientId
				inner join [User] US on US.Id=PVD.DoctorId
				inner join PatientTreatments PT on PVD.ID=PT.VisitId
				inner join Treatments_Mf TMF on PT.TreatmentId =TMF.ID
				where TMF.IsLabWorkIncluded='Y'
				and PVD.Id not in (select VisitId from LabWork_Order)
      -- inner join Pat
end

if @p_SUB_OPERTION_TYPE='NEW' and @p_OPERTION_TYPE='INS'
begin
	 BEGIN TRY
	  begin transaction
	  declare @labWorkId int=null
	  declare @VisitId int=null
	  declare @WorkId int=null
	  declare @SupplierId int=null
	  declare @OrderNo varchar(50)=null
	  declare @Notes varchar(200)=null
	  declare @TeethInf varchar(200)=null

	  DECLARE emp_cursor CURSOR FOR   SELECT VisitId,WorkId,SupplierId,OrderNo,Notes,TeethInfo FROM @p_newType     
	  open emp_cursor
      FETCH NEXT FROM emp_cursor  INTO @VisitId,@WorkId,@SupplierId,@OrderNo,@Notes,@TeethInf  
	  WHILE @@FETCH_STATUS = 0   
	  begin
	  select @labWorkId= Next value for LabWork_Order_SEQ 
	     insert into [LabWork_Order]
			  (
			  Id,
			  VisitId,
			  WorkId,
			  SupplierId,
			  OrderDate,
			  OrderNo,
			  Notes,
			  OrderCreatedBy,
			  OrderCreatedOn
				)
              values(
			  @labWorkId,
			  @VisitId,
			  @WorkId,
			  @SupplierId,
			  CURRENT_TIMESTAMP,
			  @OrderNo,
			  @Notes,
			  @p_ModifiedBy,
			  CURRENT_TIMESTAMP
			  )

            insert into [LabWork_Order_TeethInfo]
			(
			  LabWorkOrderId,
			  Teeth,
			  ModifiedBy,
			  ModifiedOn
			)
			  SELECT
			  @labWorkId,
			   Item,
			   @p_ModifiedBy,
			   CURRENT_TIMESTAMP
              FROM dbo.SplitString(@TeethInf, ',')

	  FETCH NEXT FROM emp_cursor  INTO @VisitId,@WorkId,@SupplierId,@OrderNo,@Notes,@TeethInf 
	  end
	  CLOSE emp_cursor;    
	  DEALLOCATE emp_cursor; 
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

if @p_SUB_OPERTION_TYPE='PEND' and @p_OPERTION_TYPE='SEL'
begin
declare @FirstTeeth numeric(11,2)
declare @AdditionalTeeth numeric(11,2)
declare @FullTeeth numeric(11,2)
	  declare @invId int=null
	  declare @invVisitId int=null
	  declare @invWorkId int=null
	  declare @invSupplierId int=null
      declare @teethCount int=null
	  declare @invoiceAmount numeric(11,2)=null
	  declare @teethname varchar(5)=null
declare @labworkOrder table(
	OrderNo varchar(50),
	VisitId int,
	patientName varchar(50),
	WorkName varchar(200),
	WorkId int,
	SupplierName varchar(200),
	SupplierId int,
	OrderRecievedDate date,
	InvoiceNo varchar(50),
	InvoiceAmount numeric(11,2),
	Id int
	)
  
  insert into @labworkOrder
  select 
  ORD.OrderNo,
  ORD.VisitId,
   pd.FirstName+ ' ' +pd.LastName,
  LWF.WorkName ,
  LWF.Id,
  SD.Name,
  SD.Id,
  ORD.OrderRecievedDate,
  ORD.InvoiceNo,
  ORD.InvoiceAmount,
  ORD.ID
 from LabWork_Order ORD 
   inner join PatientVisitDetails PV on PV.Id=ORD.VisitId
   inner join Patient_Details PD on PD.Id=PV.PatientId
   inner join Lab_Works_Mf LWF on LWF.Id=ORD.WorkId
   inner join SupplierDetails SD on ORD.SupplierId=sd.Id
   where InvoiceNo is null
      -- inner join Pat

DECLARE lab_cursor CURSOR FOR   SELECT WorkId,SupplierId,Id,VisitId FROM @labworkOrder     
	  open lab_cursor
      FETCH NEXT FROM lab_cursor  INTO @invWorkId,@invSupplierId,@invId,@invVisitId 
	  WHILE @@FETCH_STATUS = 0   
	  begin
	   set @FullTeeth=0
	   set @FirstTeeth=0
	   set @AdditionalTeeth=0
	   set @invoiceAmount=0;
	   set @teethCount=0
	   select @FirstTeeth=FirstTeeth,
	          @AdditionalTeeth=AdditionalTeeth,
			  @FullTeeth=FullTeeth
        from Lab_Rates LR where LR.SupplierId=@invSupplierId and LR.WorkId=@invWorkId and LR.ValidFrom <= CAST(GETDATE() As date) and isnull(LR.ValidTo,CAST(GETDATE() As date))>=CAST(GETDATE() As date)
		if @AdditionalTeeth=0
		begin
		  set @AdditionalTeeth=@FirstTeeth
		end
		select @teethCount=count(*) from [LabWork_Order_TeethInfo] where LabWorkOrderId=@invId
		if @teethCount>1
		begin
		  set @invoiceAmount= isnull(@FirstTeeth,0)+ ((@teethCount-1) * isnull(@AdditionalTeeth,0))
		end
		if @teethCount=1
		begin
		 select top 1 @teethname=Teeth from [LabWork_Order_TeethInfo]
		 if(@teethname='Full' or @teethname='FULL')
		 begin
		  if isnull(@FullTeeth,0) >0
		  begin
		    set @invoiceAmount=isnull(@FullTeeth,0)
		  end
		  else
		  begin
		  if( select top 1 IsPediatric from [PatientTreatments] where VisitId=@invVisitId )='Y'
		   begin
		    set @invoiceAmount=isnull(@FirstTeeth,0)*24
		   end
		  else
		     begin
		    set @invoiceAmount=isnull(@FirstTeeth,0)*32
		   end
		 end
		 end
		 else
		 begin
		  set @invoiceAmount=isnull(@FirstTeeth,0)
		 end
		end

	   update @labworkOrder set InvoiceAmount=@invoiceAmount where Id=@invId
	  FETCH NEXT FROM lab_cursor  INTO @invWorkId,@invSupplierId,@invId,@invVisitId 
	  end
	  CLOSE lab_cursor;    
	  DEALLOCATE lab_cursor; 

	  select 
	  --'' as ' ',
	  OrderNo as [Order No.],
	  VisitId as [Visit No.],
	  patientName as Patient,
	  WorkName as Work,
	  SupplierName as Supplier,
	  OrderRecievedDate as [Invoice Date],
	  isnull(InvoiceNo,OrderNo) as [Invoice No.],
	  InvoiceAmount as  [Invoice Amount],
	  Id ,
	  InvoiceAmount as AmountCopy
	  from @labworkOrder
end

if @p_SUB_OPERTION_TYPE='NEW' and @p_OPERTION_TYPE='WORK'
begin
  declare @teethInfo varchar(max)=null
  SELECT @teethInfo = COALESCE(@teethInfo + ', ', '') + Teeth from PatientTreatments where VisitId=@p_VisitId
  select @teethInfo as TeethInfo
end

if @p_SUB_OPERTION_TYPE='PEND' and @p_OPERTION_TYPE='INS'
begin
	 BEGIN TRY
	  begin transaction
	  update k 
	  set k.InvoiceNo=p.InvoiveNo,
	  k.OrderRecievedDate=p.InvoiceDate,
	  k.InvoiceAmount=p.InvoiceAmount,
	  k.Currency=p.Currency,
	  k.InvoiceRecordedBy=@p_ModifiedBy,
	  k.InvoiceRecordedOn=CURRENT_TIMESTAMP
	 from [LabWork_Order] k 
	 inner join @p_penType p on k.Id=p.LabWorkId
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

if @p_SUB_OPERTION_TYPE='RECIE' and @p_OPERTION_TYPE='SEL'
begin
   select 
  ORD.OrderNo as [Order No.],
  ORD.VisitId as [Visit No.],
   pd.FirstName+ ' ' +pd.LastName as Patient,
  LWF.WorkName as Work,
  SD.Name as Supplier,
  ORD.OrderRecievedDate,
  ORD.InvoiceNo as [Invoice No.],
  ORD.InvoiceAmount as [Invoice Amount]
 from LabWork_Order ORD 
   inner join PatientVisitDetails PV on PV.Id=ORD.VisitId
   inner join Patient_Details PD on PD.Id=PV.PatientId
   inner join Lab_Works_Mf LWF on LWF.Id=ORD.WorkId
   inner join SupplierDetails SD on ORD.SupplierId=sd.Id
   where InvoiceNo is not null
end
end 	
 GO



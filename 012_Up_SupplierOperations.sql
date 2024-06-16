use [DHCM]
/****** Object:  StoredProcedure [dbo].[Up_AccountsOperations]    Script Date: 14-07-2020 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_SupplierOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].Up_SupplierOperations
Go 
CREATE procedure [dbo].Up_SupplierOperations
@p_OPERTION_TYPE varchar(5) =null,
@p_supId int  =null,
@p_Name VARCHAR(64)  =NULL,
@p_Phone varchar(15) =NULL,
@p_Email varchar(50) =null, 
@p_TIR varchar(50) =null, 
@p_FullAddress varchar(64)  =NULL,
@p_ContactPersonName VARCHAR(64)  =NULL,
@p_ContactPersonPh varchar(15) = NULL, 
@p_ModifiedBy int=null,
@p_type SupplierTypeDetailsTyp  readonly,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin

if @p_OPERTION_TYPE='INVLT'
begin
  select 
      Name,
	  Id,
	  case when (select COUNT(Id) from SupplierDetailsTypes where SupplierId=@p_supId and InventoryGroupId=inv.Id)>0 then 'T' else 'F' end as [Status]
  from 
  InventoryGroup_Mf inv
  

end

if @p_OPERTION_TYPE='SEL'
begin
  select ID,
		 Name,
		 Phone,
		 Email,
		 TIR,
		 FullAddress as [Address],
		 ContactPersonName as [Contact Person],
		 ContactPersonPh as [Contact Person Mob]
   from SupplierDetails
end

if @p_OPERTION_TYPE='INS' 
	begin
	 BEGIN TRY
	  begin transaction
	  declare @supplierId int=0
	  select @supplierId=Next value for SupplierDetails_SEQ
	  insert into [SupplierDetails]
	  (
	  Id,
	  Name,
	  Phone,
	  Email,
	  TIR,
	  FullAddress,
	  ContactPersonName,
	  ContactPersonPh,
	  ModifiedBy,
	  ModifiedOn
		)
	  values
	  (@supplierId,
	  @p_Name,
	  @p_Phone,
	  @p_Email,
	  @p_TIR,
	  @p_FullAddress,
	  @p_ContactPersonName,
	  @p_ContactPersonPh,
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP
	 )
	  insert into SupplierDetailsTypes
	  (
	   SupplierId,
	   InventoryGroupId,
	   ModifiedBy,
	   ModifiedOn
	  )
	  select 
	  @supplierId,
	  InventoryGroupId,
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP
	  from @p_type p

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

if @p_OPERTION_TYPE='UPD' 
begin
	 BEGIN TRY
	  begin transaction
      update [SupplierDetails]
	  set 
	    Name=@p_Name,
		Phone=@p_Phone,
		Email=@p_Email,
		TIR=@p_TIR,
		FullAddress=@p_FullAddress,
		ContactPersonName=@p_ContactPersonName,
		ContactPersonPh=@p_ContactPersonPh,
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP
		where Id=@p_supId
	  delete from SupplierDetailsTypes where SupplierId=@p_supId
	  insert into SupplierDetailsTypes
	  (
	   SupplierId,
	   InventoryGroupId,
	   ModifiedBy,
	   ModifiedOn
	  )
	  select 
	  @p_supId,
	  InventoryGroupId,
	  @p_ModifiedBy,
	  CURRENT_TIMESTAMP
	  from @p_type p

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

if @p_OPERTION_TYPE='DEL' 
begin
	 BEGIN TRY
	  begin transaction

	  delete from SupplierDetailsTypes where SupplierId=@p_supId
	  delete from [SupplierDetails] where Id=@p_supId

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
   end 	
 GO



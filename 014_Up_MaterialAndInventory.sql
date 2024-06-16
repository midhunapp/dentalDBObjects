use [DHCM]
/****** Object:  StoredProcedure [dbo].[MaterialAndInventory]    Script Date: 14-07-2020 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_MaterialAndInventory]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].Up_MaterialAndInventory
Go 
CREATE procedure [dbo].Up_MaterialAndInventory
@p_OPERTION_TYPE varchar(5) =null,
@p_SUB_OPERTION_TYPE varchar(5) =null,
@p_Id int  =null,
@p_Name VARCHAR(64)  =NULL,
@p_code VARCHAR(64)  =NULL,
@p_matType int =NULL,
@p_hdId int  =null,
@p_unitId int  =null,
@p_weight numeric(11,2)  =null,
@p_MeasurementUnit varchar(10) =null,
@p_qty numeric(11,2)  =null,
@p_ModifiedBy int=null,
@p_addNew char(1)  ='N',
@p_purchaseDate date  =null,
@p_InvoiceNo VARCHAR(50)  =NULL,
@p_invPurchaseType Inventory_PurchaseTyp readonly,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin

if @p_OPERTION_TYPE='MAST' and @p_SUB_OPERTION_TYPE='SEL'
begin

 select HD.Id,HD.Name,MF.Name as [Type],MF.Id as TypeId from Inventory_Details_Hd HD inner join InventoryGroup_Mf MF on HD.InventoryGroupId=MF.Id
 where (MF.Id=@p_matType or @p_matType=0)
end

if  @p_OPERTION_TYPE='MAST' and @p_SUB_OPERTION_TYPE='INS'
	begin
	 BEGIN TRY
	   if(select COunt(Id) from Inventory_Details_Hd where Name=@p_Name and InventoryGroupId=@p_matType)>0
	   begin
	     SET @responseMessage=@p_Name + ' already exists.'
		 set @status='0'
		 return
	  end 
	  begin transaction
	  insert into Inventory_Details_Hd
	  (
	  Name,
	  InventoryGroupId,
	  ModifiedBy,
	  ModifiedOn
		)
	  values
	  (@p_Name,
	  @p_matType,
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

if @p_OPERTION_TYPE='MAST' and @p_SUB_OPERTION_TYPE='UPD'
begin
	 BEGIN TRY
	   if(select COunt(Id) from Inventory_Details_Hd where Name=@p_Name and InventoryGroupId=@p_matType and Id<>@p_Id)>0
	   begin
	     SET @responseMessage=@p_Name + ' already exists.'
		 set @status='0'
		 return
	  end 

	  begin transaction
      update Inventory_Details_Hd
	  set 
	    Name=@p_Name,
		InventoryGroupId=@p_matType,
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP
		where Id=@p_Id

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

if @p_OPERTION_TYPE='MAST' and @p_SUB_OPERTION_TYPE='DEL'
begin
	 BEGIN TRY
	  begin transaction

	     delete from Inventory_Details_Hd where Id=@p_Id

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



if @p_OPERTION_TYPE='UNIT' and @p_SUB_OPERTION_TYPE='SEL'
begin

 select Id,Name,Code from Units_Mf 
end

if  @p_OPERTION_TYPE='UNIT' and @p_SUB_OPERTION_TYPE='INS'
	begin
	 BEGIN TRY
	   if(select COunt(Id) from Units_Mf where Name=@p_Name or Code=@p_code)>0
	   begin
	     SET @responseMessage=@p_Name + ' or '+ @p_code+ ' already exists.'
		 set @status='0'
		 return
	  end 
	  begin transaction
	  insert into Units_Mf
	  (
	  Name,
	  Code,
	  ModifiedBy,
	  ModifiedOn
		)
	  values
	  (@p_Name,
	  @p_code,
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

if @p_OPERTION_TYPE='UNIT' and @p_SUB_OPERTION_TYPE='UPD'
begin
	 BEGIN TRY
	   if(select COunt(Id) from Units_Mf where (Name=@p_Name or Code=@p_code) and Id<>@p_Id)>0
	   begin
	     SET @responseMessage=@p_Name + ' or '+ @p_code+ ' already exists.'
		 set @status='0'
		 return
	  end 

	  begin transaction
      update Units_Mf
	  set 
	    Name=@p_Name,
		Code=@p_code,
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP
		where Id=@p_Id

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

if @p_OPERTION_TYPE='UNIT' and @p_SUB_OPERTION_TYPE='DEL'
begin
	 BEGIN TRY
	  begin transaction

	     delete from Units_Mf where Id=@p_Id

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

if @p_OPERTION_TYPE='ITEM' and @p_SUB_OPERTION_TYPE='SEL'
begin

 select 
     DT.Id,
	 DT.Inventory_HdId,
	 DT.UnitId,
	 DT.BrandName as [Brand],
	 HD.Name as [Inventory Name],
	 UMF.Code as [Unit],
	 DT.WtPerUnit as [Weight],
	 DT.MeasurementUnit as [Measurement],
	 DT.Qty as Quantity
   from Inventory_Details_DT DT inner join [Inventory_Details_Hd] HD on DT.Inventory_HdId=HD.ID
				inner join Units_Mf UMF on UMF.ID=DT.UnitId
end

if  @p_OPERTION_TYPE='ITEM' and @p_SUB_OPERTION_TYPE='INS'
begin
	 BEGIN TRY
	   if(select COunt(Id) from Inventory_Details_DT where BrandName=@p_Name)>0
	   begin
	     SET @responseMessage=@p_Name +  ' already exists.'
		 set @status='0'
		 return
	  end 
	  begin transaction
	  insert into Inventory_Details_DT
	  (
		Inventory_HdId,
		BrandName,
		UnitId,
		WtPerUnit,
		MeasurementUnit,
		Qty,
		ModifiedBy,
		ModifiedOn
		)
	  values
	  ( 
		@p_hdId,
		@p_Name,
		@p_unitId,
	    @p_weight,
		@p_MeasurementUnit,
		@p_qty,
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

if @p_OPERTION_TYPE='ITEM' and @p_SUB_OPERTION_TYPE='UPD'
begin
	 BEGIN TRY
	   if(select COunt(Id) from Inventory_Details_DT where BrandName=@p_Name  and Id<>@p_Id)>0
	   begin
	     SET @responseMessage=@p_Name +' already exists.'
		 set @status='0'
		 return
	  end 

	  begin transaction
      update Inventory_Details_DT
	  set 
	    Inventory_HdId=@p_hdId,
		BrandName=@p_Name,
		UnitId=@p_unitId,
		WtPerUnit=@p_weight,
		MeasurementUnit=@p_MeasurementUnit,
		Qty=@p_qty,
		ModifiedBy=@p_ModifiedBy,
		ModifiedOn=CURRENT_TIMESTAMP
		where Id=@p_Id

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

if @p_OPERTION_TYPE='ITEM' and @p_SUB_OPERTION_TYPE='DEL'
begin
	 BEGIN TRY
	  begin transaction

	     delete from Inventory_Details_DT where Id=@p_Id

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

if @p_OPERTION_TYPE='PURCH' and @p_SUB_OPERTION_TYPE='SEL'
begin

 select 
       PUR.SupplierId as supplierId,
	   SD.Name as [Supplier],
	   PUR.InvoiceNo as [Invoice No.],
	   PUR.DateOfPurchase as [Date],
	   sum(Total) as Total,
	   'View & Edit' as ' '
  from [Inventory_Purchase] PUR inner join [SupplierDetails] SD on SD.Id=PUR.SupplierId 
  group by PUR.SupplierId,PUR.InvoiceNo,PUR.DateOfPurchase,SD.Name 

end

if @p_OPERTION_TYPE='PURCH' and @p_SUB_OPERTION_TYPE='SEL2'
begin

 select 
		PUR.Inventory_DTId,
		PUR.Qty,
		PUR.Rate,
		PUR.Total,
		PUR.ExpDate,
		PUR.Id
       from
	  Inventory_Purchase PUR
	  where PUR.SupplierId=@p_Id and PUR.InvoiceNo=@p_InvoiceNo and PUR.DateOfPurchase=@p_purchaseDate


end

if @p_OPERTION_TYPE='PURCH' and @p_SUB_OPERTION_TYPE='INS'
begin
  BEGIN TRY
	  begin transaction

	    insert into [Inventory_Purchase]
		(
		  SupplierId,
		  DateOfPurchase,
		  InvoiceNo,
		  Inventory_DTId,
		  Rate,
		  Qty,
		  Total,
		  Currency,
		  ExpDate,
		  ModifiedBy,
		  ModifiedOn
		)
		select 
		  SupplierId,
		  DateOfPurchase,
		  InvoiceNo,
		  Inventory_DTId,
		  Rate,
		  Qty,
		  Total,
		  Currency,
		  ExpDate,
		  @p_ModifiedBy,
		  CURRENT_TIMESTAMP
		   from @p_invPurchaseType

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

if @p_OPERTION_TYPE='PURCH' and @p_SUB_OPERTION_TYPE='UPD'
begin
  BEGIN TRY
	  begin transaction

	    update k
		set
		  k.SupplierId=SupplierId,
		  k.DateOfPurchase=p.DateOfPurchase,
		  k.InvoiceNo=p.InvoiceNo,
		  k.Inventory_DTId=p.Inventory_DTId,
		  k.Rate=p.Rate,
		  k.Qty=p.Qty,
		  k.Total=p.Total,
		  k.Currency=p.Currency,
		  k.ExpDate=p.ExpDate,
		  k.ModifiedBy=p.ModifiedBy,
		  k.ModifiedOn=CURRENT_TIMESTAMP
		from [Inventory_Purchase] k inner join p_invPurchaseType p on k.Id=p.Id
		

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

if @p_OPERTION_TYPE='PURCH' and @p_SUB_OPERTION_TYPE='DEL'
begin
  BEGIN TRY
	  begin transaction

		delete from [Inventory_Purchase]  where Id=@p_Id
		

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



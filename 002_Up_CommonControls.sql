Use [DHCM]

/****** Object:  StoredProcedure [dbo].[DAH_User_Insert]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_CommonControls]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_CommonControls]
Go 
CREATE procedure [dbo].[Up_CommonControls]
@p_OPERTION_TYPE varchar(5)  null,
@p_tableName varchar(20)= null,
@p_keyColumn varchar(15)= null,
@p_valueColumn varchar(15) =null
as
begin

    if @p_OPERTION_TYPE='NATDD'
	BEGIN
    BEGIN TRY
       Select Id as Id,NationalityName as [Name] from dbo.[Nationality_Mf]
    END TRY
    BEGIN CATCH
       
    END CATCH

END

    if @p_OPERTION_TYPE='SEL'
	BEGIN
    BEGIN TRY
       declare @sqlQuery varchar(200)
       set @sqlQuery='Select '+@p_keyColumn+' as keyCol,'+@p_valueColumn+' as ValueCol from '+@p_tableName
       EXECUTE (@sqlQuery) 
    END TRY
    BEGIN CATCH

    END CATCH

END

    if @p_OPERTION_TYPE='DRDD'
	BEGIN
    BEGIN TRY
       Select Id as keyCol,FirstName + LastName  as ValueCol from dbo.[User] where UserType='DR'
    END TRY
    BEGIN CATCH
       
    END CATCH

END
    if @p_OPERTION_TYPE='DSDD'
	BEGIN
    BEGIN TRY
       Select Id as keyCol,DiagnosisName+'('+DiagnosisCode+')'   as ValueCol from Diagnosis_Mf 
    END TRY
    BEGIN CATCH
       
    END CATCH

END
 if @p_OPERTION_TYPE='MCDD'
	BEGIN
    BEGIN TRY
       Select Id as keyCol,
	   CASE
	   WHEN ComponentType = 'Ded' THEN 'D' + '-' + ComponentName
	   else 'E' + '-' + ComponentName
	   END AS ValueCol from dbo.[EarDedComponents_Mf] 
    END TRY
    BEGIN CATCH
       
    END CATCH
	END

	 if @p_OPERTION_TYPE='LABDD'
	BEGIN
    BEGIN TRY
       Select sd.Id as keyCol,sd.Name  as ValueCol from SupplierDetails sd where 
	      sd.Id in (select SDT.SupplierId from SupplierDetailsTypes SDT inner join InventoryGroup_Mf INV on INV.Id=SDT.InventoryGroupId where INV.IsInvenoryGroup='N')
    END TRY
    BEGIN CATCH
       
    END CATCH

END
     if @p_OPERTION_TYPE='TRDD'
	BEGIN
    BEGIN TRY
	  Select Id as keyCol,TreatmentName   as ValueCol from [Treatments_Mf] where TreatmentCode not in ('CONSULT','XRAY')
    END TRY
    BEGIN CATCH
       
    END CATCH

END

   if @p_OPERTION_TYPE='MATDD'
	BEGIN
    BEGIN TRY
	  Select Id as keyCol,Name   as ValueCol from InventoryGroup_Mf where IsInvenoryGroup ='Y'
    END TRY
    BEGIN CATCH
       
    END CATCH

END

    if @p_OPERTION_TYPE='SUPDD'
	BEGIN
    BEGIN TRY
       Select sd.Id as keyCol,sd.Name  as ValueCol from SupplierDetails sd where 
	      sd.Id in (select SDT.SupplierId from SupplierDetailsTypes SDT inner join InventoryGroup_Mf INV on INV.Id=SDT.InventoryGroupId where INV.IsInvenoryGroup='Y')
    END TRY
    BEGIN CATCH
       
    END CATCH

    END
end
GO
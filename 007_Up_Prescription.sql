Use [DHCM]

/****** Object:  StoredProcedure [dbo].[Up_PatientsVisitOperations]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_Prescription]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_Prescription]
Go 
CREATE procedure [dbo].[Up_Prescription]
@p_OPERTION_TYPE varchar(5) =null,
@p_ModifiedBy int=null,
@p_visitId int=null,
@p_type PrescriptionsTyp readonly,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin

if @p_OPERTION_TYPE='SEL'
begin
 
  select 
     case when md.Id=-1 then pr.OtherMedicine else md.MedicienName end as Medicine,
	 md.Id as MedicineId,
	 pr.Dose,
	 pr.Days,
	 pr.Times,
	 pr.Id,
	 pr.VisitId
  from 
  [dbo].[Prescriptions] pr
  left join [Medicines_Mf] md on pr.MedicineId=md.Id
  where pr.VisitId=@p_visitId

end
if @p_OPERTION_TYPE='INS'
begin
 BEGIN TRY
 --select top 1 @responseMessage=VisitId from @p_type
 --SET @status='0'
   Begin transaction
   delete from Prescriptions where VisitId=@p_visitId
   insert into Prescriptions (
	MedicineId,
	Dose,
	Days,
	Times,
	OtherMedicine,
	VisitId,
	ModifiedBy,
	ModifiedOn
   )
   select 
     MedicineId,
	 Dose,
	 Days,
	Times,
	OtherMedicine,
	@p_visitId,
	@p_ModifiedBy,
	CURRENT_TIMESTAMP
   from @p_type
    commit  
    SET @responseMessage='Success'
	SET @status='1'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
		SET @status='0'
		rollback 
    END CATCH
end
end
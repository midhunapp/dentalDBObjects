
use [DHCM]
/****** Object:  StoredProcedure [dbo].[Up_LabWorksOperations]    Script Date: 14-07-2020 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[Uf_BalanceCalculation]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
  DROP FUNCTION [dbo].[Uf_BalanceCalculation]

GO 
CREATE FUNCTION [dbo].[Uf_BalanceCalculation]
(    
      @visitId int,
	  @patientId int
)
RETURNS @Output TABLE (
    PatientId int,
    BalanceFromPrevious numeric(11,2),
	Amount  numeric(11,2),
	Discount numeric(11,2),
	TotalToPay  numeric(11,2),
	AmountRecieved numeric(11,2),
	BalanceToPay numeric(11,2)
)
AS
BEGIN
       if(select count(*) from [PatientInvoiceRecords] where VIsitId=@visitId)=0
	   begin
         declare @treatmentsSum numeric(11,2)=0
         select @treatmentsSum=sum(Amount)  from PatientTreatments PT 
		 inner join Treatments_Mf T on PT.TreatmentId=T.Id
	     where PT.VisitId=@visitId group by T.Id,T.TreatmentName
	   
	     select @treatmentsSum=@treatmentsSum+Amount from Treatments_Mf where TreatmentCode='XRAY'
	     and (select count(Id) from PatientCaseSheetAttachments where VisitId=@visitId)>0
	     and (select count(Id) from [PatientInvoiceRecords] where VisitId=@visitId) =0
		
		 select  @treatmentsSum=@treatmentsSum+Amount from Treatments_Mf where TreatmentCode='CONSULT'
         
          
		 insert into @Output
		 select top 1
				@patientId,
			    BalanceCF as BalanceFromPrevious,
			    isnull(@treatmentsSum,0),
				0 as Discount,
				BalanceCF +isnull(@treatmentsSum,0),
				0 as AmountRecieved,
				BalanceCF +isnull(@treatmentsSum,0)
	         from PatientInvoiceRecords INV 
	         Inner join PatientVisitDetails PV on PV.ID=INV.VisitId 
			 where PV.PatientId=@patientId and INV.PaidStatus='Y' 
			 order BY ISNULL(PaidOn,'1990-01-01') desc

	    if(select count(*) from @Output)=0
		  insert into @Output values(@patientId,0,isnull(@treatmentsSum,0),0,isnull(@treatmentsSum,0),0,isnull(@treatmentsSum,0))
      end
	  else
	  begin
	     insert into @Output
		 select
		    @patientId,
			inv.BalanceBF,
			inv.Amount,
			inv.Discount,
			ISNULL(inv.BalanceBF,0)+ISNULL(inv.Amount,0)-ISNULL(inv.Discount,0),
			ISNULL(inv.AmountRecieved,0),
			inv.BalanceCF 
		  from 

		 [PatientInvoiceRecords] inv where inv.VIsitId=@visitId
	  end
	  
	  RETURN
END
GO
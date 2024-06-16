use [DHCM]
/****** Object:  StoredProcedure [dbo].[Up_AccountsOperations]    Script Date: 14-07-2020 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_AccountsOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].Up_AccountsOperations
Go 
CREATE procedure [dbo].Up_AccountsOperations

@p_ComponentName varchar(64)  =null,
@p_ComponentCode varchar(10)  =NULL,
@p_ComponentType varchar(3)  =null,
@p_ModifiedBy int=null,
@p_OPERTION_TYPE varchar(5) =null,
@p_id int=null,
@p_Dates date =null,
@p_ComponentId int=null,
@p_Amount numeric(11,2) = null,
@p_Period varchar(6) = null,
@p_type MonthlyEarningDeductionTyp  readonly,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin
--dummy checkin
    
	if @p_OPERTION_TYPE='INS'
	begin
	SET NOCOUNT ON
	BEGIN TRY
	if (select count(Id) from [EarDedComponents_Mf] where (ComponentName=@p_ComponentName or ComponentCode =@p_ComponentCode) and ComponentType=@p_ComponentType)>0
	begin
	    SET @responseMessage='Same Component Exists'
        SET @status='0'
		return
	end
        INSERT INTO dbo.[EarDedComponents_Mf]
                        (   
						   
                            ComponentName, 
                            ComponentCode, 
                            ComponentType, 
                            ModifiedBy,
                            ModifiedOn,
                            IsActive
                            )
                     VALUES
                        (
                           @p_ComponentName,
                           @p_ComponentCode,
                           @p_ComponentType,
                           @p_ModifiedBy,
                           current_timestamp,
						   1
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
	SET NOCOUNT ON
	BEGIN TRY
	if @p_ComponentType = 'Ear'
	begin
	SELECT Id,ComponentName,Componentcode,ComponentType from dbo.[EarDedComponents_Mf] where ComponentType='Ear'
	end
	else if @p_ComponentType = 'Ded'
	begin
	SELECT Id,ComponentName,Componentcode,ComponentType from dbo.[EarDedComponents_Mf] where ComponentType='Ded'
	end
	else
	begin
	SELECT Id,ComponentName,Componentcode,ComponentType from dbo.[EarDedComponents_Mf]
	end

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
	if (select count(Id) from MonthlyEarningDeduction where ComponentId=@p_id) >0
	 begin
	    set @status='0'
        SET @responseMessage='This component already in use.Could not delete it'
		return
	 end
        delete  from dbo.EarDedComponents_Mf where Id=@p_id
					
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END

    if @p_OPERTION_TYPE='UPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY	

        Update dbo.[EarDedComponents_Mf] 
					set ComponentName=@p_ComponentName, 
					ComponentType=@p_ComponentType,
					ComponentCode=@p_ComponentCode,
					ModifiedBy=@p_ModifiedBy,
					ModifiedOn=CURRENT_TIMESTAMP,
					IsActive=1
					where Id=@p_id
        
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='ADD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        INSERT INTO dbo.[MonthlyEarningDeduction]
		  (   
						   
                            Dates, 
                            ComponentId, 
                            Amount, 
                            Period,
                            ModifiedBy,
                            ModifiedOn
                            )
							select
							 Dates, 
                            ComponentId, 
                            Amount, 
                            Period,
							@p_ModifiedBy,
							current_timestamp
							from @p_type where Id=0

         --            VALUES
         --               (
						   --@p_Dates,
         --                  @p_ComponentId,
         --                  @p_Amount,
         --                  @p_Period,
         --                  @p_ModifiedBy,
         --                  current_timestamp
						   
         --                  )
					
        
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='REM'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        delete  from dbo.MonthlyEarningDeduction where Id=@p_id
					
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END

    if @p_OPERTION_TYPE='EDIT'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY	
                    Update  MF
					set Mf.ComponentId=p.ComponentId, 
					mf.Dates=p.Dates,
					mf.Amount=p.Amount,
					ModifiedBy=@p_ModifiedBy,
					ModifiedOn=CURRENT_TIMESTAMP
					from 
					dbo.MonthlyEarningDeduction MF inner join @p_type P on P.Id=Mf.Id

		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='VIEW'
	begin
	SET NOCOUNT ON
	BEGIN TRY
	select m.Id, m.Dates,SUBSTRING(e.ComponentType,1,1)+'-'+e.ComponentName as ComponentName,m.Amount ,m.ComponentId from dbo.MonthlyEarningDeduction as m
    inner join dbo.EarDedComponents_Mf as e
    on m.ComponentId = e.Id
	where m.Period = @p_Period

	    SET @responseMessage='Success'
        SET @status='1'
    END TRY
	BEGIN CATCH
	  --SET @responseMessage='Exception'
	    SET @status='0'
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH
	end

   end 	
 GO



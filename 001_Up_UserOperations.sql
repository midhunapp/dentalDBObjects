Use [DHCM]

/****** Object:  StoredProcedure [dbo].[DAH_User_Insert]    Script Date: 23-04-2017 00:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECTPROPERTY(object_id('[dbo].[Up_UserOperations]'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[Up_UserOperations]
Go 
CREATE procedure [dbo].[Up_UserOperations]
@p_OPERTION_TYPE varchar(5) =null,
@p_LoginName varchar(15)  =null,
@p_Password varchar(15)  =NULL,
@p_FirstName varchar(20)  =null,
@p_LastName varchar(20)  =null,
@p_UserType varchar(3)=null,
@p_RoleId int=null,
@p_id int=null,
@p_phone varchar(15)=null,
@p_moh varchar(10)=null,
@p_ModifiedBy int=null,
@p_specialization varchar(20)=null,
@p_designation varchar(30)=null,
@p_email varchar(20)=null,
@p_gender char(1)=null,
@p_dob date=null,
@p_type UserRoles READONLY  ,
@responseMessage varchar(200)=null OUTPUT,
@status char(1)='0' OUTPUT
as
begin
	if @p_OPERTION_TYPE='LOGIN'
	begin
	  declare @userid int=null
	  select @userid=Id from dbo.[User] a where a.LoginName=@p_LoginName and a.PasswordHash=HASHBYTES('SHA2_512', @p_Password) 
	  select 
      a.*,c.RoleCode,c.RoleName from dbo.[User] a 
      inner join dbo.[User_Roles] b on b.UserId=a.Id
	  inner join dbo.Roles_Mf c on c.Id=b.RoleId
      where a.Id=@userid and b.RoleId=@p_RoleId

	  select RoleCode,RoleName from [User_Roles] b 
	  inner join dbo.Roles_Mf c on c.Id=b.RoleId
	  where b.UserId=@userid

	end

    
    if @p_OPERTION_TYPE='INS'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        INSERT INTO dbo.[User] 
		(
		--LoginName, 
		--PasswordHash, 
		FirstName, 
		LastName,
		UserType,
		IsActive,
		Phone,
		Moh,
		Specialization,
		Designation,
		Gender,
		DOB,
		Email
		)
        VALUES(
		--@p_LoginName, 
		--HASHBYTES('SHA2_512', @p_Password), 
		@p_FirstName, 
		@p_LastName,
		@p_UserType,
		1,
		@p_phone,
		@p_moh,
		@p_specialization,
		@p_designation,
		@p_gender,
		@p_dob,
		@p_email
		)

        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END

    if @p_OPERTION_TYPE='UPD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        Update dbo.[User] 
					set --LoginName=@p_LoginName, 
					--PasswordHash=HASHBYTES('SHA2_512', @p_Password), 
					FirstName=@p_FirstName,
					LastName=@p_LastName,
					UserType=@p_UserType,
					IsActive=1,
					Phone=@p_phone,
					Moh=@p_moh,
					Email=@p_email,
					Designation=@p_designation,
					Specialization=@p_specialization,
					dob=@p_dob,
					Gender=@p_gender
					where Id=@p_id
        
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='DEL'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        delete  from dbo.[User] where Id=@p_id
					
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END

    if @p_OPERTION_TYPE='SEL'
	begin
	if(@p_UserType='ALL')
	begin
	  select 
	        a.FirstName,
			a.LastName,
			a.LoginName,
			a.UserType as [Type Of User],
			a.UserType ,
			a.Id ,
			a.Email,
			a.Phone,
			a.Moh,
			a.Designation,
			a.Specialization,
			a.Gender,
			a.dob
	   from dbo.[User] a
	    where a.UserType<>'DR'
	  end
	  else
	  begin
	  select 
	        a.FirstName,
			a.LastName,
			a.LoginName,
			a.UserType as [Type Of User],
			a.UserType ,
			a.Id ,
			a.Email,
			a.Phone,
			a.Moh,
			a.Designation,
			a.Specialization,
			a.Gender,
			a.dob
	   from dbo.[User] a
	   where a.UserType='DR'
	  end
	end
    

    if @p_OPERTION_TYPE='NATDD'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       Select Id as Id,NationalityName as [Name] from dbo.[Nationality_Mf]
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='SELRL'
	begin
	   select 
	        a.FirstName + ' '+ a.LastName as [UserName],
			a.UserType as [Type Of User],
			a.Id as UserId
	   from dbo.[User] a
	   select 
	        a.RoleName ,
			a.Id as RoleId
	   from dbo.Roles_Mf a
	   select 
	        a.RoleId ,
			a.UserId ,
			b.RoleName
	   from dbo.User_Roles a
	   inner join dbo.Roles_Mf b on b.Id=a.RoleId
	end

	if @p_OPERTION_TYPE='INSRL'
	begin
	BEGIN TRY
	  delete from User_Roles where UserId in (select UserId from @p_type)
	  insert into User_Roles
	  (UserId,RoleId,ModifiedBy,ModifiedOn)
	  select 
			p.UserId,
			(select Id from Roles_Mf where RoleName=p.RoleName),
			@p_ModifiedBy,
			CURRENT_TIMESTAMP
			RoleName from @p_type p
		set @status='1'
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end

	if @p_OPERTION_TYPE='CRED'
	BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        Update dbo.[User] 
					set LoginName=@p_LoginName, 
					PasswordHash=HASHBYTES('SHA2_512', @p_Password) 
					where Id=@p_id
        
		set @status='1'
        SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
		set @status='0'
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
	end
END


GO
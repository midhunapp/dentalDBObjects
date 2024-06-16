CREATE DATABASE DHCM;
GO

USE [DHCM]

/****** Object:  Table [dbo].[User]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[User]
(
    Id INT IDENTITY(1,1) NOT NULL,
    LoginName NVARCHAR(10)  NULL,
    PasswordHash BINARY(64)  NULL,
    FirstName NVARCHAR(20) NULL,
    LastName NVARCHAR(20) NULL,
	Gender char(1)  null,
	DOB date  null,
	Specialization varchar(20) null,
	Designation varchar(30) null,
	Email varchar(50) null, 
	Phone varchar(15) NULL,
	Moh VARCHAR(20) NULL,
    UserType varchar(3),
	IsActive BIT,
    CONSTRAINT [PK_User_Id] PRIMARY KEY CLUSTERED (Id ASC)
)

GO

/****** Object:  Table [dbo].[Roles_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[Roles_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    RoleName VARCHAR(10) NOT NULL,
    RoleCode VARCHAR(3) NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_Roles_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC)
)

GO

/****** Object:  Table [dbo].[User_Roles]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[User_Roles]
(
    Id INT IDENTITY(1,1) NOT NULL,
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_User_Roles_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_User_Roles_Roles_Mf_RoleId FOREIGN KEY (RoleId) REFERENCES dbo.[Roles_Mf] (Id),
    CONSTRAINT FK_User_Roles_User_UserId FOREIGN KEY (UserId) REFERENCES dbo.[User] (Id) ,
    CONSTRAINT FK_User_Roles_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO




/****** Object:  Table [dbo].[Nationality_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[Nationality_Mf]
(
    Id INT  NOT NULL,
    NationalityCode varchar(5) NOT NULL,
    NationalityName varchar(64) NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_Nationality_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC)
   )

GO


/****** Object:  Table [dbo].[Patient_Details]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[Patient_Details]
(
    Id INT IDENTITY(1,1) NOT NULL,
    FirstName varchar(20) Not NUll,
    LastName varchar(20) Not null,
    DOB date Not null,
    Mobile varchar(15) not null,
    EID nvarchar(20) not null,
    EmailId nvarchar(50)  null,
    FullAddress varchar(64)  NULL,
	Emirates varchar(25)  NULL,
    Gender char(1) NOT NULL,
    NationalityId int not null, 
    IdProof varbinary(8000) null,
	RegDate datetime not null,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_Patient_Details_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Patient_Details_Nationality_Mf_NationalityId FOREIGN KEY (NationalityId) REFERENCES dbo.[Nationality_Mf] (Id),
    CONSTRAINT FK_Patient_Details_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO






/****** Object:  Table [dbo].[PatientVisitDetails]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[PatientVisitDetails]
(
    Id INT IDENTITY(1,1) NOT NULL,
    PatientId int NOT NULL,
    DateOfVisit DateTime NOT NULL,
    DoctorId int Not NULL,
	IsOpen bit Not null,
	EndTime DateTime null,
	ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
    CONSTRAINT [PK_PatientVisitDetails_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_PatientVisitDetails_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_PatientVisitDetails_User_DoctorId FOREIGN KEY (DoctorId) REFERENCES dbo.[User] (Id)
)

GO




/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE dbo.[Treatments_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    TreatmentName varchar(64) NOT NULL,
	TreatmentCode varchar(10) NOT NULL,
    Amount numeric(11,2)  NUll,
    Currency varchar(5) Not NUll,
	IsLabWorkIncluded char(1) NULL DEFAULT 'N',
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_Treatments_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Treatments_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO


/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[DbBackupDetails](  
    Id INT IDENTITY(1,1) NOT NULL,  
    BackupName [varchar](50) NULL,  
    Location [varchar](200) NULL,  
    BackupDate [datetime] NULL,  
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_DbBackupDetails_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_DbBackupDetails_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
) 

GO


/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE dbo.[Diagnosis_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    DiagnosisName varchar(100) NOT NULL,
	DiagnosisCode varchar(10) NOT NULL,
	DiagnosisDes varchar(150)  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
	IsActive BIT,
    CONSTRAINT [PK_Diagnosis_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Diagnosis_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO


/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE dbo.[SysIllnessAndChiefComplaints_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    Name varchar(200) NOT NULL,
	EntryType varchar(10) NOT NULL, -- should be 'SYS','CHIEFCOMP',
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
	IsActive BIT,
    CONSTRAINT [PK_SysIllnessAndChiefComplaints_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_SysIllnessAndChiefComplaints_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO


/****** Object:  Table [dbo].[PatientCaseSheet]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE [dbo].[PatientCaseSheet](  
    Id INT IDENTITY(1,1) NOT NULL,  
    VisitId int NULL,  
	ChiefComplaintId int NULL,
	PastHistory varchar(200) NULL, 
	PlanOfCare varchar(200) NULL, 
	OtherSysIllness varchar(200) NULL, 
    DiagnosisId int  null,  
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_PatientCaseSheet_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientCaseSheet_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
) 

GO






/****** Object:  Table [dbo].[PatientCaseSheet]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[PatientCaseSheetSystemicIllNess](  
    Id INT IDENTITY(1,1) NOT NULL,  
    VisitId int NULL,  
    SysId int not null, 
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_PatientCaseSheetSystemicIllNess_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientCaseSheetSystemicIllNess_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_PatientCaseSheetSystemicIllNess_SysIllnessAndChiefComplaints_Mf_SysId FOREIGN KEY (SysId) REFERENCES dbo.[SysIllnessAndChiefComplaints_Mf] (Id)
) 

GO




/****** Object:  Table [dbo].[PatientCaseSheet]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[PatientTreatments](  
    Id INT IDENTITY(1,1) NOT NULL,  
    VisitId int NULL, 
	Teeth varchar(5) NULL, 
    TreatmentId int not null, 
	IsPediatric char(1) NULL,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_PatientTreatments_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientTreatments_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_PatientTreatments_Treatments_Mf_TreatmentId FOREIGN KEY (TreatmentId) REFERENCES dbo.[Treatments_Mf] (Id)
) 

GO



/****** Object:  Table [dbo].[PatientCaseSheetAttachments]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[PatientCaseSheetAttachments](  
    Id INT IDENTITY(1,1) NOT NULL,  
    VisitId int NULL, 
	Attachments varbinary(Max) null, 
	Name varchar(30) null, 
    [Description] varchar(100) null, 
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_PatientCaseSheetAttachments_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientCaseSheetAttachments_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
) 

GO


/****** Object:  Table [dbo].[Medicines_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE dbo.[Medicines_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    MedicienName varchar(100) NOT NULL,
	AdditionalInfo varchar(100)  NULL,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	IsActive BIT,
    CONSTRAINT [PK_Medicines_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Medicines_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO



/****** Object:  Table [dbo].[Prescriptions]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[Prescriptions](  
    Id INT IDENTITY(1,1) NOT NULL,  
    VisitId int NULL, 
	MedicineId int not null,
	OtherMedicine varchar(50) null,
	Remarks varchar(5) null,
	Dose numeric(11,2) not null,
	Days int not null,
	Times int not null,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_Prescriptions_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Prescriptions_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_Prescriptions_Medicines_Mf_MedicineId FOREIGN KEY (MedicineId) REFERENCES dbo.[Medicines_Mf] (Id)
) 

GO

/****** Object:  Table [dbo].[User]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[CinicDetails]
(
    Id INT IDENTITY(1,1) NOT NULL,
    ClinicName VARCHAR(64) NOT NULL,
    ClinicAddress VARCHAR(64) NOT NULL,
    PhoneNumber varchar(15) NULL,
	ReportHeader varbinary(max)  NULL,
	Fax varchar(15) NULL,
	Email VARCHAR(50)  NULL,
	Website VARCHAR(50)  NULL,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
    CONSTRAINT [PK_CinicDetails_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_CinicDetails_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO



/****** Object:  Table [dbo].[Appointments]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.[Appointments]
(
    Id INT IDENTITY(1,1) NOT NULL,
    PatientId int NOT NULL,
    AppointmentDateTime DateTime NOT NULL,
    DoctorId int Not NULL,
	ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	IsActive BIT NULL DEFAULT 1,
    CONSTRAINT [PK_Appointments_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Appointments_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_Appointments_User_DoctorId FOREIGN KEY (DoctorId) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_Appointments_User_PatientId FOREIGN KEY (PatientId) REFERENCES dbo.[Patient_Details] (Id)
)

GO


/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE dbo.[PatientInvoiceRecords]
(
    Id INT  NOT NULL,
    VisitId INT NULL,
    BalanceBF numeric(11,2) Not NUll,
	Amount numeric(11,2) Not NUll,
	Discount numeric(11,2) Not NUll,
	AmountRecieved numeric(11,2) Not NUll,
	BalanceCF numeric(11,2) Not NUll,
    Currency varchar(5) Not NUll,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	DrApproval char(1)  NOT NULL,
	PaidStatus char(1)  NOT NULL,
	PaidOn Datetime NULL,
    CONSTRAINT [PK_PatientInvoiceRecords_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientInvoiceRecords_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_PatientInvoiceRecords_PatientVisitDetails_VisitId FOREIGN KEY (VisitId) REFERENCES dbo.[PatientVisitDetails] (Id)
)

GO


/****** Object:  Table [dbo].[Treatments_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE dbo.[PatientInvoiceRecords_DT]
(
    Id INT IDENTITY(1,1) NOT NULL,
    InvoiceId INT NULL,
    TreatmentId INT Not NUll,
	Amount numeric(11,2) Not NUll,
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
    CONSTRAINT [PK_PatientInvoiceRecords_DT_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_PatientInvoiceRecords_DT_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_PatientInvoiceRecords_DT_PatientInvoiceRecords_InvoiceId FOREIGN KEY (InvoiceId) REFERENCES dbo.[PatientInvoiceRecords] (Id),
	CONSTRAINT FK_PatientInvoiceRecords_DT_Treatments_Mf_TreatmentId FOREIGN KEY (TreatmentId) REFERENCES dbo.[Treatments_Mf] (Id)
)

GO
/****** Object:  Table [dbo].[EarDedComponents_Mf]    Script Date: 15-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE dbo.[EarDedComponents_Mf]
(
   Id INT IDENTITY(1,1) NOT NULL,
   ComponentName VARCHAR(64) NOT NULL,
   ComponentCode VARCHAR(10) NOT NULL,
   ComponentType VARCHAR(3) NOT NULL,
   ModifiedBy INT NOT NULL,
   ModifiedOn Datetime NOT NULL,
   IsActive BIT,
   CONSTRAINT [PK_EarDedComponents_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
   CONSTRAINT FK_EarDedComponents_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)

)
GO
/****** Object:  Table [dbo].[MonthlyEarningDeduction]    Script Date: 15-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE dbo.[MonthlyEarningDeduction]
(
  Id INT IDENTITY(1,1) NOT NULL,
  Dates date not null,
  ComponentId int not null,
  Amount numeric(11,2) not null,
  Period varchar(6) not null,
  ModifiedBy INT NOT NULL,
  ModifiedOn Datetime NOT NULL,
  CONSTRAINT [PK_[MonthlyEarningDeduction_Id] PRIMARY KEY CLUSTERED (Id ASC),
  CONSTRAINT FK_MonthlyEarningDeduction_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
  CONSTRAINT FK_MonthlyEarningDeduction_ComponentId FOREIGN KEY (ComponentId) REFERENCES dbo.[EarDedComponents_Mf] (Id)
)
GO

--################################# TYPES #####################################################

CREATE TYPE UserRoles AS Table (UserId int, RoleName varchar(10))
CREATE TYPE TeethTreatmentsTyp AS Table (Teeth varchar(5), TreatmentId int,IsPediatric char(1))
CREATE TYPE SystemicIllnessTyp AS Table (VisitId int, SystemicIllnessId int)
CREATE TYPE PrescriptionsTyp AS Table (
	Id INT  NULL,  
    VisitId int NULL, 
	MedicineId int  null,
	OtherMedicine varchar(50) null,
	Remarks varchar(5) null,
	Dose numeric(11,2)  null,
	Days int  null,
	Times int  null
)
CREATE TYPE PatientInvoiceRecords_DTTyp as Table(
	Id INT NULL,
	TreatmentId INT  NUll,
	Amount numeric(11,2)  NUll
)

CREATE TYPE MonthlyEarningDeductionTyp as Table(
	Id INT  NULL,
    Dates date  null,
    ComponentId int  null,
    Amount numeric(11,2)  null,
    Period varchar(6)  null
    
)

--############################## Sequences ####################################################
CREATE SEQUENCE PatientInvoiceRecords_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000000



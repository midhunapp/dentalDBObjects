USE [DHCM]
/****** Object:  Table [dbo].[InventoryGroup_SupplierType_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[InventoryGroup_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    Name VARCHAR(30)  NULL,
	IsInvenoryGroup char(1) NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_InventoryGroup_SupplierType_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_InventoryGroup_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO

/****** Object:  Table [dbo].[SupplierDetails]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[SupplierDetails]
(
    Id INT  NOT NULL,
    Name VARCHAR(64)  NULL,
	Phone varchar(15) NULL,
	Email varchar(50) null, 
	TIR varchar(50) null, 
	FullAddress varchar(64)  NULL,
	ContactPersonName VARCHAR(64)  NULL,
	ContactPersonPh varchar(15)  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_SupplierDetails_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_SupplierDetails_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO


/****** Object:  Table [dbo].[SupplierDetailsTypes]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[SupplierDetailsTypes]
(
    Id INT IDENTITY(1,1) NOT NULL,
    SupplierId int  NULL,
	InventoryGroupId int  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_SupplierDetailsTypes_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_SupplierDetailsTypes_SupplierDetails_SupplierId FOREIGN KEY (SupplierId) REFERENCES dbo.[SupplierDetails] (Id),
	CONSTRAINT FK_SupplierDetailsTypes_InventoryGroup_Mf_InventoryGroupId FOREIGN KEY (InventoryGroupId) REFERENCES dbo.[InventoryGroup_Mf] (Id),
	CONSTRAINT FK_SupplierDetailsTypes_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO


/****** Object:  Table [dbo].[Lab_Works_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[Lab_Works_Mf]
(
    Id INT IDENTITY(1,1) NOT NULL,
    WorkName varchar(64)  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Lab_Works_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Lab_Works_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)
)

GO





/****** Object:  Table [dbo].[Lab_Rates]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[Lab_Rates]
(
    Id INT IDENTITY(1,1) NOT NULL,
    SupplierId int  NULL,
	WorkId int  NULL,
	FirstTeeth numeric(11,2)  NULL,
	AdditionalTeeth numeric(11,2)  NULL,
	FullTeeth numeric(11,2)  NULL,
	ValidFrom Date not null,
	ValidTo Date null,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Lab_Rates_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Lab_Rates_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_Lab_Rates_Lab_Works_Mf_WorkId FOREIGN KEY (WorkId) REFERENCES dbo.[Lab_Works_Mf] (Id)
)

GO



/****** Object:  Table [dbo].[Inventory_Details_Hd]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[Inventory_Details_Hd]
(
    Id INT IDENTITY(1,1) NOT NULL,
	Name varchar(64)  NULL,
	InventoryGroupId int  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Inventory_Details_Hd_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Inventory_Details_Hd_InventoryGroup_Mf_InventoryGroupId FOREIGN KEY (InventoryGroupId) REFERENCES dbo.[InventoryGroup_Mf] (Id),
	CONSTRAINT FK_Inventory_Details_Hd_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)

)

GO

/****** Object:  Table [dbo].[Units_Mf]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.Units_Mf
(
    Id INT IDENTITY(1,1) NOT NULL,
	Name varchar(64)  NULL,
	Code varchar(10)  NULL,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Units_Mf_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_IUnits_Mf_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)

)

GO


/****** Object:  Table [dbo].[Inventory_Details_DT]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[Inventory_Details_DT]
(
    Id INT IDENTITY(1,1) NOT NULL,
	Inventory_HdId int  NULL,
	BrandName varchar(64)  NULL,
	UnitId Int null,
	WtPerUnit numeric(11,2) null,
	MeasurementUnit varchar(10) null,
	Qty numeric(11,2) null,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Inventory_Details_DT_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Inventory_Details_DT_Inventory_Details_Hd_Inventory_HdId FOREIGN KEY (Inventory_HdId) REFERENCES dbo.[Inventory_Details_Hd] (Id),
	CONSTRAINT FK_Inventory_Details_DT_Units_Mf_Inventory_HdId FOREIGN KEY (UnitId) REFERENCES dbo.[Units_Mf] (Id),
	CONSTRAINT FK_Inventory_Details_DT_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)

)

GO


/****** Object:  Table [dbo].[Inventory_Purchase]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 


CREATE TABLE dbo.[Inventory_Purchase]
(
    Id INT IDENTITY(1,1) NOT NULL,
	SupplierId int  NULL,
	DateOfPurchase date  NULL,
	Inventory_DTId Int null,
	InvoiceNo varchar(50) null,
	LPONo varchar(50) null,
	Qty numeric(11,2) null,
	Rate numeric(11,2) null,
	Total numeric(11,2) null,
	Currency varchar(5) null,
	ExpDate date null,
    ModifiedBy INT  NULL,
    ModifiedOn Datetime  NULL,
    CONSTRAINT [PK_Inventory_Purchase_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_Inventory_Purchase_Inventory_Details_DT_Inventory_DTId FOREIGN KEY (Inventory_DTId) REFERENCES dbo.[Inventory_Details_DT] (Id),
	CONSTRAINT FK_Inventory_Purchase_SupplierDetails_SupplierId FOREIGN KEY (SupplierId) REFERENCES dbo.[SupplierDetails] (Id),
	CONSTRAINT FK_Inventory_Purchase_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id)

)

GO



/****** Object:  Table [dbo].[LabWork_Order]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE dbo.[LabWork_Order]
(
    Id INT  NOT NULL,
	VisitId int null,
	WorkId int null,
	SupplierId int  NULL,
	OrderDate date  NULL,
	OrderNo varchar(50)null,
	OrderCreatedBy INT  NULL,
    OrderCreatedOn Datetime  NULL,
	Notes varchar(200) null,
	OrderRecievedDate date  NULL,
	InvoiceNo varchar(50)null,
	InvoiceAmount Numeric(11,2) null,
	Currency varchar(5) null,
    InvoiceRecordedBy INT  NULL,
    InvoiceRecordedOn Datetime  NULL,
    CONSTRAINT [PK_LabWork_Order_Id] PRIMARY KEY CLUSTERED (Id ASC),
	CONSTRAINT FK_ILabWork_Order_Lab_Works_Mf_WorkId FOREIGN KEY (WorkId) REFERENCES dbo.[Lab_Works_Mf] (Id),
	CONSTRAINT FK_LabWork_Order_SupplierDetails_SupplierId FOREIGN KEY (SupplierId) REFERENCES dbo.[SupplierDetails] (Id),
	CONSTRAINT FK_LabWork_Order_User_OrderCreatedBy FOREIGN KEY (OrderCreatedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_LabWork_Order_User_InvoiceRecordedBy FOREIGN KEY (InvoiceRecordedBy) REFERENCES dbo.[User] (Id)

)

GO



/****** Object:  Table [dbo].[LabWork_Order_TeethInfo]    Script Date: 01-07-2020******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[LabWork_Order_TeethInfo](  
    Id INT IDENTITY(1,1) NOT NULL,  
    LabWorkOrderId int NULL, 
	Teeth varchar(5) NULL, 
    ModifiedBy INT NOT NULL,
    ModifiedOn Datetime NOT NULL,
	CONSTRAINT [PK_LabWork_Order_TeethInfo_Id] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_LabWork_Order_TeethInfo_User_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.[User] (Id),
	CONSTRAINT FK_LabWork_Order_TeethInfo_LabWorkOrderId FOREIGN KEY (LabWorkOrderId) REFERENCES dbo.[LabWork_Order] (Id)
) 

GO



--#########################  TYPES ##################################################


CREATE TYPE SupplierTypeDetailsTyp AS Table (SupplierId int, InventoryGroupId int)


--############################## Sequences ####################################################
CREATE SEQUENCE SupplierDetails_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000000


CREATE SEQUENCE LabWork_Order_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000000


--################################# types ######################################################
CREATE TYPE dbo.[LabWork_NewTyp]  as Table
(
	VisitId int null,
	WorkId int null,
	SupplierId int  NULL,
	OrderNo varchar(50)  NULL,
	Notes varchar(200)null,
	TeethInfo  varchar(200)null
)

CREATE TYPE dbo.[LabWork_PendTyp]  as Table
(
	LabWorkId int null,
	InvoiceDate date null,
	InvoiveNo varchar(50)  NULL,
	InvoiceAmount numeric(11,2)  NULL,
	Currency varchar(5) null

)


CREATE TYPE dbo.[Inventory_PurchaseTyp]  as Table
(
	Id int NULL,
	SupplierId int  NULL,
	DateOfPurchase date  NULL,
	Inventory_DTId Int null,
	InvoiceNo varchar(50) null,
	LPONo varchar(50) null,
	Qty numeric(11,2) null,
	Rate numeric(11,2) null,
	Total numeric(11,2) null,
	Currency varchar(5) null,
	ExpDate date null

)
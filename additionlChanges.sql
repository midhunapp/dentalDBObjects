alter table [Appointments] add IsActive BIT NULL DEFAULT 1

alter table [Treatments_Mf] add IsLabWorkIncluded char(1) NULL DEFAULT 'N'

alter table [PatientInvoiceRecords] add DrApproval char(1) NULL DEFAULT 'N'

---new 
alter table [Patient_Details] add Emirates varchar(25)  NULL

alter table [Patient_Details] alter COLUMN  FullAddress varchar(64)  NULL
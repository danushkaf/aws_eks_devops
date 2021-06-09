/*
script: 		xyz_DWH_DDL.sql
purpose: 		This script will create tables and constraints in dwh schema.
date created: 	22-Jan-2021
copy of script: Newly created
created by: 	PSL
Change History :
*/
CREATE SCHEMA IF NOT EXISTS REDSHIFT_SCHEMA_NAME;
CREATE SCHEMA IF NOT EXISTS REDSHIFT_STG_SCHEMA_NAME;
set search_path=REDSHIFT_SCHEMA_NAME;

CREATE TABLE IF NOT EXISTS NationalityMaster(
NationalityKey integer identity(1,1),
NationalityID integer,
Name nvarchar(100),
primary key (NationalityKey))
distkey(NationalityKey) sortkey(NationalityKey);

CREATE TABLE IF NOT EXISTS CountryMaster(
CountryKey integer identity(1,1),
CountryID integer,
Name nvarchar(100),
ShortCode nvarchar(50),
primary key (CountryKey))
distkey(CountryKey) sortkey(CountryKey);

CREATE TABLE IF NOT EXISTS DimCurrency(
CurrencyKey integer identity(1,1),
CurrencyCode nvarchar(50),
CurrencyLabel nvarchar(100),
primary key (CurrencyKey))
distkey(CurrencyKey) sortkey(CurrencyKey);

CREATE TABLE IF NOT EXISTS DimAccount(
AccountKey bigint identity(1,1),
Accountid bigint,
NominatedAcctKey bigint,
ApplicationID bigint,
AgencySortCode nvarchar(100),
AgencyAccountNbr nvarchar(100),
AgencyAccountNbr_Last4 nvarchar(20),
ParentAcctKey bigint,
Status nvarchar(20),
CreatedOnDate datetime,
CreatedBy nvarchar(50),
UpdatedonDate datetime,
UpdatedBy nvarchar(50),
Comments nvarchar(1000),
SavingAcctKey bigint,
AccountType nvarchar(20),
primary key (AccountKey))
distkey(AccountKey) sortkey(AccountKey);

CREATE TABLE IF NOT EXISTS DimNominatedAccount(
AccountKey bigint identity(1,1),
NominatedAcctID bigint,
AccountNumber nvarchar(100),
SortCode nvarchar(100),
Status nvarchar(20),
CreatedOnDate datetime,
CreatedBy nvarchar(40),
UpdatedOnDate datetime,
UpdatedBy nvarchar(40),
VerifiedOnDate datetime,
VerifiedBy nvarchar(40),
primary key (AccountKey))
distkey(AccountKey) sortkey(AccountKey);

CREATE TABLE IF NOT EXISTS DimCustomer(
CustomerKey bigint identity(1,1),
CustomerID bigint,Title nvarchar(20),
FirstName nvarchar(100),
MiddleName nvarchar(100),
LastName nvarchar(100),
DOB date,MobilePhone nvarchar(100),
Gender nvarchar(50),
ApprovedDate datetime,
ActivationDate datetime,
ClosedDate datetime,
Notes nvarchar(2500),
BirthPlace nvarchar(50),
Nationality nvarchar(50),
Email nvarchar(250),
LandlinePhone nvarchar(100),
CustRefNumber nvarchar(100),
IsCustomerVerified boolean,
IsEmailVerified boolean,
IsMobilePhoneVerified boolean,
IsLandlineVerified boolean,
CreatedDate datetime,
UpdatedDate datetime,
primary key (CustomerKey))
distkey(CustomerKey) sortkey(CustomerKey);

CREATE TABLE IF NOT EXISTS CustomerDetailsHistory(
CustDtlChangeKey bigint identity(1,1),
CustomerKey bigint,
EffectiveDate datetime,
ExpiryDate datetime,
AttributeName nvarchar(1000),
AttributeValue nvarchar(1000),
primary key (CustDtlChangeKey))
distkey(CustDtlChangeKey) sortkey(CustDtlChangeKey);

CREATE TABLE IF NOT EXISTS CustAddrDetails(
CustAddrDtlKey bigint identity(1,1),
CustomerKey bigint,
AddressType nvarchar(50),
PostalCode nvarchar(50),
AddressLine1 nvarchar(500),
AddressLine2 nvarchar(500),
AddressLine3 nvarchar(500),
GeographyKey integer,
primary key (CustAddrDtlKey))
distkey(CustAddrDtlKey) sortkey(CustAddrDtlKey);

--CustomerId,Productid are added as part of F&F release only so need to ignore CustomerKey, ProductKey for F&F
CREATE TABLE IF NOT EXISTS FactApplication(
ApplicationKey bigint identity(1,1),
ApplicationID int,
CustomerKey bigint,
CustomerId bigint,
ProductKey integer,
Productid nvarchar(100),
PledgedAmt Decimal(20,2),
CurrencyKey integer,
Status nvarchar(50),
CreateDate datetime,
UpdateDate datetime,
primary key (ApplicationKey))
distkey(ApplicationKey) sortkey(ApplicationKey);

CREATE TABLE IF NOT EXISTS DimProduct(
ProductKey integer identity(1,1),
cbsproductcode nvarchar(100),
ProductID nvarchar(100),
name nvarchar(100),
description nvarchar(1000),
RecDepositAmt Decimal(20,2),
maxWidthdrawlAmt Decimal(20,2),
DfltOpeningBalAmt Decimal(20,2),
MinMaturityMonths integer,
MaxMaturityMonths integer,
DfltMaturityMonths integer,
MaxODLimtAmt Decimal(20,2),
isODAllowed Boolean,
MaxBalanceAmt Decimal(20,2),
MaxDepositAmt Decimal(20,2),
MinDepositAmt Decimal(20,2),
primary key (ProductKey))
distkey(ProductKey) sortkey(ProductKey);

CREATE TABLE IF NOT EXISTS DimSavingAccount(
SavingAccountKey bigint identity(1,1),
CBSAccountNbr nvarchar(100),
CreatedDate datetime,
AccountSubType nvarchar(20) Default 001,
ActivationDate datetime,
ClosedDate datetime,
Status nvarchar(20),
MaturityDate datetime,
fundingclosedate date,
InterestRate Decimal(20,2) default null,
primary key (SavingAccountKey))
distkey(SavingAccountKey) sortkey(SavingAccountKey);

CREATE TABLE IF NOT EXISTS FactSavingsTrans(
SavingTransKey bigint identity(1,1),
TransactionID bigint,AccountKey bigint,
type nvarchar(40),transdatetime datetime,
TransDateKey bigint,
TransactionAmt Decimal(20,2) default null,
BalanceAmt Decimal(20,2) default null,
CustomerKey bigint,
ReversalTransKey bigint,
InterestAmt Decimal(20,2) default null,
FeesAmt Decimal(20,2) default null,
FundsAmt Decimal(20,2) default null,
TaxRate Decimal(20,2) default null,
InterestRate Decimal(20,2) default null,
CurrencyKey integer,
primary key (SavingTransKey))
distkey(SavingTransKey) sortkey(SavingTransKey);

CREATE TABLE IF NOT EXISTS DimGLAccount(
GLAccountKey integer identity(1,1),
glCode nvarchar(50),
GLAccType nvarchar(100),
Name nvarchar(150),
IsActivated Boolean,
Description nvarchar(250),
IsAllowedManualEntries Boolean,
IsStripTrailingZeros Boolean,
primary key (GLAccountKey))
distkey(GLAccountKey) sortkey(GLAccountKey);

CREATE TABLE IF NOT EXISTS FactGLJournal(
GLEntryKey bigint identity(1,1),
EntryID bigint,
EntryDateKey integer,
entrydate timestamp,
TransactionDateKey integer,
transactiondate timestamp,
TransactionId nvarchar(100),
AccountKey bigint,Amount Decimal(20,2),
GLAccountKey integer,
Createdby nvarchar(100),
Notes nvarchar(250),
ReversalEntryKey integer,
ProductKey integer,
primary key (GLEntryKey))
distkey(GLEntryKey) sortkey(GLEntryKey);

CREATE TABLE IF NOT EXISTS FactNotificationEvent(
NotificationKey bigint identity(1,1),
EventCreateDateTime datetime,
CustomerKey bigint,
EventModDateTime datetime,
AccountKey bigint,
EventParams nvarchar(16383),
notification_code nvarchar(16383) ,
ChannelType nvarchar(16383),
TemplateCode nvarchar(16383),
TemplateName nvarchar(16383),
primary key (NotificationKey))
distkey(NotificationKey) sortkey(NotificationKey);

CREATE TABLE IF NOT EXISTS CustCitizenship(
CitizenshipKey bigint identity(1,1),
CustomerKey bigint,
NationalityKey integer,
Ordinal nvarchar(100),
primary key (CitizenshipKey))
distkey(CitizenshipKey) sortkey(CitizenshipKey);

CREATE TABLE IF NOT EXISTS CustTaxResidency(
TaxResidencyKey bigint identity(1,1),
CustomerKey bigint,
CountryKey integer,
Ordinal nvarchar(100),
TaxIdentificationNbr nvarchar(100),
primary key (TaxResidencyKey))
distkey(CustomerKey) sortkey(CustomerKey);

CREATE TABLE IF NOT EXISTS DimGeography(
GeographyKey integer identity(1,1),
Country nvarchar(100) default 'UK',
County nvarchar(100),
City nvarchar(100),
primary key (GeographyKey))
distkey(GeographyKey) sortkey(GeographyKey);

CREATE TABLE IF NOT EXISTS FactFees(
FeesKey bigint identity(1,1),
SavingTransKey bigint,
FeeName nvarchar(100),
FeeAmt Decimal(20,2),
TaxAmt Decimal(20,2),
CurrencyKey integer,
primary key (FeesKey))
distkey(FeesKey) sortkey(FeesKey);

CREATE TABLE IF NOT EXISTS DimDate(
DateKey integer identity(1,1),
DateString date,
Year integer,
Quarter integer,
Month integer,
Week integer,
Day integer,
primary key (DateKey))
distkey(DateKey) sortkey(DateKey);

CREATE TABLE IF NOT EXISTS Customer_x_Account(
MappingKey bigint identity(1,1),
AccountKey bigint,
CustomerKey bigint,
AccountHolderType nvarchar(20),
primary key (MappingKey))
distkey(MappingKey) sortkey(MappingKey);

CREATE TABLE IF NOT EXISTS FactAccountInterest(
InterestRecordKey bigint identity(1,1),
AccountKey bigint,
InterestAccruedAmt Decimal(20,2),
InterestEarnedAmt Decimal(20,2),
FeesCollected Decimal(20,2),
primary key (InterestRecordKey))
distkey(InterestRecordKey) sortkey(InterestRecordKey);

CREATE TABLE configurationmaster
(
ConfigKey integer identity(1,1),
attributecode NVARCHAR(50),
attributedescription NVARCHAR(200),
attributevalue NVARCHAR(65355),
primary key (ConfigKey))
DISTSTYLE EVEN;

CREATE TABLE IF NOT EXISTS CustomerAddressHistory(
AddrHistKey bigint identity(1,1),
CustAddrDtlKey bigint,
EffectiveDate datetime,
ExpiryDate datetime,primary key (AddrHistKey))
distkey(AddrHistKey) sortkey(AddrHistKey);

CREATE TABLE IF NOT EXISTS FactAcctBalSSDaily(
DepositSnapshotID bigint identity(1,1),
ProductKey integer,
AccountKey bigint,
CurrencyKey integer,
RecordedDate Date,
BalanceAmount Decimal(20,2),
HoldBalance Decimal(20,2),
primary key (DepositSnapshotID))
distkey(DepositSnapshotID) sortkey(DepositSnapshotID);

CREATE TABLE IF NOT EXISTS AcctInterestSchedule(
InterestScheduleKey bigint identity(1,1),
InterestPaymentDate Date,
SavingAccountKey bigint,
primary key (InterestScheduleKey))
distkey(InterestScheduleKey) sortkey(InterestScheduleKey);

ALTER TABLE DimAccount add  constraint fk_DimAccount_NominatedAcctKey foreign key(NominatedAcctKey) references DimNominatedAccount(AccountKey);
ALTER TABLE DimAccount add  constraint fk_DimAccount_ParentAcctKey foreign key(ParentAcctKey) references DimAccount(AccountKey);
ALTER TABLE DimAccount add  constraint fk_DimAccount_SavingAcctKey foreign key(SavingAcctKey) references DimSavingAccount(SavingAccountKey);
ALTER TABLE CustomerDetailsHistory add  constraint fk_CustomerDetailsHistory_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE CustAddrDetails add  constraint fk_CustAddrDetails_GeographyKey foreign key(GeographyKey) references DimGeography(GeographyKey);
ALTER TABLE CustAddrDetails add  constraint fk_CustAddrDetails_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE FactSavingsTrans add  constraint fk_FactSavingsTrans_AccountKey foreign key(AccountKey) references DimAccount(AccountKey);
ALTER TABLE FactSavingsTrans add  constraint fk_FactSavingsTrans_TransDateKey foreign key(TransDateKey) references DimDate(DateKey);
ALTER TABLE FactSavingsTrans add  constraint fk_FactSavingsTrans_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE FactSavingsTrans add  constraint fk_FactSavingsTrans_ReversalTransKey foreign key(ReversalTransKey) references FactSavingsTrans(SavingTransKey);
ALTER TABLE FactSavingsTrans add  constraint fk_FactSavingsTrans_CurrencyKey foreign key(CurrencyKey) references DimCurrency(CurrencyKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_EntryDateKey foreign key(EntryDateKey) references  DimDate(DateKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_TransactionDateKey foreign key(TransactionDateKey) references  DimDate(DateKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_AccountKey foreign key(AccountKey) references  DimAccount(AccountKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_ProductKey foreign key(ProductKey) references  DimProduct(ProductKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_GLAccountKey foreign key(GLAccountKey) references  DimGLAccount(GLAccountKey);
ALTER TABLE FactGLJournal add  constraint fk_FactGLJournal_ReversalEntryKey foreign key(ReversalEntryKey) references FactGLJournal(GLEntryKey);
ALTER TABLE FactNotificationEvent add  constraint fk_FactNotificationEvent_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE FactNotificationEvent add  constraint fk_FactNotificationEvent_AccountKey foreign key(AccountKey) references DimAccount(AccountKey);
ALTER TABLE CustCitizenship add  constraint fk_CustCitizenship_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE CustCitizenship add  constraint fk_CustCitizenship_NationalityKey foreign key(NationalityKey) references NationalityMaster(NationalityKey);
ALTER TABLE CustTaxResidency add  constraint fk_CustTaxResidency_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE CustTaxResidency add  constraint fk_CustTaxResidency_CountryKey foreign key(CountryKey) references CountryMaster(CountryKey);
ALTER TABLE FactFees add  constraint fk_FactFees_SavingTransKey foreign key(SavingTransKey) references FactSavingsTrans(SavingTransKey);
ALTER TABLE Customer_x_Account add  constraint fk_Customer_x_Account_CustomerKey foreign key(CustomerKey) references DimCustomer(CustomerKey);
ALTER TABLE Customer_x_Account add  constraint fk_Customer_x_Account_AccountKey foreign key(AccountKey) references DimAccount(AccountKey);
ALTER TABLE FactAccountInterest add  constraint fk_FactAccountInterest_AccountKey foreign key(AccountKey) references DimAccount(AccountKey);
ALTER TABLE CustomerAddressHistory add  constraint fk_CustomerAddressHistory_CustAddrDtlKey foreign key(CustAddrDtlKey) references CustAddrDetails(CustAddrDtlKey);
ALTER TABLE FactAcctBalSSDaily add  constraint fk_FactAcctBalSSDaily_ProductKey foreign key(ProductKey) references DimProduct(ProductKey);
ALTER TABLE FactAcctBalSSDaily add  constraint fk_FactAcctBalSSDaily_AccountKey foreign key(AccountKey) references DimAccount(AccountKey);
ALTER TABLE FactAcctBalSSDaily add  constraint fk_FactAcctBalSSDaily_CurrencyKey foreign key(CurrencyKey) references DimCurrency(CurrencyKey);
ALTER TABLE FactApplication add  constraint fk_FactApplication_CurrencyKey foreign key(CurrencyKey) references DimCurrency(CurrencyKey);
ALTER TABLE AcctInterestSchedule add  constraint fk_AcctInterestSchedule_SavingAccountKey foreign key(SavingAccountKey) references DimSavingAccount(SavingAccountKey);

--This is created for reporting requirement
CREATE TABLE IF NOT EXISTS addresslines_fscs(
addressline1 nvarchar (500),
addressline2 nvarchar (500),
addressline3 nvarchar (500),
addressline4 nvarchar (500),
addressline5 nvarchar (500),
country nvarchar (100),
custrefnumber nvarchar (100),
email nvarchar (250),
landlinephone nvarchar (100),
mobilephone nvarchar (100),
postalcode nvarchar (50));

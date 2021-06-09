copy xyz_dwh.nationalitymaster
(NationalityID, Name)
from 's3://dev-redshift-mig/xyz_dwh/nationalitymaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.addresslines_fscs
(addressline1, addressline2, addressline3, addressline4, addressline5, country, custrefnumber, email, landlinephone, mobilephone, postalcode)
from 's3://dev-redshift-mig/xyz_dwh/addresslines_fscs/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.configurationmaster
(attributecode, attributedescription, attributevalue)
from 's3://dev-redshift-mig/xyz_dwh/configurationmaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.countrymaster
(CountryID, Name, ShortCode)
from 's3://dev-redshift-mig/xyz_dwh/countrymaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.custaddrdetails
(CustomerKey, AddressType, PostalCode, AddressLine1, AddressLine2, AddressLine3, GeographyKey)
from 's3://dev-redshift-mig/xyz_dwh/custaddrdetails/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.customeraddresshistory
(CustAddrDtlKey, EffectiveDate, ExpiryDate)
from 's3://dev-redshift-mig/xyz_dwh/customeraddresshistory/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimnominatedaccount
(NominatedAcctID, AccountNumber, SortCode, Status, CreatedOnDate, CreatedBy, UpdatedOnDate, UpdatedBy, VerifiedOnDate, VerifiedBy)
from 's3://dev-redshift-mig/xyz_dwh/dimnominatedaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimaccount
(Accountid, NominatedAcctKey, ApplicationID, AgencySortCode, AgencyAccountNbr, AgencyAccountNbr_Last4, ParentAcctKey, Status, CreatedOnDate, CreatedBy, UpdatedonDate, UpdatedBy, Comments, SavingAcctKey, AccountType)
from 's3://dev-redshift-mig/xyz_dwh/dimaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimsavingaccount
(CBSAccountNbr, CreatedDate, AccountSubType, ActivationDate, ClosedDate, Status, MaturityDate, fundingclosedate, InterestRate)
from 's3://dev-redshift-mig/xyz_dwh/dimsavingaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimcurrency
(CurrencyCode, CurrencyLabel)
from 's3://dev-redshift-mig/xyz_dwh/dimcurrency/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimcustomer
(CustomerID, FirstName, MiddleName, LastName, DOB, MobilePhone, Gender, ApprovedDate, ActivationDate, ClosedDate, Notes, BirthPlace, Nationality, Email, LandlinePhone, CustRefNumber, IsCustomerVerified, IsEmailVerified, IsMobilePhoneVerified, IsLandlineVerified, CreatedDate, UpdatedDate)
from 's3://dev-redshift-mig/xyz_dwh/dimcustomer/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimdate
(DateString, Year, Quarter, Month, Week, Day)
from 's3://dev-redshift-mig/xyz_dwh/dimdate/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimgeography
(Country, County, City)
from 's3://dev-redshift-mig/xyz_dwh/dimgeography/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimglaccount
(glCode, GLAccType, Name, IsActivated, Description, IsAllowedManualEntries, IsStripTrailingZeros)
from 's3://dev-redshift-mig/xyz_dwh/dimglaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.dimproduct
(cbsproductcode, ProductID, name, description, RecDepositAmt, maxWidthdrawlAmt, DfltOpeningBalAmt, MinMaturityMonths, MaxMaturityMonths, DfltMaturityMonths, MaxODLimtAmt, isODAllowed, MaxBalanceAmt, MaxDepositAmt, MinDepositAmt)
from 's3://dev-redshift-mig/xyz_dwh/dimproduct/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.custcitizenship
(CustomerKey, NationalityKey, Ordinal)
from 's3://dev-redshift-mig/xyz_dwh/custcitizenship/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.customerdetailshistory
(CustomerKey, EffectiveDate, ExpiryDate, AttributeName, AttributeValue)
from 's3://dev-redshift-mig/xyz_dwh/customerdetailshistory/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.custtaxresidency
(CustomerKey, CountryKey, Ordinal, TaxIdentificationNbr)
from 's3://dev-redshift-mig/xyz_dwh/custtaxresidency/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.customer_x_account
(AccountKey, CustomerKey, AccountHolderType)
from 's3://dev-redshift-mig/xyz_dwh/customer_x_account/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.acctinterestschedule
(InterestPaymentDate, SavingAccountKey)
from 's3://dev-redshift-mig/xyz_dwh/acctinterestschedule/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factaccountinterest
(AccountKey, InterestAccruedAmt, InterestEarnedAmt, FeesCollected)
from 's3://dev-redshift-mig/xyz_dwh/factaccountinterest/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factacctbalssdaily
(ProductKey, AccountKey, CurrencyKey, RecordedDate, BalanceAmount, HoldBalance)
from 's3://dev-redshift-mig/xyz_dwh/factacctbalssdaily/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factapplication
(ApplicationID, CustomerKey, CustomerId, ProductKey, Productid, PledgedAmt, CurrencyKey, Status, CreateDate, UpdateDate)
from 's3://dev-redshift-mig/xyz_dwh/factapplication/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factfees
(SavingTransKey, FeeName, FeeAmt, TaxAmt, CurrencyKey)
from 's3://dev-redshift-mig/xyz_dwh/factfees/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factgljournal
(EntryID, EntryDateKey, entrydate, TransactionDateKey, transactiondate, TransactionId, AccountKey, Amount, GLAccountKey, Createdby, Notes, ReversalEntryKey, ProductKey)
from 's3://dev-redshift-mig/xyz_dwh/factgljournal/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factnotificationevent
(EventCreateDateTime, CustomerKey, EventModDateTime, AccountKey, EventParams, notification_code, ChannelType, TemplateCode, TemplateName)
from 's3://dev-redshift-mig/xyz_dwh/factnotificationevent/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;
copy xyz_dwh.factsavingstrans
(TransactionID, AccountKey, type, transdatetime, TransDateKey, TransactionAmt, BalanceAmt, CustomerKey, ReversalTransKey, InterestAmt, FeesAmt, FundsAmt, TaxRate, InterestRate, CurrencyKey)
from 's3://dev-redshift-mig/xyz_dwh/factsavingstrans/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
format as csv;

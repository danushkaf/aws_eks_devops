create or replace view REDSHIFT_SCHEMA_NAME.vw_fscs_customer_details as 
SELECT 'Single customer view record number|Title|Customer first forename|Customer second forename|Customer third forename|Customer Surname [or company name or name of account holder]|Previous Name|National Insurance number|Passport number|Other national identifier|Other national identity number|Company number|Customer date of birth' as Header, '1' as sortby

UNION
SELECT 
cast(isnull(DIMC.CustRefNumber, '') AS VARCHAR)+'|'+ 
cast(isnull(DIMC.Title, '') AS VARCHAR)+'|'+
cast(isnull(DIMC.FirstName, '') AS VARCHAR)+'|'+
cast(isnull(DIMC.MiddleName, '') AS VARCHAR)+'|'+
'' +'|'+
cast(isnull(DIMC.LastName, '') AS VARCHAR)+'|'+
cast(isnull(DIMCH.Attributevalue, '') AS VARCHAR)+'|'+
'' +'|'+
'' +'|'+
cast(isnull(TAXR.Ordinal, '') AS VARCHAR)+'|'+
cast(isnull(TAXR.TaxIdentificationnbr, '') AS VARCHAR)+'|'+
'' +'|'+
isnull(cast(to_char(DIMC.DOB, 'DDMMYYYY') as VARCHAR), '') as Header , '2' as sortby
FROM REDSHIFT_SCHEMA_NAME.DimCustomer DIMC LEFT JOIN REDSHIFT_SCHEMA_NAME.CustomerDetailsHistory DIMCH ON
DIMC.CustomerKey=DIMCH.CustomerKey LEFT JOIN REDSHIFT_SCHEMA_NAME.CustTaxResidency TAXR ON
DIMC.CustomerKey=TAXR.Customerkey

UNION
SELECT '99999999999999999999' AS Header , '3' as sortby
order by sortby asc
;


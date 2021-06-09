create or replace view REDSHIFT_SCHEMA_NAME.vw_fscs_contact_details as 
SELECT 'Single customer view record number|Address line 1|Address line 2|Address line 3|Address line 4|Address line 5|Postcode|Country|Email address|Main phone number|Evening phone number|Mobile phone number' as Header, '1' as sortby

UNION
SELECT
cast(isnull(CustRefNumber, '') AS VARCHAR)+'|'+
cast(isnull(AddressLine1, '') AS VARCHAR)+'|'+
cast(isnull(AddressLine2, '') AS VARCHAR)+'|'+
cast(isnull(AddressLine3, '') AS VARCHAR)+'|'+
cast(isnull(AddressLine4, '') AS VARCHAR)+'|'+
cast(isnull(AddressLine5, '') AS VARCHAR)+'|'+
cast(isnull(PostalCode, '') AS VARCHAR)+'|'+
cast(isnull(Country, '') AS VARCHAR)+'|'+
cast(isnull(Email, '') AS VARCHAR)+'|'+
cast(isnull(LandlinePhone, '') AS VARCHAR)+'|'+
'' +'|'+
CAST(isnull(MobilePhone, '') AS VARCHAR) as Header , '2' as sortby
FROM REDSHIFT_SCHEMA_NAME.addresslines_fscs


UNION
SELECT '99999999999999999999' AS Header , '3' as sortby
order by sortby asc
;
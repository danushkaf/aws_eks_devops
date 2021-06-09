create or replace view REDSHIFT_SCHEMA_NAME.vw_Factapplication as
SELECT
applicationkey,
applicationid,
customerkey as customerid,
customerid as customerkey,
productid,
productid as productkey,
pledgedamt,
currencykey,
status,
createdate,
updatedate
from REDSHIFT_SCHEMA_NAME.Factapplication
;
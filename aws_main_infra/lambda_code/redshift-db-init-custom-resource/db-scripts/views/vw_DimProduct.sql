create or replace view REDSHIFT_SCHEMA_NAME.vw_DimProduct as
SELECT
productid,
cbsproductcode,
productid as productkey,
name,
description,
recdepositamt,
maxwidthdrawlamt,
dfltopeningbalamt,
minmaturitymonths,
maxmaturitymonths,
dfltmaturitymonths,
maxodlimtamt,
isodallowed,
maxbalanceamt,
maxdepositamt
FROM REDSHIFT_SCHEMA_NAME.DimProduct
;
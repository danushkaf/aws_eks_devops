CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factapplication()
AS $$
/*
script: 		prc_load_factapplication.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.application having count(1)>0;

IF FOUND THEN

RAISE INFO 'factapplication new started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.factapplication (ApplicationID,customerid,productid,PledgedAmt,CurrencyKey,Status,CreateDate,UpdateDate)
select Id,application.customerid,dimproduct.productid,PledgedAmount,dimcurrency.CurrencyKey,application.Status,CreatedOn::timestamp,UpdatedOn::timestamp 
from ext_spectrum.application left join REDSHIFT_SCHEMA_NAME.dimcustomer on (application.customerid=dimcustomer.customerid) 
left join REDSHIFT_SCHEMA_NAME.dimproduct on (dimproduct.cbsproductcode=application.cbsproductcode) left join REDSHIFT_SCHEMA_NAME.dimcurrency on (dimcurrency.currencycode=application.currencyid)
left join REDSHIFT_SCHEMA_NAME.factapplication on (factapplication.ApplicationID=application.id) where factapplication.ApplicationID is null';

RAISE INFO 'factapplication append started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.factapplication (ApplicationID,customerid,productid,PledgedAmt,CurrencyKey,Status,CreateDate,UpdateDate)
select Id,application.customerid,dimproduct.productid,PledgedAmount,dimcurrency.CurrencyKey,application.Status,CreatedOn::timestamp,UpdatedOn::timestamp
from ext_spectrum.application left join REDSHIFT_SCHEMA_NAME.dimcustomer on (application.customerid=dimcustomer.customerid) 
left join REDSHIFT_SCHEMA_NAME.dimproduct on (dimproduct.cbsproductcode=application.cbsproductcode) left join REDSHIFT_SCHEMA_NAME.dimcurrency on (dimcurrency.currencycode=application.currencyid)
join REDSHIFT_SCHEMA_NAME.factapplication on (factapplication.ApplicationID=application.id and (factapplication.Status<>application.Status or factapplication.PledgedAmt<>application.PledgedAmount))';

RAISE INFO 'factapplication completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_customerdetailshistory()
AS $$
/*
script: 		prc_load_customerdetailshistory.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.customerdetailschangehistory having count(1)>0;

IF FOUND THEN

RAISE INFO 'customerdetailshistory started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.customerdetailshistory(customerkey,effectivedate,expirydate,attributename,attributevalue)
select dimcustomer.customerkey,src.createdon::timestamp effectivedate,tgt.createdon::timestamp expirydate,src.fieldname, src.newvalue 
from ext_spectrum.customerdetailschangehistory src
left join ext_spectrum.customerdetailschangehistory tgt on (src.newvalue=tgt.oldvalue and src.fieldname=tgt.fieldname and src.customerid=tgt.customerid)
left join REDSHIFT_SCHEMA_NAME.dimcustomer on (dimcustomer.customerid=src.customerid)';

RAISE INFO 'customerdetailshistory completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_custaddrdetails()
AS $$
/*
script: 		prc_load_custaddrdetails.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;
myrec1 int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.address having count(1)>0;

IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.custaddrdetails';

RAISE INFO 'custaddrdetails started : ';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.custaddrdetails
(
  customerkey,
  addresstype,
  addressline1,
  addressline2,
  addressline3,
  postalcode,
  geographykey
)
select customerkey, addresstype.name,address.addressline1,address.addressline2,address.addressline3,address.postalcode,dimgeography.geographykey 
from ext_spectrum.address left join REDSHIFT_SCHEMA_NAME.dimcustomer on (address.customerid=dimcustomer.customerid)
left join ext_spectrum.addresstype on (address.addresstypeid=addresstype.id) 
left join REDSHIFT_SCHEMA_NAME.dimgeography on ((address.city=dimgeography.city and address.county=dimgeography.county and address.city is not null and address.county is not null) or (address.city=dimgeography.city and address.county is null and address.city is not null))';

execute 'insert into  REDSHIFT_SCHEMA_NAME.customeraddresshistory (custaddrdtlkey,effectivedate)
 select custaddrdetails.custaddrdtlkey,updatedon::timestamp effectivedate from REDSHIFT_SCHEMA_NAME.custaddrdetails 
 inner join REDSHIFT_SCHEMA_NAME.dimcustomer on (custaddrdetails.customerkey=dimcustomer.customerkey) 
 inner join ext_spectrum.address on (address.customerid=dimcustomer.customerid)
 left join REDSHIFT_SCHEMA_NAME.customeraddresshistory on (customeraddresshistory.custaddrdtlkey=custaddrdetails.custaddrdtlkey) where customeraddresshistory.custaddrdtlkey is null';

RAISE INFO 'dimcustomer completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

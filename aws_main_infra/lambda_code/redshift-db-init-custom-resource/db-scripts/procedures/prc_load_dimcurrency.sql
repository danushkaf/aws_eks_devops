CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimcurrency()
AS $$
/*
script: 		prc_load_dimcurrency.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.currency having count(1)>0;
IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.dimcurrency';

RAISE INFO 'dimcurrency started : ';
 
execute 'insert into REDSHIFT_SCHEMA_NAME.dimcurrency(CurrencyCode,currencylabel) select id,name from ext_spectrum.currency 
left join REDSHIFT_SCHEMA_NAME.dimcurrency on (dimcurrency.currencylabel=currency.name) 
where dimcurrency.CurrencyCode is null and currency.is_active=true';

RAISE INFO 'dimcurrency completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_countrymaster()
AS $$
/*
script: 		prc_load_countrymaster.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.countriesmaster having count(1)>0;

IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.countrymaster';

RAISE INFO 'countrymaster started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.countrymaster(countryid,name) select id,label from ext_spectrum.countriesmaster 
left join REDSHIFT_SCHEMA_NAME.countrymaster on (countrymaster.countryid=countriesmaster.id) 
where countrymaster.name is null and countriesmaster.is_active=true';

RAISE INFO 'countrymaster completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
	
END;
$$ LANGUAGE plpgsql;

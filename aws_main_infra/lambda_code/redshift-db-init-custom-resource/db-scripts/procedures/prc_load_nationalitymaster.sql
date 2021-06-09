CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_nationalitymaster()
AS $$
/*
script: 		prc_load_nationalitymaster.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.nationalities having count(1)>0;

IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.nationalitymaster';

RAISE INFO 'nationalitymaster Started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.nationalitymaster(nationalityid,name) 
select id,label  from  ext_spectrum.nationalities 
left join REDSHIFT_SCHEMA_NAME.nationalitymaster  on (nationalitymaster.nationalityid=nationalities.id) 
where nationalitymaster.name is null and nationalities.is_active=true';

--commit;

RAISE INFO 'nationalitymaster Copleted';

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;

END;
$$ LANGUAGE plpgsql;

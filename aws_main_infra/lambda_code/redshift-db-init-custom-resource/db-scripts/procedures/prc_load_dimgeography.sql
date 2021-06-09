CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimgeography()
AS $$
/*
script: 		prc_load_dimgeography.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.address having count(1)>0;
IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.dimgeography';

RAISE INFO 'dimgeography started : ';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.dimgeography
(
  country,
  county,
  city
)
select ''UK'' , address.county, address.city from ext_spectrum.address 
left join REDSHIFT_SCHEMA_NAME.dimgeography on ((address.county=dimgeography.county and address.city=dimgeography.city and address.county<>'''' and address.city<>'''') or (address.city=dimgeography.city and address.county='''' and address.city<>''''))
where dimgeography.geographykey is null group by address.county, address.city';

--commit;

RAISE INFO 'dimgeography completed : ';

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

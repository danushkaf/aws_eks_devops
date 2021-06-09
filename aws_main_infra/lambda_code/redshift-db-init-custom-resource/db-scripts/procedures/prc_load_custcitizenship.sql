CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_custcitizenship()
AS $$
/*
script: 		prc_load_custcitizenship.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.customerprofile having count(1)>0;

IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.custcitizenship';

RAISE INFO 'custcitizenship started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.custcitizenship(CustomerKey,NationalityKey,ordinal)
with Citizenship as (select id,Citizenship1,Citizenship2,Citizenship3,Citizenship4,Citizenship5 from ext_spectrum.CustomerProfile  where Citizenship1 is not null or Citizenship2 is not null or Citizenship3 is not null or Citizenship4 is not null or Citizenship5 is not null),
nationality as (select nationalitykey,nationalityid,name from REDSHIFT_SCHEMA_NAME.nationalitymaster)
select CustomerKey,nationalitykey, row_number() over (partition by  CustomerKey order by CustomerKey ) ordinal  from REDSHIFT_SCHEMA_NAME.dimcustomer inner join  
(select id,nationalitykey, Citizenship1 from Citizenship, nationality where Citizenship.Citizenship1=nationality.nationalityid
union 
select id,nationalitykey, Citizenship2 from Citizenship, nationality where Citizenship.Citizenship2=nationality.nationalityid
union 
select id,nationalitykey, Citizenship3 from Citizenship, nationality where Citizenship.Citizenship3=nationality.nationalityid
union 
select id,nationalitykey, Citizenship4 from Citizenship, nationality where Citizenship.Citizenship4=nationality.nationalityid
union 
select id,nationalitykey, Citizenship5 from Citizenship, nationality where Citizenship.Citizenship5=nationality.nationalityid
) src1 on (src1.id=dimcustomer.customerid)';

RAISE INFO 'custcitizenship completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

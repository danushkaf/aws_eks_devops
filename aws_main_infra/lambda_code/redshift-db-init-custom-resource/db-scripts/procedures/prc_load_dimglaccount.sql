CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimglaccount()
AS $$
/*
script: 		prc_load_dimglaccount.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.gl_account having count(1)>3;
IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.dimglaccount';

RAISE INFO 'dimglaccount started : ';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.dimglaccount
(
  glcode,
  glacctype,
  name,
  isactivated,
  isallowedmanualentries,
  isstriptrailingzeros
)
SELECT record.gl_code,
       record.type,
       record.name,
       record.activated,
       record.allow_manual_journal_entries,
       record.strip_trailing_zeros
FROM ext_spectrum.gl_account
WHERE record.gl_code IS NOT NULL';

--commit;

RAISE INFO 'dimglaccount completed : ';

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

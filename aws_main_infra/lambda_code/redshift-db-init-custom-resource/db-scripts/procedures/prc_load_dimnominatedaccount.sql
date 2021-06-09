CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimnominatedaccount()
AS $$
/*
script: 		prc_load_dimnominatedaccount.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.nominatedaccount having count(1)>0;
IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.DimNominatedAccount';

RAISE INFO 'DimNominatedAccount started : ';
 
execute 'insert into REDSHIFT_SCHEMA_NAME.DimNominatedAccount(NominatedAcctID,AccountNumber,SortCode,Status,CreatedOnDate,CreatedBy,UpdatedOnDate,UpdatedBy,VerifiedOnDate,VerifiedBy)
select Id,AccountNumber,SortCode,status,CreatedOn::timestamp CreatedOn,CreatedBy,UpdatedOn::timestamp UpdatedOn,UpdatedBy,VerifiedOn::timestamp VerifiedOn,VerifiedBy from ext_spectrum.nominatedaccount';

--commit;

RAISE INFO 'DimNominatedAccount completed : ';

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

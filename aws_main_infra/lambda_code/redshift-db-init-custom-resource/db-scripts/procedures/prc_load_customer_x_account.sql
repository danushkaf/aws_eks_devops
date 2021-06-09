CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_customer_x_account()
AS $$
/*
script: 		prc_load_customer_x_account.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
vprocedure VARCHAR(100);

BEGIN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.customer_x_account';

RAISE INFO 'customer_x_account started';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.customer_x_account
(
  customerkey,
  accountkey,
  accountholdertype
)
SELECT dimcustomer.customerkey,
       dimaccount.accountkey,
       dimaccount.accounttype
FROM REDSHIFT_SCHEMA_NAME.factapplication,
     REDSHIFT_SCHEMA_NAME.dimaccount, REDSHIFT_SCHEMA_NAME.dimcustomer
WHERE factapplication.applicationid = dimaccount.applicationid 
and factapplication.customerid=dimcustomer.customerid
group by 1,2,3';

--commit;

RAISE INFO 'customer_x_account completed';

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

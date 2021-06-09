CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factacctbalssdaily()
AS $$
/*
script: 		prc_load_factacctbalssdaily.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;

IF FOUND THEN


RAISE INFO 'factacctbalssdaily started : ';

execute 'drop table if exists temp_deposit_accounts';

execute 'create temp table temp_deposit_accounts as 
select deposit_accounts.record.id,record.balances.hold_balance from ext_spectrum.deposit_accounts';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.factacctbalssdaily';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.factacctbalssdaily
(
  productkey,
  accountkey,
  currencykey,
  recordeddate,
  balanceamount,
  holdbalance
) select dimproduct.productkey,factsavingstrans.accountkey,factsavingstrans.currencykey,transdatetime::date,sum(balanceamt),sum(temp_deposit_accounts.hold_balance) from REDSHIFT_SCHEMA_NAME.factsavingstrans 
left join REDSHIFT_SCHEMA_NAME.dimaccount on (dimaccount.accountkey=factsavingstrans.accountkey)
left join REDSHIFT_SCHEMA_NAME.dimsavingaccount on (dimsavingaccount.savingaccountkey=dimaccount.savingacctkey)
left join temp_deposit_accounts on (temp_deposit_accounts.id=dimsavingaccount.cbsaccountnbr)
left join REDSHIFT_SCHEMA_NAME.factapplication on (factapplication.applicationid=dimaccount.applicationid) 
left join REDSHIFT_SCHEMA_NAME.dimproduct on (factapplication.productid=dimproduct.productid) 
group by  dimproduct.productkey,factsavingstrans.accountkey,factsavingstrans.currencykey,transdatetime::date';

--commit;

RAISE INFO 'factacctbalssdaily completed : ';

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

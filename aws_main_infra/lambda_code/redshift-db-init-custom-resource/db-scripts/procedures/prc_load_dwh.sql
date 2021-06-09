CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dwh()
AS $$
/*
script: 		prc_load_dwh.prc_load_sql
purpose: 		This will populate data in dwh schema.prc_load_
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
vprocedure VARCHAR(100);

BEGIN

RAISE INFO 'started transaction for prc_load_dwh';
call xyz_stg.prc_load_dimcurrency();
call xyz_stg.prc_load_countrymaster();
call xyz_stg.prc_load_nationalitymaster();
call xyz_stg.prc_load_DimProduct();
call xyz_stg.prc_load_dimgeography();
call xyz_stg.prc_load_dimcustomer();
call xyz_stg.prc_load_customerdetailshistory();
call xyz_stg.prc_load_custcitizenship();
call xyz_stg.prc_load_custtaxresidency();
call xyz_stg.prc_load_DimNominatedAccount();
call xyz_stg.prc_load_dimglaccount();
call xyz_stg.prc_load_custaddrdetails();
call xyz_stg.prc_load_customeraddresshistory();
call xyz_stg.prc_load_factapplication();
call xyz_stg.prc_load_DimSavingAccount();
call xyz_stg.prc_load_dimaccount();
call xyz_stg.prc_load_factsavingstrans();
call xyz_stg.prc_load_factgljournal();
call xyz_stg.prc_load_customer_x_account();
call xyz_stg.prc_load_factaccountinterest();
call xyz_stg.prc_load_factacctbalssdaily();
call xyz_stg.prc_load_factnotievent();
call xyz_stg.prc_load_acctinterestschedule();
call xyz_stg.prc_addresslines();
call xyz_stg.prc_load_unittestresult();
call xyz_stg.prc_unload_almis('vw_dep_regext_almis','s3://{env}-sftp-xyz/almis/','_Deposits.ssi');
RAISE INFO 'Copleted transaction';

EXCEPTION
  WHEN OTHERS THEN
    RAISE INFO 'Failed';
END;
$$ LANGUAGE plpgsql;

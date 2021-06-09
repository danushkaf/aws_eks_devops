CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_DimProduct()
AS $$
/*
script: 		prc_load_DimProduct.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;
myrec1 int;
myrec2 int;

BEGIN


SELECT INTO myrec count(1) FROM ext_spectrum.deposit_products having count(1)>3;
IF FOUND THEN

--execute 'truncate table REDSHIFT_SCHEMA_NAME.DimProduct';

RAISE INFO 'DimProduct started : ';

execute 'create temp table temp_deposit_products as
select 
record.encoded_key,record.id,record.name,record.description,
record.max_overdraft_limit,record.allow_overdraft
 from ext_spectrum.deposit_products 
 where record.encoded_key is not null';

SELECT INTO myrec1 count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;
IF FOUND THEN

SELECT INTO myrec2 count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;
IF FOUND THEN

execute 'create temp table temp_balancelimit as
select deposit_accounts.record.product_type_key,max(case when custom_field_id=''MinBalanceLimit'' then  custom_field_value end) MinBalanceLimit   
,max(case when custom_field_id=''MaxBalanceLimit'' then  custom_field_value end) MaxBalanceLimit
from ext_spectrum.deposit_accounts_custom inner join ext_spectrum.deposit_accounts on (deposit_accounts.record.encoded_key=deposit_accounts_custom.encoded_key)
where custom_field_set_id=''_Deposit_Creation'' group by 1';

 
--replace(REGEXP_REPLACE(record.description, '<[^<>]*>', ''),'&nbsp;',' ') -- html tag extraction code

execute 'insert into REDSHIFT_SCHEMA_NAME.DimProduct (cbsproductcode,ProductID,name,description,mindepositamt,maxdepositamt,MaxODLimtAmt,isODAllowed)
select encoded_key,id,name,description,minbalancelimit,maxbalancelimit,max_overdraft_limit,allow_overdraft
  from temp_deposit_products left join temp_balancelimit on (temp_deposit_products.encoded_key=temp_balancelimit.product_type_key)';

--commit;
 
RAISE INFO 'DimProduct completed : ';

end if;
end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

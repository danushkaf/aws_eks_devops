CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factaccountinterest()
AS $$
/*
script: 		prc_load_factaccountinterest.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.deposit_transactions having count(1)>3;

IF FOUND THEN

RAISE INFO 'factaccountinterest started : ';

execute 'drop table if exists temp_deposit_transactions';

execute 'create temp table temp_deposit_transactions as select record.affected_amounts.interest_Amount,record.affected_amounts.fees_amount,record.parent_account_key from  ext_spectrum.deposit_transactions  where 
record.affected_amounts.interest_Amount<>0 or record.affected_amounts.fees_amount>0';

SELECT INTO myrec1 count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;

IF FOUND THEN

execute 'drop table if exists temp_depostaccounnt_custom';

execute 'create temp table temp_depostaccounnt_custom as 
select case when custom_field_set_id=''_ClearBank'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
max(case when custom_field_id=''accountnumber'' then custom_field_value end) as accountnumber,max(case when custom_field_id=''sortcode'' then custom_field_value end) as sortcode
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_ClearBank'' group by 1,2 
union 
select case when custom_field_set_id=''_NominatedAccount'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
max(case when custom_field_id=''accountnumber_NomAc'' then custom_field_value end) as accountnumber,max(case when custom_field_id=''sortcode_NomAc'' then custom_field_value end) as sortcode
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_NominatedAccount'' group by 1,2';

SELECT INTO myrec2 count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;

IF FOUND THEN

execute 'drop table if exists temp_deposit_accounts';

execute 'create temp table temp_deposit_accounts as select record.encoded_key,record.accrued_amounts.interest_accrued from ext_spectrum.deposit_accounts  where record.encoded_key is not null';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.factaccountinterest';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.factaccountinterest
(
  accountkey,
  interestaccruedamt,
  interestearnedamt,
  feescollected
)
WITH custom_fields AS
(
  SELECT *
  FROM temp_depostaccounnt_custom
  WHERE temp_depostaccounnt_custom.custom_field_set_id = ''_ClearBank''
)
SELECT dimaccount.accountkey,
       SUM(temp_deposit_accounts.interest_accrued),
       SUM(temp_deposit_transactions.interest_Amount),
       SUM(temp_deposit_transactions.fees_amount)
FROM temp_deposit_transactions
  LEFT JOIN temp_deposit_accounts ON (temp_deposit_accounts.encoded_key = temp_deposit_transactions.parent_account_key)
  LEFT JOIN custom_fields ON custom_fields.encoded_key = temp_deposit_accounts.encoded_key
  LEFT JOIN REDSHIFT_SCHEMA_NAME.dimaccount
         ON (dimaccount.agencyaccountnbr = custom_fields.accountnumber
        AND dimaccount.agencysortcode = custom_fields.sortcode)
GROUP BY dimaccount.accountkey';

--commit;

RAISE INFO 'factaccountinterest completed : ';

end if;
end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

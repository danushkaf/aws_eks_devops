CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factsavingstrans()
AS $$
/*
script: 		prc_load_factsavingstrans.sql
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
myrec3 int;
BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.deposit_Transactions having count(1)>3;

IF FOUND THEN

execute 'drop table if exists temp_deposit_Transactions';

execute 'create temp table temp_deposit_Transactions as
SELECT CAST(deposit_Transactions.record.id AS BIGINT),
       deposit_Transactions.record.type,
       deposit_Transactions.record.creation_Date::timestamp,
       deposit_Transactions.record.amount,
       deposit_Transactions.record.account_balances.total_balance,
       deposit_Transactions.record.affected_amounts.interest_Amount,
       deposit_Transactions.record.affected_amounts.fees_Amount,
       deposit_Transactions.record.affected_amounts.funds_Amount,
       deposit_Transactions.record.terms.interest_settings.interest_rate InterestRate,
       deposit_Transactions.record.currency_Code,
       deposit_Transactions.record.parent_account_key
FROM ext_spectrum.deposit_Transactions 
where deposit_Transactions.record.id is not null';

SELECT INTO myrec1 count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;

IF FOUND THEN

RAISE INFO 'factsavingstrans started : ';

execute 'drop table if exists temp_depostaccounnt_custom';

execute 'create temp table temp_depostaccounnt_custom as 
select case when custom_field_set_id=''_ClearBank'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
max(case when custom_field_id=''accountnumber'' then custom_field_value end) as accountnumber,max(case when custom_field_id=''sortcode'' then custom_field_value end) as sortcode
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_ClearBank'' group by 1,2';

SELECT INTO myrec2 count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;

IF FOUND THEN
execute 'drop table if exists temp_deposit_accounts';

execute 'create temp table temp_deposit_accounts as select deposit_accounts.record.encoded_key,deposit_accounts.record.account_holder_key from ext_spectrum.deposit_accounts';

SELECT INTO myrec3 count(1) FROM ext_spectrum.client having count(1)>3;

IF FOUND THEN
execute 'drop table if exists temp_client';

execute 'create temp table temp_client as select client.record.encoded_key from ext_spectrum.client';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.factsavingstrans';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.factsavingstrans
(
TransactionID,
  TYPE,
  transdatetime,
  TransactionAmt,
  BalanceAmt,
  InterestAmt,
  FeesAmt,
  FundsAmt,
  InterestRate,
  CurrencyKey,
  accountkey,
  CustomerKey)
select temp_deposit_Transactions.id,
       temp_deposit_Transactions.type,
       temp_deposit_Transactions.creation_Date,
       temp_deposit_Transactions.amount,
       temp_deposit_Transactions.total_balance,
       temp_deposit_Transactions.interest_Amount,
       temp_deposit_Transactions.fees_Amount,
       temp_deposit_Transactions.funds_Amount,
       temp_deposit_Transactions.InterestRate,
       dimcurrency.currencykey ,
              dimaccount.accountkey,
       dimcustomer.customerkey
       from temp_deposit_Transactions 
       left join REDSHIFT_SCHEMA_NAME.dimcurrency on (temp_deposit_Transactions.currency_Code=dimcurrency.currencylabel)
left JOIN temp_deposit_accounts ON (temp_deposit_Transactions.parent_account_key = temp_deposit_accounts.encoded_key)
left join temp_depostaccounnt_custom on (temp_deposit_accounts.encoded_key=temp_depostaccounnt_custom.encoded_key)
left join REDSHIFT_SCHEMA_NAME.dimaccount 
on (temp_depostaccounnt_custom.accountnumber=dimaccount.agencyaccountnbr and temp_depostaccounnt_custom.sortcode=dimaccount.agencysortcode)
left join REDSHIFT_SCHEMA_NAME.factapplication on(factapplication.applicationid=dimaccount.applicationid)
left join REDSHIFT_SCHEMA_NAME.dimcustomer on(factapplication.customerid=dimcustomer.customerid)
left join temp_client on (temp_client.encoded_key=temp_deposit_accounts.account_holder_key)';

--commit;

RAISE INFO 'factsavingstrans completed : ';

end if;
end if;
end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

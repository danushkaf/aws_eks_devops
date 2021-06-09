CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factgljournal()
AS $$
/*
script: 		prc_load_factgljournal.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.gl_journal_entry having count(1)>3;
IF FOUND THEN

RAISE INFO 'factgljournal started : ';

execute 'create temp table temp_gl_journal_entry as 
select 
record.entry_id,
record.entry_Date::timestamp,
record.creation_Date::timestamp,
record.transaction_Id,
record.account_Key,
record.amount,
record.gl_account.gl_code,
record.user_key,
record.product_Key,
row_number() over (partition by record.entry_id order by record.entry_id) duplicates
 FROM ext_spectrum.gl_journal_entry where record.entry_id is not null'; 
 
 SELECT INTO myrec1 count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;
IF FOUND THEN

execute 'drop table if exists temp_depostaccounnt_custom';

execute 'create temp table temp_depostaccounnt_custom as 
select case when custom_field_set_id=''_ClearBank'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
max(case when custom_field_id=''accountnumber'' then custom_field_value end) as accountnumber,max(case when custom_field_id=''sortcode'' then custom_field_value end) as sortcode
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_ClearBank'' group by 1,2'; 


SELECT INTO myrec2 count(1) FROM ext_spectrum.deposit_products having count(1)>3;
IF FOUND THEN

execute 'drop table if exists temp_deposit_products';

execute 'create temp table temp_deposit_products as  select record.encoded_key,record.id from ext_spectrum.deposit_products';

execute 'insert into REDSHIFT_SCHEMA_NAME.factgljournal(entryid,entrydate,transactiondate,
transactionid,
accountkey,
amount,
glaccountkey,
createdby,
productkey)
select 
temp_gl_journal_entry.entry_id::bigint,
temp_gl_journal_entry.entry_Date,
temp_gl_journal_entry.creation_Date,
temp_gl_journal_entry.transaction_Id,
dimaccount.accountKey,
temp_gl_journal_entry.amount,
dimglaccount.glaccountkey,
temp_gl_journal_entry.user_key createdby,
dimproduct.productKey
 FROM temp_gl_journal_entry
left join REDSHIFT_SCHEMA_NAME.dimglaccount on (temp_gl_journal_entry.gl_code=dimglaccount.glcode)
left  join temp_deposit_products  on (temp_deposit_products.encoded_key=temp_gl_journal_entry.product_Key)
left join REDSHIFT_SCHEMA_NAME.dimproduct on (dimproduct.productid=temp_deposit_products.id)
left join temp_depostaccounnt_custom on (temp_depostaccounnt_custom.encoded_key=temp_gl_journal_entry.account_Key)
left join REDSHIFT_SCHEMA_NAME.dimaccount on (dimaccount.agencyaccountnbr=temp_depostaccounnt_custom.accountnumber and dimaccount.agencysortcode=temp_depostaccounnt_custom.sortcode) where temp_gl_journal_entry.duplicates=1';

RAISE INFO 'factgljournal completed : ';

end if;
end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

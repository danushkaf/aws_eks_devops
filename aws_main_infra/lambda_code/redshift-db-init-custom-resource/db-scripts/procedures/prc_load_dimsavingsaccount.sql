CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimsavingaccount()
AS $$
/*
script: 		prc_load_dimsavingaccount.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
# fundingclosedate is populated from account created date + 14 days for F&F release.
*/
DECLARE
myrec int;

BEGIN


SELECT INTO myrec count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;
IF FOUND THEN

RAISE INFO 'dimsavingaccount started : ';
    
execute 'drop table if exists temp_depostaccounnt_custom';

execute 'create temp table temp_depostaccounnt_custom as 
select case when custom_field_set_id=''_Deposit_Creation'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
case when custom_field_id=''Maturity_Date'' then custom_field_value end as Maturity_Date
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_Deposit_Creation''';

execute 'drop table if exists temp_depostaccounnt_number';

execute 'create temp table temp_depostaccounnt_number as 
select case when custom_field_set_id=''_ClearBank'' then custom_field_set_id end as custom_field_set_id,
encoded_key encoded_key,
max(case when custom_field_id=''accountnumber'' then custom_field_value end) as accountnumber,max(case when custom_field_id=''sortcode'' then custom_field_value end) as sortcode
from ext_spectrum.deposit_accounts_custom where custom_field_set_id=''_ClearBank'' group by 1,2';

SELECT INTO myrec count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;
IF FOUND THEN

execute 'drop table if exists temp_depostaccounnt';

execute 'create temp table temp_depostaccounnt as 
select record.encoded_key,
record.id
,record.creation_Date::timestamp
,record.account_Type
,record.activation_Date::timestamp activation_Date
,record.closed_Date::timestamp closed_Date
,record.account_State
,record.maturity_date::timestamp maturity_date,
record.interest_settings.interest_rate_settings.interest_rate
 from ext_spectrum.deposit_accounts'; 

 
--execute 'truncate table REDSHIFT_SCHEMA_NAME.DimSavingAccount';
 
execute 'insert into REDSHIFT_SCHEMA_NAME.DimSavingAccount(CBSAccountNbr,CreatedDate,AccountSubType,ActivationDate,ClosedDate,Status,MaturityDate,fundingclosedate,interestrate) 
select id,creation_date,account_type,activation_date,closed_date,account_state,COALESCE(temp_depostaccounnt.Maturity_Date,temp_depostaccounnt_custom.Maturity_Date::timestamp) Maturity_Date,dimaccount.createdondate::date+14 fundingclosedate,temp_depostaccounnt.interest_rate
from temp_depostaccounnt 
left join temp_depostaccounnt_custom on (temp_depostaccounnt.encoded_key=temp_depostaccounnt_custom.encoded_key and temp_depostaccounnt_custom.maturity_date is not null) 
left join temp_depostaccounnt_number on (temp_depostaccounnt_number.encoded_key=temp_depostaccounnt.encoded_key)
left join REDSHIFT_SCHEMA_NAME.dimaccount on (temp_depostaccounnt_number.accountnumber=dimaccount.agencyaccountnbr and temp_depostaccounnt_number.sortcode=dimaccount.agencysortcode)
where temp_depostaccounnt.id is not null';

--commit;

RAISE INFO 'DimSavingAccount completed : ';

end if;
end if; 

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

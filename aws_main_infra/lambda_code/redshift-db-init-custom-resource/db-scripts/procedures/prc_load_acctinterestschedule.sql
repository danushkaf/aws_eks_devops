CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_acctinterestschedule()
AS $$
/*
script: 		prc_load_acctinterestschedule.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
  myrec int;
   myrec1 int;
  dataset RECORD;
  DECLARE i INTEGER := 0;
BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.deposit_accounts_custom having count(1)>0;

IF FOUND THEN

execute 'drop table if exists temp_deposit_accounts_date';

create temp table temp_deposit_accounts_date as select encoded_key,day,month from ext_spectrum.deposit_accounts_custom where month is not null and day is not null  group by 1,2,3;

execute 'drop table if exists temp_deposit_accounts_custom';

create temp table temp_deposit_accounts_custom as select encoded_key,to_char(custom_field_value::date,'yyyy') Maturity_Date from ext_spectrum.deposit_accounts_custom where custom_field_set_id='_Deposit_Creation' and custom_field_id='Maturity_Date';

SELECT INTO myrec1 count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;

IF FOUND THEN

execute 'drop table if exists temp_deposit_accounts';

create temp table temp_deposit_accounts as select record.id, record.encoded_key, to_char(record.creation_date::date,'yyyy') InterestPaymentDate, to_char(record.maturity_date::date,'yyyy') maturity_date from ext_spectrum.deposit_accounts where record.encoded_key is not null;

execute 'drop table if exists temp_acctinterestschedule';

create temp table temp_acctinterestschedule as 
select savingaccountkey, 
deposit_accounts_custom1.day,
deposit_accounts_custom1.month,
 temp_deposit_accounts.InterestPaymentDate,
 case when deposit_accounts_custom2.Maturity_Date is null then temp_deposit_accounts.Maturity_Date else deposit_accounts_custom2.Maturity_Date end MaturityDate
 from temp_deposit_accounts_date deposit_accounts_custom1 
 left join temp_deposit_accounts on (deposit_accounts_custom1.encoded_key=temp_deposit_accounts.encoded_key)
 left join temp_deposit_accounts_custom deposit_accounts_custom2 on(deposit_accounts_custom2.encoded_key=deposit_accounts_custom1.encoded_key) 
 left join REDSHIFT_SCHEMA_NAME.dimsavingaccount on (dimsavingaccount.cbsaccountnbr=temp_deposit_accounts.id)
  where savingaccountkey is not null and MaturityDate is not null;

  FOR dataset IN select savingaccountkey,day,month,interestpaymentdate,MaturityDate Maturity_Date from temp_acctinterestschedule ORDER BY savingaccountkey,InterestPaymentDate,Maturity_Date LOOP
  
  i:=dataset.InterestPaymentDate;
  
<<simple_loop_when>>
loop 

INSERT INTO REDSHIFT_SCHEMA_NAME.acctinterestschedule(savingaccountkey,interestpaymentdate) values (dataset.savingaccountkey,to_date(dataset.day||'-'||dataset.month||'-'||i,'dd-mm-yyyy')::date);

EXIT simple_loop_when WHEN (i >= dataset.Maturity_Date);
i := i + 1;
end loop;
    
end loop;
	
end if;
end if;
END;
$$ LANGUAGE plpgsql;   
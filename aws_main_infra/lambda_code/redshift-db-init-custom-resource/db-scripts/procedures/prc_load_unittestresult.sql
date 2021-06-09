CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_unittestresult()
AS $$
/*
script: 		prc_load_unittestresult.sql
purpose: 		This will populate unit test result data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;
myrec1 int;

BEGIN

insert into xyz_stg.stg_unit_test_result (loadtype,TableName,cnt,ext_dwh) 
select 'DWH_LOAD' loadtype, 'factsavingstrans' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factsavingstrans
union 
select 'DWH_LOAD' loadtype, 'factsavingstrans' TableName,  count(1), 'ext' ext_dwh from ext_spectrum.deposit_transactions where record.id is not null
union all
select 'DWH_LOAD' loadtype, 'factacctbalssdaily' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factacctbalssdaily
union
select 'DWH_LOAD' loadtype, 'factacctbalssdaily' TableName, count(1) , 'ext' ext_dwh from (select factsavingstrans.accountkey, transdatetime::date from REDSHIFT_SCHEMA_NAME.factsavingstrans  group by factsavingstrans.accountkey,transdatetime::date)
union all
select 'DWH_LOAD' loadtype, 'factnotificationevent' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factnotificationevent
union
select 'DWH_LOAD' loadtype, 'factnotificationevent' TableName, count(1) cnt , 'ext' ext_dwh from  ext_spectrum.notification_history
union all
select 'DWH_LOAD' loadtype, 'nationalitymaster' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.nationalitymaster
union
select 'DWH_LOAD' loadtype, 'nationalitymaster' TableName, count(1) cnt , 'ext' ext_dwh from  ext_spectrum.nationalities
union all
select 'DWH_LOAD' loadtype, 'factaccountinterest' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factaccountinterest
union
select 'DWH_LOAD' loadtype, 'factaccountinterest' TableName, count(distinct record.parent_account_key), 'ext' ext_dwh  from  ext_spectrum.deposit_transactions where record.affected_amounts.interest_Amount is not null or record.affected_amounts.fees_amount is not null
union all
select 'DWH_LOAD' loadtype, 'dimsavingaccount' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimsavingaccount
union
select 'DWH_LOAD' loadtype, 'dimsavingaccount' TableName, count(record.encoded_key) cnt, 'ext' ext_dwh  from  ext_spectrum.deposit_accounts where record.id is not null
union all
select 'DWH_LOAD' loadtype, 'dimproduct' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimproduct
union
select 'DWH_LOAD' loadtype, 'dimproduct' TableName, count(record.encoded_key) cnt, 'ext' ext_dwh  from  ext_spectrum.deposit_products where record.encoded_key is not null
union all
select 'DWH_LOAD' loadtype, 'dimnominatedaccount' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimnominatedaccount
union
select 'DWH_LOAD' loadtype, 'dimnominatedaccount' TableName, count(1) cnt, 'ext' ext_dwh  from  ext_spectrum.nominatedaccount
union all
select 'DWH_LOAD' loadtype, 'dimglaccount' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimglaccount 
union
select 'DWH_LOAD' loadtype, 'dimglaccount' TableName,count(record.gl_code), 'ext' ext_dwh  from ext_spectrum.gl_account where record.gl_code IS NOT NULL
union all
select 'DWH_LOAD' loadtype, 'dimgeography' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimgeography
union
select 'DWH_LOAD' loadtype, 'dimgeography' TableName,count(1) cnt, 'ext' ext_dwh  from (select city, county from ext_spectrum.address group by 1,2)
union all
select 'DWH_LOAD' loadtype, 'dimcurrency' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimcurrency
union
select 'DWH_LOAD' loadtype, 'dimcurrency' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.currency
union all
select 'DWH_LOAD' loadtype, 'factapplication' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factapplication
union
select 'DWH_LOAD' loadtype, 'factapplication' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.application
union all
select 'DWH_LOAD' loadtype, 'dimcustomer' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimcustomer
union
select 'DWH_LOAD' loadtype, 'dimcustomer' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.customerprofile
union all
select 'DWH_LOAD' loadtype, 'dimaccount' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.dimaccount
union
select 'DWH_LOAD' loadtype, 'dimaccount' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.account
union all
select 'DWH_LOAD' loadtype, 'custtaxresidency' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.custtaxresidency
union
select 'DWH_LOAD' loadtype, 'custtaxresidency' TableName, count(1) , 'ext' ext_dwh from (
select id,TaxResidency1  from ext_spectrum.customerprofile where TaxResidency1<>'' union all
select id,TaxResidency2  from ext_spectrum.customerprofile where TaxResidency2<>'' union all
select id,TaxResidency3  from ext_spectrum.customerprofile where TaxResidency3<>'')
union all
select 'DWH_LOAD' loadtype, 'customer_x_account' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.customer_x_account
union
select 'DWH_LOAD' loadtype, 'customer_x_account' TableName,count(1) cnt, 'ext' ext_dwh  from (SELECT factapplication.customerkey,
       dimaccount.accountkey,
       dimaccount.accounttype
FROM REDSHIFT_SCHEMA_NAME.factapplication,
     REDSHIFT_SCHEMA_NAME.dimaccount
WHERE factapplication.applicationid = dimaccount.applicationid group by 1,2,3)
union all
select 'DWH_LOAD' loadtype, 'custcitizenship' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.custcitizenship
union
select 'DWH_LOAD' loadtype, 'custcitizenship' TableName,count(1), 'ext' ext_dwh  from (
select id,Citizenship1 from ext_spectrum.CustomerProfile where Citizenship1 is not null 
union
select id,Citizenship2 from ext_spectrum.CustomerProfile where Citizenship2 is not null 
union
select id,Citizenship3 from ext_spectrum.CustomerProfile where Citizenship3 is not null 
union
select id,Citizenship4 from ext_spectrum.CustomerProfile where Citizenship4 is not null 
union
select id,Citizenship5 from ext_spectrum.CustomerProfile where Citizenship5 is not null)
union all
select 'DWH_LOAD' loadtype, 'countrymaster' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.countrymaster
union
select 'DWH_LOAD' loadtype, 'countrymaster' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.countriesmaster 
union all
select 'DWH_LOAD' loadtype, 'custaddrdetails' TableName,count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.custaddrdetails
union
select 'DWH_LOAD' loadtype, 'custaddrdetails' TableName,count(1) cnt, 'ext' ext_dwh  from ext_spectrum.address
union all
select 'DWH_LOAD' loadtype, 'addresshistory' TableName,cnt , 'dwh' ext_dwh from (select custaddrdetails.customerkey, count(1) cnt from REDSHIFT_SCHEMA_NAME.customeraddresshistory 
inner join REDSHIFT_SCHEMA_NAME.custaddrdetails on (custaddrdetails.custaddrdtlkey=customeraddresshistory.custaddrdtlkey) group by 1 having count(1)>1)
union
select 'DWH_LOAD' loadtype, 'addresshistory' TableName, count(1) cnt, 'ext' ext_dwh   from ext_spectrum.addresshistory
union all
select 'DWH_LOAD' loadtype, 'customerdetailshistory' TableName, count(1) cnt, 'ext' ext_dwh   from ext_spectrum.customerdetailschangehistory
union
select  'DWH_LOAD' loadtype, 'customerdetailshistory' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.customerdetailshistory
union all
select 'DWH_LOAD' loadtype, 'factgljournal' TableName, count(1) cnt , 'ext' ext_dwh  from ext_spectrum.gl_journal_entry where record.entry_id is not null
union
select  'DWH_LOAD' loadtype, 'factgljournal' TableName, count(1) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.factgljournal
union all
select 'DWH_LOAD' loadtype, 'acctinterestschedule' TableName,count(distinct savingaccountkey) cnt, 'dwh' ext_dwh from REDSHIFT_SCHEMA_NAME.acctinterestschedule
union
select 'DWH_LOAD' loadtype, 'acctinterestschedule' TableName, count(distinct savingaccountkey), 'ext' ext_dwh  from ext_spectrum.deposit_accounts_custom,ext_spectrum.deposit_accounts,REDSHIFT_SCHEMA_NAME.dimsavingaccount,ext_spectrum.deposit_accounts_custom maturity
where deposit_accounts.record.encoded_key=deposit_accounts_custom.encoded_key and dimsavingaccount.cbsaccountnbr=deposit_accounts.record.id and deposit_accounts_custom.encoded_key =maturity.encoded_key and maturity.custom_field_set_id='_Deposit_Creation' and maturity.custom_field_id='Maturity_Date'
and case when deposit_accounts.record.maturity_date is null then maturity.custom_field_value else deposit_accounts.record.maturity_date end is not null;

insert into xyz_stg.stg_source_tracking(sourcetable,extractedon)  
select 'account' sourcetable, case when max(updatedon) > max(createdon)then max(updatedon) else max(createdon) end extractedon  from ext_spectrum.account union all 
select 'address' sourcetable, case when max(updatedon) > max(createdon)then max(updatedon) else max(createdon) end extractedon  from ext_spectrum.address union all 
select 'addresshistory' sourcetable, max(createdon) from ext_spectrum.addresshistory union all 
select 'application' sourcetable, case when max(updatedon) > max(createdon)then max(updatedon) else max(createdon) end extractedon  from ext_spectrum.application union all 
select 'customerprofile' sourcetable, case when max(updatedon) > max(createdon)then max(updatedon) else max(createdon) end extractedon  from ext_spectrum.customerprofile union all 
select 'customerdetailschangehistory' sourcetable, max(createdon) from ext_spectrum.customerdetailschangehistory union all 
select 'nominatedaccount' sourcetable, case when max(updatedon) > max(createdon)then max(updatedon) else max(createdon) end extractedon  from ext_spectrum.nominatedaccount union all 
select 'notification_history' sourcetable, case when max(updated_time) > max(creation_time)then max(updated_time) else max(creation_time) end extractedon  from ext_spectrum.notification_history union all 
select 'account_details' sourcetable,  case when max(updated_time) > max(creation_time)then max(updated_time) else max(creation_time) end extractedon  from ext_spectrum.account_details union all 
select 'client' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon  from ext_spectrum.client where time_extracted<>'' union all 
select 'deposit_accounts' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon from ext_spectrum.deposit_accounts where time_extracted<>'' union all 
select 'deposit_products' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon  from ext_spectrum.deposit_products where time_extracted<>'' union all 
select 'deposit_transactions' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon from ext_spectrum.deposit_transactions where time_extracted<>'' union all 
select 'gl_account' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon  from ext_spectrum.gl_account where time_extracted<>'' union all 
select 'gl_journal_entry' sourcetable, max( to_char(time_extracted::timestamp,'yyyy-mm-dd hh:mi:ss')) extractedon from ext_spectrum.gl_journal_entry where time_extracted<>'';

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_factnotievent()
AS $$
/*
script: 		prc_load_factnotievent.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.notification_history having count(1)>0;

IF FOUND THEN

RAISE INFO 'factnotievent started : ';

execute 'drop table if exists temp_notification_history';

execute 'create temp table temp_notification_history as select account_number,client_id,creation_time::timestamp creation_time,updated_time::timestamp updated_time, replace(replace(replace(event_params,''""'',''"''),''"{'',''{''),''}"'',''}'') event_params,notification_code,channel_type,trim(template_code) template_code,template_name from ext_spectrum.notification_history';


SELECT INTO myrec1 count(1) FROM ext_spectrum.client having count(1)>3;
IF FOUND THEN
execute 'drop table if exists temp_client';

execute 'create temp table temp_client as select record.encoded_key , record.id from ext_spectrum.client';

SELECT INTO myrec2 count(1) FROM ext_spectrum.deposit_accounts having count(1)>3;
IF FOUND THEN

execute 'drop table if exists temp_deposit_accounts';

execute 'create temp table temp_deposit_accounts as select record.account_holder_key,record.id from ext_spectrum.deposit_accounts  where record.account_holder_type=''CLIENT''';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.factnotificationevent';

execute 'INSERT INTO REDSHIFT_SCHEMA_NAME.factnotificationevent
(
  eventcreatedatetime,
  eventmoddatetime,
  eventparams,
  notification_code,
  channeltype,
  templatecode,
  templatename,
  accountkey,
  customerkey
)
select creation_time::timestamp,updated_time::timestamp,event_params,notification_code,channel_type,template_code,template_name,
case when dimaccount.accountkey is null then dimaccount1.accountkey else dimaccount.accountkey end accounttkey,case when dimcustomer.customerkey is null then dimcustomer1.customerkey else dimcustomer.customerkey end customerrkey
 from temp_notification_history
 left join temp_client on (temp_notification_history.client_id=temp_client.id)
 left join temp_deposit_accounts on(temp_deposit_accounts.account_holder_key=temp_client.encoded_key)
 left join REDSHIFT_SCHEMA_NAME.dimsavingaccount on (dimsavingaccount.cbsaccountnbr=temp_deposit_accounts.id)
 left join REDSHIFT_SCHEMA_NAME.dimaccount on (dimaccount.savingacctkey=dimsavingaccount.savingaccountkey)
 left join REDSHIFT_SCHEMA_NAME.factapplication on (dimaccount.applicationid=factapplication.applicationid)
 left join REDSHIFT_SCHEMA_NAME.dimcustomer on (dimcustomer.customerid=factapplication.customerid)
 left join REDSHIFT_SCHEMA_NAME.dimsavingaccount dimsavingaccount1 on (temp_notification_history.account_number=dimsavingaccount1.cbsaccountnbr)
 left join REDSHIFT_SCHEMA_NAME.dimaccount dimaccount1 on (dimaccount1.savingacctkey=dimsavingaccount1.savingaccountkey)
 left join REDSHIFT_SCHEMA_NAME.factapplication factapplication1 on (dimaccount1.applicationid=factapplication1.applicationid) 
  left join REDSHIFT_SCHEMA_NAME.dimcustomer dimcustomer1 on (dimcustomer1.customerid=factapplication1.customerid)
  group by creation_time::timestamp,updated_time::timestamp,event_params,notification_code,channel_type,template_code,template_name,accounttkey,customerrkey';
 
--commit;

--select split_part(split_part(regexp_replace(replace(replace(replace(replace(event_params,'{','"'),'}','"'),'[','"'),']','"'),'"'),',',1),':',1),
--split_part(split_part(regexp_replace(replace(replace(replace(replace(event_params,'{','"'),'}','"'),'[','"'),']','"'),'"'),',',1),':',2)
--,split_part(split_part(regexp_replace(replace(replace(replace(replace(event_params,'{','"'),'}','"'),'[','"'),']','"'),'"'),',',2) ,':',1)
--,split_part(split_part(regexp_replace(replace(replace(replace(replace(event_params,'{','"'),'}','"'),'[','"'),']','"'),'"'),',',2),':',2)
--from ext_spectrum.notification_history;

RAISE INFO 'factnotievent completed : ';

end if;
end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

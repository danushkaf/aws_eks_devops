CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimaccount()
AS $$
/*
script: 		prc_load_dimaccount.sql
purpose: 		This will populate data in dwh schema.
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/
DECLARE
myrec int;
myrec1 int;

BEGIN

SELECT INTO myrec count(1) FROM ext_spectrum.account having count(1)>0;
IF FOUND THEN

SELECT INTO myrec1 count(1) FROM ext_spectrum.account_details having count(1)>0;
IF FOUND THEN

RAISE INFO 'dimaccount started';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.dimaccount';

execute 'insert into REDSHIFT_SCHEMA_NAME.dimaccount(accountid,
NominatedAcctKey,AgencySortCode,AgencyAccountNbr,AgencyAccountNbr_Last4,
Status,CreatedOnDate,CreatedBy,UpdatedonDate,UpdatedBy,Comments,SavingAcctKey,ApplicationID,AccountType)
select account.id,dimnominatedaccount.accountkey NominatedAcctKey
,account.AgencySortCode
,account.AgencyAccountNumber
,account_details.account_number_display
,account.Status
,account.CreatedOn::timestamp
,account.CreatedBy
,account.UpdatedOn::timestamp
,account.UpdatedBy
,account.Comments 
,dimsavingaccount.savingaccountkey
,account.applicationid
,dimsavingaccount.accountsubtype
from ext_spectrum.account 
left join REDSHIFT_SCHEMA_NAME.dimnominatedaccount on (dimnominatedaccount.nominatedacctid=account.nominatedaccountid) 
left join REDSHIFT_SCHEMA_NAME.dimsavingaccount on (account.cbsaccountnumber=dimsavingaccount.cbsaccountnbr)
left join ext_spectrum.account_details on (account_details.mambu_account_id=account.cbsaccountnumber)';

RAISE INFO 'dimaccount completed';

execute 'create temp table temp_parent as select agencyaccountnumber,agencysortcode,id from ext_spectrum.account where agencyaccountnumber is not null and agencysortcode is not null';

execute 'create temp table temp_account_parent as 
with parent_data as (select account.id,account.agencyaccountnumber,account.agencysortcode,  account.parentaccountid, parentacc.agencyaccountnumber nbr,parentacc.agencysortcode code
from  ext_spectrum.account left join temp_parent parentacc on (parentacc.id=account.parentaccountid and account.agencyaccountnumber is not null and account.agencysortcode is not null) )
select parent_data.agencyaccountnumber,parent_data.agencysortcode,dimaccount.accountkey from parent_data  
left join    REDSHIFT_SCHEMA_NAME.dimaccount on( dimaccount.agencyaccountnbr=nbr and dimaccount.agencysortcode=code)
where dimaccount.accountkey is not null';

RAISE INFO 'dimaccount temp completed';

execute 'update REDSHIFT_SCHEMA_NAME.dimaccount set parentacctkey=temp_account_parent.accountkey from temp_account_parent 
where temp_account_parent.agencyaccountnumber=dimaccount.agencyaccountnbr 
and temp_account_parent.agencysortcode=dimaccount.agencysortcode and dimaccount.parentacctkey is null 
and dimaccount.agencyaccountnbr is not null and temp_account_parent.accountkey is not null';

RAISE INFO 'dimaccount update completed';

--commit;

end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

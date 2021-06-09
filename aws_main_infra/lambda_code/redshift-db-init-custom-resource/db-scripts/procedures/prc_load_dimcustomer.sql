CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_dimcustomer()
AS $$
/*
script: 		prc_load_dimcustomer.sql
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

SELECT INTO myrec count(1) FROM ext_spectrum.customerprofile having count(1)>0;
IF FOUND THEN

SELECT INTO myrec1 count(1) FROM ext_spectrum.client having count(1)>3;
IF FOUND THEN

RAISE INFO 'dimcustomer started : ';

EXECUTE 'drop table if exists temp_client'; 

EXECUTE 'create temp table temp_client as 
select record.id clientid,record.mobile_Phone
,record.gender
,record.notes
,record.approved_Date::timestamp approved_Date
,record.activation_Date::timestamp activation_Date
,record.activation_Date::timestamp closedDate from ext_spectrum.client';

RAISE INFO 'dimcustomer temp completed : ';

--execute 'truncate table REDSHIFT_SCHEMA_NAME.dimcustomer';

execute 'insert into REDSHIFT_SCHEMA_NAME.dimcustomer (customerID,Title,FirstName,MiddleName,LastName,DOB,BirthPlace,Nationality,Email,CustRefNumber,IsCustomerVerified,IsEmailVerified,IsMobilePhoneVerified,IsLandlineVerified,LandlinePhone,MobilePhone,Gender,Notes,ApprovedDate,ActivationDate,ClosedDate,CreatedDate,UpdatedDate)
SELECT id
,Title
,FirstName
,MiddleName
,LastName
,DateOfBirth::date DateOfBirth
,PlaceOfBirth
,nationalitymaster.name Nationality
,EmailAddress
,CustomerReferenceNo
,cast(IsVerifiedCustomer as boolean)
,cast(IsVerifiedEmail as boolean)
,cast(IsVerifiedPhoneNumber as boolean)
,cast(IsVerifiedLandlineNumber as boolean)
,LandlineNumber
,temp_client.mobile_Phone
,temp_client.gender
,temp_client.notes
,temp_client.approved_Date
,temp_client.activation_Date
,temp_client.activation_Date
,customerprofile.CreatedOn::timestamp CreatedOn
,customerprofile.UpdatedOn::timestamp UpdatedOn
FROM ext_spectrum.customerprofile 
left join REDSHIFT_SCHEMA_NAME.nationalitymaster on (customerprofile.NationalityId=nationalitymaster.NationalityId) 
left join temp_client on (temp_client.clientid=customerprofile.CustomerReferenceNo)';

--commit;

RAISE INFO 'dimcustomer completed : ';

end if;
end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

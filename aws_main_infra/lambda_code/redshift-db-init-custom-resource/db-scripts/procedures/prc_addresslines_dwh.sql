create OR REPLACE PROCEDURE xyz_stg.prc_addresslines()
as $$
BEGIN
--EXECUTE 'Truncate table REDSHIFT_SCHEMA_NAME.addresslines_fscs';
EXECUTE 'create temp table addresslines
as 
select
DimCust.CustRefNumber,
CustAddrdet.addressline1 as addressline1, 
CustAddrdet.addressline2 as addressline2,
CustAddrdet.addressline3 as addressline3,
Dimgeo.city as addressline4,
Dimgeo.county as addressline5, 
CustAddrdet.PostalCode,
Dimgeo.Country,
DimCust.Email,
DimCust.LandlinePhone,
DimCust.MobilePhone
FROM xyz_DWH.DimCustomer DimCust LEFT JOIN xyz_DWH.custaddrdetails CustAddrdet ON
DimCust.customerkey=CustAddrdet.customerkey INNER JOIN REDSHIFT_SCHEMA_NAME.customeraddresshistory Custaddhist on CustAddrdet.custaddrdtlkey=Custaddhist.custaddrdtlkey and Custaddhist.expirydate is null LEFT JOIN xyz_DWH.DimGeography Dimgeo ON CustAddrdet.GeographyKey=Dimgeo.GeographyKey';



--Column A updates
UPDATE addresslines
SET addressline1 = addressline2, addressline2 = ''
WHERE addressline1 = '';


UPDATE addresslines
SET addressline1 = addressline3, addressline3 = ''
WHERE addressline1 = '';


UPDATE addresslines
SET addressline1 = addressline4, addressline4 = ''
WHERE addressline1 = '';


UPDATE addresslines
SET addressline1 = addressline5, addressline5 = ''
WHERE addressline1 = '';


--Column B updates
UPDATE addresslines
SET addressline2 = addressline3, addressline3 = ''
WHERE addressline2 = '';


UPDATE addresslines
SET addressline2 = addressline4, addressline4 = ''
WHERE addressline2 = '';


UPDATE addresslines
SET addressline2 = addressline5, addressline5 = ''
WHERE addressline2 = '';


--Update C Column
UPDATE addresslines
SET addressline3 = addressline4, addressline4 = ''
WHERE addressline3 = '';


UPDATE addresslines
SET addressline3 = addressline5, addressline5 = ''
WHERE addressline3 = '';


--Update D Column
UPDATE addresslines
SET addressline4 = addressline5, addressline5 = ''
WHERE addressline4 = '';

EXECUTE 'insert into REDSHIFT_SCHEMA_NAME.addresslines_fscs
(
addressline1,
addressline2,
addressline3,
addressline4,
addressline5,
country,
custrefnumber,
email,
landlinephone,
mobilephone,
postalcode
)
SELECT addressline1,
addressline2,
addressline3,
addressline4,
addressline5,
country,
custrefnumber,
email,
landlinephone,
mobilephone,
postalcode FROM addresslines';


--COMMIT;
END;
$$ LANGUAGE plpgsql;


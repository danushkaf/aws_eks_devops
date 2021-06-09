CREATE OR REPLACE PROCEDURE xyz_stg.prc_load_custtaxresidency()
AS $$
/*
script: 		prc_load_custtaxresidency.sql
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

--execute 'truncate table REDSHIFT_SCHEMA_NAME.custtaxresidency';

RAISE INFO 'custtaxresidency started : ';

execute 'insert into REDSHIFT_SCHEMA_NAME.custtaxresidency(CustomerKey,CountryKey,taxidentificationnbr,ordinal)
with 
CustTaxRes as (select id,TaxResidency1,TaxResidency2,TaxResidency3,TaxIdentificationNumber1,TaxIdentificationNumber2,TaxIdentificationNumber3 from ext_spectrum.customerprofile where TaxResidency1<>''''  or TaxResidency2<>'''' or TaxResidency3<>''''),
Countries as (select countryid, countrykey, name from REDSHIFT_SCHEMA_NAME.countrymaster)
select CustomerKey,Countries.countrykey, src.TaxIdentificationNumber,row_number() over (partition by  CustomerKey order by CustomerKey ) ordinal  
from  CustTaxRes inner join REDSHIFT_SCHEMA_NAME.dimcustomer on (CustTaxRes.id=dimcustomer.customerid) 
inner join
(select  CustTaxRes.id,TaxResidency1 TaxResidency,TaxIdentificationNumber1 TaxIdentificationNumber from CustTaxRes where TaxResidency1<>''''
union 
select  CustTaxRes.id,TaxResidency2 TaxResidency,TaxIdentificationNumber2 TaxIdentificationNumber from CustTaxRes where TaxResidency2<>''''
union
select  CustTaxRes.id,TaxResidency3 TaxResidency,TaxIdentificationNumber3 TaxIdentificationNumber from CustTaxRes where TaxResidency3<>''''
)  src on src.id=CustTaxRes.id inner join Countries on (Countries.countryid=src.TaxResidency)';

RAISE INFO 'custtaxresidency completed : ';

--commit;

end if;

EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

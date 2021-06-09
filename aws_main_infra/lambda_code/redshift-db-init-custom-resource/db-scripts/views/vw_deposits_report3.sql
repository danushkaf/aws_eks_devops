create or replace view REDSHIFT_SCHEMA_NAME.vw_deposits_report3 as
SELECT DISTINCT
NAME,
ProductID,
Account_No,
Product_name_Product_ID,
COUNT(DISTINCT AgencyAccountNbr) ZERO_BALANCE,
Failure_to_meet_min_balance,
Value_of_funds_returned
FROM(
SELECT DISTINCT
DPROD.NAME,
DPROD.ProductID,
DACC.AgencyAccountNbr AS Account_No,
DPROD.NAME||'('||DPROD.ProductID||')' AS Product_name_Product_ID,
DACC.AgencyAccountNbr,
'' as Failure_to_meet_min_balance,
'' as Value_of_funds_returned,
SUM(transactionamt) OVER(PARTITION BY FACTSAV.customerkey,FACTSAV.AccountKey) AS BALANCEAMOUNT_CALCULATED
FROM xyz_DWH.DimAccount DACC INNER JOIN xyz_DWH.FactSavingsTrans FACTSAV ON
DACC.AccountKey=FACTSAV.AccountKey LEFT JOIN xyz_DWH.vw_FactApplication FACTAPP
ON DACC.APPLICATIONID=FACTAPP.APPLICATIONID
LEFT JOIN xyz_DWH.vw_DimProduct DPROD ON DPROD.Productkey = FACTAPP.productkey
WHERE (FACTAPP.APPLICATIONID,FACTAPP.UPDATEDATE) IN(select applicationid,max(updatedate) from xyz_DWH.factapplication group by applicationid)
) WHERE BALANCEAMOUNT_CALCULATED<='0'
GROUP BY NAME,ProductID,Account_No,Product_name_Product_ID,Failure_to_meet_min_balance,Value_of_funds_returned
;
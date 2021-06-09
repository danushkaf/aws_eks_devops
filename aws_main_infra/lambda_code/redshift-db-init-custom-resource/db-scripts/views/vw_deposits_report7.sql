create or replace view REDSHIFT_SCHEMA_NAME.vw_deposits_report7 as
SELECT
DPROD.NAME,
DPROD.ProductID,
DPROD.NAME||'('||DPROD.ProductID||')' AS Product_name_Product_ID,
count(DACC.AgencyAccountNbr) AS #_of_Accounts,
SUM(FACTSAV.BalanceAmt) AS TOTAL_BALANCE,
AVG(FACTSAV.BalanceAmt) AS AVG_BALANCE
FROM xyz_DWH.DimAccount DACC LEFT JOIN xyz_DWH.FactSavingsTrans FACTSAV ON
DACC.AccountKey=FACTSAV.AccountKey LEFT JOIN xyz_DWH.vw_FactApplication FACTAPP
ON DACC.APPLICATIONID=FACTAPP.applicationid 
LEFT JOIN xyz_DWH.vw_DimProduct DPROD ON DPROD.Productkey = FACTAPP.productkey
WHERE (FACTSAV.AccountKey,FACTSAV.transdatetime) IN(SELECT AccountKey,MAX(transdatetime)
FROM xyz_DWH.FactSavingsTrans GROUP BY AccountKey) AND (FactApp.APPLICATIONID,FactApp.UPDATEDATE) IN(select applicationid,max(updatedate) from xyz_DWH.vw_FactApplication group by applicationid)
GROUP BY NAME,DPROD.ProductID,Product_name_Product_ID
;

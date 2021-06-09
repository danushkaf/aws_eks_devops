create or replace view REDSHIFT_SCHEMA_NAME.vw_deposits_report1 as
SELECT
DimProd.NAME,
DimProd.ProductID,
DimProd.NAME||'('||DimProd.ProductID||')' AS Product_name_Product_ID,
DimAcc.AgencyAccountNbr AS Account_No,
FactApp.PledgedAmt AS Indicative_Deposit_Amount,
SUM(FactSavTrans.TransactionAmt) AS Actual_Deposit_Amount,
Actual_Deposit_Amount-Indicative_Deposit_Amount AS Difference
FROM REDSHIFT_SCHEMA_NAME.DimAccount DimAcc LEFT JOIN REDSHIFT_SCHEMA_NAME.FactsavingsTrans FactSavTrans ON
DimAcc.AccountKey=FactSavTrans.AccountKey LEFT JOIN REDSHIFT_SCHEMA_NAME.vw_FactApplication FactApp
ON DimAcc.Applicationid=FactApp.applicationid 
LEFT JOIN REDSHIFT_SCHEMA_NAME.vw_DimProduct DimProd ON DimProd.Productkey = FactApp.productkey
WHERE FactSavTrans.type='DEPOSIT'AND (FactApp.APPLICATIONID,FactApp.UPDATEDATE) IN(select applicationid,max(updatedate) from REDSHIFT_SCHEMA_NAME.vw_FactApplication group by applicationid)
GROUP BY NAME,DimProd.ProductID,Product_name_Product_ID,Account_No,Indicative_Deposit_Amount
;
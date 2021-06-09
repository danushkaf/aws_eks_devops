create or replace view REDSHIFT_SCHEMA_NAME.vw_deposits_report5 as
SELECT * FROM(
SELECT distinct 
DPROD.NAME,
DPROD.ProductID,
DPROD.NAME||'('||DPROD.ProductID||')' AS Product_name_Product_ID,
DACC.AgencyAccountNbr AS Account_No,
DACC.Comments AS Withdrawal_Reason,
FACTSAV.TransactionAmt*-1 AS Amount_Withdrawn,
FACTSAV.BalanceAmt AS REMAINING_BALANCE,
DIMSA.maturitydate as Maturity_date,
FACTSAV.transdatetime AS DATE_OF_WITHDRAWAL,
CAST(FACTSAV.transdatetime AS DATE) AS DT_DATE_OF_WITHDRAWAL,
TO_CHAR(DATE_OF_WITHDRAWAL,'MON')||'-'||TO_CHAR(DATE_OF_WITHDRAWAL,'YY') AS MONTH_AND_YEAR_WITHDRAWAL
FROM xyz_DWH.DimAccount DACC LEFT JOIN xyz_DWH.FactSavingsTrans FACTSAV ON
DACC.AccountKey=FACTSAV.AccountKey AND FACTSAV.TYPE='WITHDRAWAL' 
LEFT JOIN xyz_DWH.vw_FactApplication FACTAPP
ON DACC.APPLICATIONID=FACTAPP.applicationid
LEFT JOIN xyz_DWH.vw_DimProduct DPROD ON DPROD.Productkey = FACTAPP.productkey
LEFT JOIN xyz_DWH.DimSavingAccount DIMSA ON
DIMSA.SavingAccountKey=DACC.SavingAcctKey
WHERE FACTSAV.transdatetime<DIMSA.maturitydate
AND (FactApp.APPLICATIONID,FactApp.UPDATEDATE) IN(select applicationid,max(updatedate) from xyz_DWH.vw_FactApplication group by applicationid)
)O WHERE Amount_Withdrawn IS NOT NULL
;

create or replace view REDSHIFT_SCHEMA_NAME.vw_fscs_details_of_accounts as 
SELECT 'Single customer view record number|Account title|Account number|BIC|IBAN|Sort code|Product type|Product name|Account holder indicator|Account status code|Exclusion type|Recent transactions.|Account branch jurisdiction.|BRRD marking|Structured deposit accounts|Account balance in sterling|Authorised negative balances|Currency of account|Account balance in original currency|Exchange rate|Original account balance before interest|Transferable eligible deposit' as Header, '1' as sortby 

UNION
SELECT 
cast(isnull(Single_customer_view_record_number, '') AS VARCHAR)+'|'+
'' +'|'+
cast(isnull(ACCOUNT_NUMBER, '') AS VARCHAR)+'|'+
'' +'|'+
'' +'|'+
cast(isnull(SORT_CODE, '') AS VARCHAR)+'|'+
cast(isnull(PRODUCT_TYPE, '') AS VARCHAR)+'|'+
cast(isnull(PRODUCT_NAME, '') AS VARCHAR)+'|'+
cast(isnull(ACCOUNT_HOLDER_INDICATOR, '') AS VARCHAR)+'|'+
'FFSTP' +'|'+
'' +'|'+
cast(isnull(RECENT_TRANSACTIONS, '') AS VARCHAR)+'|'+
'' +'|'+
'Yes' +'|'+
'No' +'|'+
cast(isnull(cast(SUM(Account_balance_in_sterling) as decimal(10,2)), 0) AS VARCHAR)+'|'+
'0.00' +'|'+
'GBP' +'|'+
cast(isnull(cast(SUM(Account_balance_in_original_currency) as decimal(10,2)), 0) AS VARCHAR)+'|'+
'1.00' +'|'+
cast(isnull(cast(SUM(Original_account_balance_before_interest) as decimal(10,2)), 0) AS VARCHAR)+'|'+
cast(isnull(cast(SUM(Transferable_eligible_deposit) as decimal(10,2)), 0) AS VARCHAR)as Header , '2' as sortby
FROM(
SELECT
DIMC.CustRefNumber AS Single_customer_view_record_number,
DACC.AgencyAccountNbr AS ACCOUNT_NUMBER,
DACC.AgencySortCode AS SORT_CODE,
CASE WHEN DATE_DIFF('YEAR',DIMSA.maturitydate,DIMSA.CreatedDate)<'1' THEN 'FD1' END AS PRODUCT_TYPE,
DPROD.NAME AS PRODUCT_NAME,
CASE WHEN DIMSA.AccountSubType='sole' THEN '001' ELSE DIMSA.AccountSubType END AS ACCOUNT_HOLDER_INDICATOR,
CASE WHEN DATE_DIFF('MONTH',CAST(FACTSAV.transdatetime AS DATE),CURRENT_DATE)<'24' THEN 'YES' ELSE 'NO' END AS RECENT_TRANSACTIONS,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY DACC.AccountKey ORDER BY FACTSAV.transdatetime DESC)='1' THEN BalanceAmt ELSE '0' END AS Account_balance_in_sterling,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY DACC.AccountKey ORDER BY FACTSAV.transdatetime DESC)='1' THEN BalanceAmt ELSE '0' END AS Account_balance_in_original_currency,
CASE WHEN FACTSAV.TYPE<>'INTEREST_APPLIED' THEN TransactionAmt ELSE '0' END AS Original_account_balance_before_interest,
CASE WHEN FACTSAV.TYPE='DEPOSIT' THEN TransactionAmt ELSE '0' END AS Transferable_eligible_deposit
FROM xyz_DWH.DimCustomer DIMC LEFT JOIN xyz_DWH.FactSavingsTrans FACTSAV ON
DIMC.CustomerKey=FACTSAV.CustomerKey INNER JOIN xyz_DWH.DimAccount DACC ON
DACC.AccountKey=FACTSAV.AccountKey INNER JOIN xyz_DWH.DimSavingAccount DIMSA ON
DIMSA.SavingAccountKey=DACC.SavingAcctKey
LEFT JOIN xyz_DWH.vw_FactApplication FACTAPP
ON DACC.Applicationid=FACTAPP.applicationid 
LEFT JOIN xyz_DWH.vw_DimProduct DPROD ON DPROD.Productkey = FACTAPP.productkey
WHERE (FactApp.APPLICATIONID,FactApp.UPDATEDATE) IN(select applicationid,max(updatedate) from xyz_DWH.vw_FactApplication group by applicationid)
)O
GROUP BY Single_customer_view_record_number,ACCOUNT_NUMBER,SORT_CODE,PRODUCT_TYPE,PRODUCT_NAME,ACCOUNT_HOLDER_INDICATOR,RECENT_TRANSACTIONS

UNION
SELECT '99999999999999999999' AS Header , '3' as sortby
order by sortby asc
;

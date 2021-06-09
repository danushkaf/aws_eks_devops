create or replace view REDSHIFT_SCHEMA_NAME.vw_fscs_aggregate_balance as
SELECT 'Single customer view record number|Aggregate balance in sterling|Compensatable amount in sterling' as Header, '1' as sortby

UNION
SELECT
cast(isnull(DimCust.CustRefNumber, '') AS VARCHAR)+'|'+
cast(isnull(cast(FactSavTrans.BalanceAmt as decimal(10,2)), 0) AS VARCHAR)+'|'+
cast(isnull(CASE WHEN cast(FactSavTrans.BalanceAmt as decimal(10,2))<='85000' THEN cast(FactSavTrans.BalanceAmt as decimal(10,2))ELSE '85000' END , 0) AS VARCHAR) as Header , '2' as sortby2
FROM xyz_DWH.DimCustomer DimCust LEFT JOIN xyz_DWH.FactSavingsTrans FactSavTrans ON
DimCust.CustomerKey=FactSavTrans.CustomerKey INNER JOIN xyz_DWH.DimAccount DimAcct ON
DimAcct.AccountKey=FactSavTrans.AccountKey
WHERE (FactSavTrans.CustomerKey,FactSavTrans.transdatetime) IN(SELECT CustomerKey,MAX(transdatetime)
FROM xyz_DWH.FactSavingsTrans GROUP BY CustomerKey)

UNION
SELECT '99999999999999999999' AS Header , '3' as sortby
order by sortby asc
;

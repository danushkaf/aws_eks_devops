create or replace view REDSHIFT_SCHEMA_NAME.vw_Deposits_Report2_Profile as
with cte as 
(SELECT distinct   
 DPROD.NAME,
 DPROD.ProductID,
 DPROD.NAME||'('||DPROD.ProductID||')' AS Product_name_Product_ID,
DACC.AgencyAccountNbr AS Account_No,
DACC.CreatedOnDate AS Account_Opened,
MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=0 THEN FACTSAV.BalanceAmt ELSE 0 END) AS Day1,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=1 THEN FACTSAV.BalanceAmt  END),Day1) AS Day2,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=2 THEN FACTSAV.BalanceAmt  END),Day2) AS Day3,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=3 THEN FACTSAV.BalanceAmt  END),Day3) AS Day4,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=4 THEN FACTSAV.BalanceAmt  END),Day4) AS Day5,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=5 THEN FACTSAV.BalanceAmt  END),Day5) AS Day6,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=6 THEN FACTSAV.BalanceAmt  END),Day6) AS Day7,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=7 THEN FACTSAV.BalanceAmt  END),Day7) AS Day8,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=8 THEN FACTSAV.BalanceAmt  END),Day8) AS Day9,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=9 THEN FACTSAV.BalanceAmt  END),Day9) AS Day10,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=10 THEN FACTSAV.BalanceAmt  END),Day10) AS Day11,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=11 THEN FACTSAV.BalanceAmt  END),Day11) AS Day12,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=12 THEN FACTSAV.BalanceAmt  END),Day12) AS Day13,
NVL(MAX(CASE WHEN DATE_DIFF('Day',CAST(DACC.CreatedOnDate AS DATE),CAST(FACTSAV.transdatetime AS DATE))=13 THEN FACTSAV.BalanceAmt  END),Day13) AS Day14
FROM xyz_DWH.DimAccount DACC 
LEFT JOIN xyz_DWH.FactSavingsTrans FACTSAV ON
DACC.AccountKey=FACTSAV.AccountKey 
LEFT JOIN xyz_DWH.vw_FactApplication FACTAPP
ON DACC.APPLICATIONID=FACTAPP.applicationid 
INNER JOIN xyz_DWH.vw_DimProduct DPROD 
ON DPROD.Productkey = FACTAPP.productkey
WHERE (FactApp.APPLICATIONID,FactApp.UPDATEDATE) IN(select applicationid,max(updatedate) from xyz_DWH.vw_FactApplication group by applicationid)AND (FACTSAV.ACCOUNTKEY,CAST(FACTSAV.transdatetime AS DATE),FACTSAV.transdatetime) IN(SELECT ACCOUNTKEY,CAST(transdatetime AS DATE),MAX(transdatetime) FROM xyz_DWH.FactSavingsTrans GROUP BY ACCOUNTKEY,CAST(transdatetime AS DATE))
GROUP BY DPROD.NAME,DPROD.ProductID,DACC.AgencyAccountNbr,DACC.CreatedOnDate)
 
SELECT  distinct NAME,
 ProductID,
Account_No,
Account_Opened,
day1, 
day2 ,
day3,
day4, 
day5, 
day6,
day7,
day8,
day9,
day10,
day11,
day12,
day13,
day14,
day14 as day14_1
from cte 
;
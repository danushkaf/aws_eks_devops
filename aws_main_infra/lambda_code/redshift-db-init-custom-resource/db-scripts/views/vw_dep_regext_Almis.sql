/*
script:          ALMIS_view_query.sql
purpose:         This script will create view containing columns required in ALMIS report.
copy of script:  Newly created
created by:      PSL
Change History:   
*/
set search_path=REDSHIFT_SCHEMA_NAME;
/* 
This view derives following columns from datawarehouse tables.
latest record from FactAcctBalSSDaily 
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_FactAcctBalSSDaily
as
select * from (
  select *,
rank() over(partition by accountkey order by recordeddate desc) as rn
from REDSHIFT_SCHEMA_NAME.FactAcctBalSSDaily 
)where rn=1;
/*
This view derives following columns from datawarehouse tables.
accountkey,recordeddate,AccountingBalance, InterestBalance,UnusedAmount,ProductCode,
APR,EIR,Category,MaturityDays,RepricingDays,AccountReference,RemainingCoolingOffPeriod,
CoolingOff,EndOfCoolingPeriod,OpeningDate,maxdepositamt
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_attr
as
select a.accountkey,d.interestrate as InterestRate,d.interestrate as APR,
d.interestrate as EIR,a.createdondate as OpeningDate,e.maxdepositamt as maxdepositamt,
b.BalanceAmount+c.InterestAccruedAmt as AccountingBalance,
b.BalanceAmount as InterestBalance,
case when current_date<=d.fundingclosedate then 
                                           case when e.maxdepositamt-b.BalanceAmount>0  
                                           then e.maxdepositamt- InterestBalance else 0 end
      else 0  end as UnusedAmount,
e.ProductID ProductCode,
date_diff('day',current_date,d.maturitydate) as MaturityDays,
case when current_date > d.MaturityDate then 'Instant Access Retail Deposits' 
     else 'Fixed Retail Deposits' end as Category,
case when d.maturitydate is null then 1
     when d.maturitydate <= current_date then 1
     else date_diff('day',current_date,d.maturitydate::timestamp) end as RepricingDays,
d.cbsaccountnbr as AccountReference,
d.fundingclosedate as EndOfCoolingPeriod,
case when d.fundingclosedate > current_date then d.fundingclosedate-current_date 
     else 0  end as RemainingCoolingOffPeriod,
case when current_date<=d.maturitydate then ''
     else case when RemainingCoolingOffPeriod >0 then 'CO'
               else '' end end as CoolingOff
from REDSHIFT_SCHEMA_NAME.dimaccount a
inner join
REDSHIFT_SCHEMA_NAME.vw_FactAcctBalSSDaily b
on a.accountkey=b.accountkey
inner join
REDSHIFT_SCHEMA_NAME.factaccountinterest c
on a.accountkey=c.accountkey
inner join 
REDSHIFT_SCHEMA_NAME.dimsavingaccount d
on a.savingacctkey=d.savingaccountkey
inner join
REDSHIFT_SCHEMA_NAME.dimproduct e
on b.productkey=e.productkey
where upper(a.status)<>'CLOSED';

/*
This view derives following columns from datawarehouse tables.
accountkey,GuaranteedBalance,customerkey,csum
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_guarbal
as
select a.accountkey,b.customerkey,
sum(a.balanceamount) over
(partition by b.customerkey order by a.accountkey rows unbounded preceding ) csum,
a.balanceamount -(case when csum>c.attributevalue then csum-c.attributevalue else 0 end) as GuaranteedBalance
from  REDSHIFT_SCHEMA_NAME.vw_FactAcctBalSSDaily a 
inner join
REDSHIFT_SCHEMA_NAME.customer_x_account b
on a.accountkey=b.accountkey
cross join
(select attributevalue from REDSHIFT_SCHEMA_NAME.configurationmaster where attributecode='GuaranteedBalanceLimit') c;


/*
This view derives following columns from datawarehouse tables.
accountkey,customerkey,CustomerEstablished,customer
*/

create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_status
as
select distinct a.accountkey,b.customerkey,c.custrefnumber Customer,
count(case when upper(a.accounttype)='LOAN' then 1 end )over(partition by b.customerkey)as cnt_loan,
count(d.productkey) over (partition by b.customerkey) as cnt_products,
case when cnt_loan>=1 or cnt_products >1 or date_diff('day',c.createddate,current_date)>365 
then 'EST' else 'NEST' end as CustomerEstablished
from REDSHIFT_SCHEMA_NAME.dimaccount a
inner join
REDSHIFT_SCHEMA_NAME.customer_x_account b
on a.accountkey=b.accountkey
inner join
REDSHIFT_SCHEMA_NAME.dimcustomer c
on b.customerkey=c.customerkey
inner join 
REDSHIFT_SCHEMA_NAME.vw_FactAcctBalSSDaily d
on a.accountkey=d.accountkey
where upper(a.status)<>'CLOSED';

/*
This view derives following columns from datawarehouse tables.
CustomerResidence
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_res
as
select distinct a.accountkey,a.customerkey,
case when c.country='UK' then 'RES' else 'NRES' end as CustomerResidence
from REDSHIFT_SCHEMA_NAME.customer_x_account a
left outer join
REDSHIFT_SCHEMA_NAME.custaddrdetails b
on a.customerkey=b.customerkey
left outer join
REDSHIFT_SCHEMA_NAME.dimgeography c
on b.geographykey=c.geographykey;

/*
This view derives following columns from datawarehouse tables.
VHighBalance
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_vhbal
as
select distinct a.accountkey,a.customerkey,
sum(b.balanceamount) over (partition by a.customerkey) as total_customer_bal,
case when total_customer_bal > c.attributevalue then 'VHB' else 'NVHB' end as VHighBalance
from REDSHIFT_SCHEMA_NAME.customer_x_account a 
inner join
REDSHIFT_SCHEMA_NAME.vw_factacctbalssdaily b
on a.accountkey=b.accountkey
cross join
(select attributevalue from REDSHIFT_SCHEMA_NAME.configurationmaster where attributecode='VHighBalanceLimit')c;

/*
This view derives following columns from datawarehouse tables.
Latest record from factsavingstrans based on transdatetime,fund received
*/

create or replace view REDSHIFT_SCHEMA_NAME.vw_factsavingstrans
as
select * from (
select *,
rank() over(partition by accountkey order by transdatetime desc )as rn,
max(case when upper(type)='DEPOSIT' then transdatetime else NULL end) over(partition by accountkey) as FundsReceived
from REDSHIFT_SCHEMA_NAME.factsavingstrans) where rn=1;

/*
This view derives following columns from datawarehouse tables.
UnderFundedBal,UnderOverFunded,ExcessFundingBal,FundsReceived
*/

create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_fundlim
as
select distinct a.accountkey,
case when c.mindepositamt > a.balanceamt then c.mindepositamt-a.balanceamt 
     else 0 end as UnderFundedBal,
case when a.balanceamt - c.maxdepositamt>0 then 'OF'
     when a.balanceamt- c.mindepositamt<0 then 'UF' 
     else '' end as UnderOverFunded,
case when a.balanceamt>c.maxdepositamt then a.balanceamt-c.maxdepositamt 
     else 0 end as ExcessFundingBal,
 a.FundsReceived
from REDSHIFT_SCHEMA_NAME.vw_factsavingstrans a
inner join
REDSHIFT_SCHEMA_NAME.vw_factacctbalssdaily b
on a.accountkey=b.accountkey
inner join
REDSHIFT_SCHEMA_NAME.dimproduct c
on b.productkey=c.productkey;

/*
This view derives following columns from datawarehouse tables.
PaymentDate,PaymentFrequency
*/
create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_pymnt
as
select accountkey,
interestpaymentdate1 as PaymentDate,
case when cnt_interestpaymentdate=1 then 'A'
     else case when date_diff('day',interestpaymentdate1,interestpaymentdate2)in(28,29,30,31)                  then 'M'
               when date_diff('month',interestpaymentdate1,interestpaymentdate2)=3 then 'Q'
               when date_diff('month',interestpaymentdate1,interestpaymentdate2)=6 then 'S'
               end end as PaymentFrequency
from(
select a.accountkey,b.interestpaymentdate interestpaymentdate1,
rank() over(partition by a.accountkey order by b.interestpaymentdate) as rn,
lead(b.interestpaymentdate) over(partition by a.accountkey order by b.interestpaymentdate)
as interestpaymentdate2,
count(b.interestpaymentdate) over(partition by a.accountkey) as cnt_interestpaymentdate         from REDSHIFT_SCHEMA_NAME.dimaccount a
inner join 
REDSHIFT_SCHEMA_NAME.acctinterestschedule b
on a.savingacctkey=b.savingaccountkey and b.interestpaymentdate > current_date
where upper(a.status)<>'CLOSED'
)where rn=1;


/*
This is master view containing all the column required in ALMIS report, which is derived by joining aal the above views.
*/

create or replace view REDSHIFT_SCHEMA_NAME.vw_dep_regext_almis
as
select 
case when f.ExcessFundingBal >0 then f.ExcessFundingBal
     else a.AccountingBalance end as AccountingBalance,
a.AccountReference,
a.Category,
c.Customer,
'GBP' as Currency,
case when f.ExcessFundingBal >0 then f.ExcessFundingBal
     else b.GuaranteedBalance end as GuaranteedBalance,
case when f.ExcessFundingBal >0 then f.ExcessFundingBal
     else a.InterestBalance end as InterestBalance,
'Y' as InterestPaymentMethod,
a.InterestRate,
g.PaymentFrequency,
a.ProductCode,
case when f.ExcessFundingBal >0 then 1
     else a.RepricingDays end as RepricingDays,
c.CustomerEstablished || d.CustomerResidence || e.VHighBalance as ALMISDepositCustomerType,
a.APR,
f.FundsReceived,
f.ExcessFundingBal,
f.UnderFundedBal,
f.UnderOverFunded,
a.CoolingOff,
a.EIR,
a.EndOfCoolingPeriod,
case when f.ExcessFundingBal >0 then 1
     else a.MaturityDays end as MaturityDays,
a.OpeningDate,
g.PaymentDate,
date_diff('day',current_date,g.PaymentDate) as PaymentDays,
a.RemainingCoolingOffPeriod,
a.UnusedAmount,
c.CustomerEstablished,
d.CustomerResidence,
e.VHighBalance
from REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_attr a
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_guarbal b
on a.accountkey=b.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_status c
on a.accountkey=c.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_res d
on a.accountkey=d.accountkey
inner join 
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_vhbal e
on a.accountkey=e.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_fundlim f
on a.accountkey=f.accountkey
left outer join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_pymnt g
on a.accountkey=g.accountkey
union all
select 
a.maxdepositamt as AccountingBalance,
a.AccountReference,
a.Category,
c.Customer,
'GBP' as Currency,
a.maxdepositamt as GuaranteedBalance,
a.maxdepositamt as InterestBalance,
'Y' as InterestPaymentMethod,
a.InterestRate,
g.PaymentFrequency,
a.ProductCode,
a.RepricingDays,
c.CustomerEstablished || d.CustomerResidence || e.VHighBalance as ALMISDepositCustomerType,
a.APR,
f.FundsReceived,
0 as ExcessFundingBal,
f.UnderFundedBal,
f.UnderOverFunded,
a.CoolingOff,
a.EIR,
a.EndOfCoolingPeriod,
a.MaturityDays,
a.OpeningDate,
g.PaymentDate,
date_diff('day',current_date,g.PaymentDate) as PaymentDays,
a.RemainingCoolingOffPeriod,
a.UnusedAmount,
c.CustomerEstablished,
d.CustomerResidence,
e.VHighBalance
from REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_attr a
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_guarbal b
on a.accountkey=b.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_status c
on a.accountkey=c.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_res d
on a.accountkey=d.accountkey
inner join 
REDSHIFT_SCHEMA_NAME.vw_dep_regext_cust_vhbal e
on a.accountkey=e.accountkey
inner join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_fundlim f
on a.accountkey=f.accountkey
left outer join
REDSHIFT_SCHEMA_NAME.vw_dep_regext_acct_pymnt g
on a.accountkey=g.accountkey
where f.ExcessFundingBal>0;





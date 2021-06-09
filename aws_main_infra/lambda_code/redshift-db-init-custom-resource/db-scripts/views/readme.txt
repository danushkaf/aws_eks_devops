DWH Views to cater to Reports and data-extracts.

DEPOSITS

-->Report 1
vw_deposits_report1.sql

-->Report 2
vw_Deposits_Report2.sql
vw_Deposits_Report2_Profile.sql

-->Report 3
vw_deposits_report3.sql

-->Report 5
vw_deposits_report5.sql

-->Report 7
vw_deposits_report7.sql


FSCS

--> FSCS 1
vw_fscs_customer_details.sql

--> FSCS 2
vw_fscs_contact_details.sql
This view is dependent on procedure - prc_addresslines_dwh.sql which handles the continuous address lines
even if some address line is blank in-between till Postcode

--> FSCS 3
vw_fscs_details_of_accounts.sql

--> FSCS 4
vw_fscs_aggregate_balance.sql

Below 2 views are used to cater to the Productid aliasing to Productkey. PostF&F, alias need to be changed based on the population logic. Reports are now using below two views instead of base table
-----vw_DimProduct.sql 
-----vw_Factapplication.sql 

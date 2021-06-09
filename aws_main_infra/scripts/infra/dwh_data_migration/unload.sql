unload ('select * from xyz_dwh.acctinterestschedule')
to 's3://dev-redshift-mig/xyz_dwh/acctinterestschedule/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.addresslines_fscs')
to 's3://dev-redshift-mig/xyz_dwh/addresslines_fscs/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.configurationmaster')
to 's3://dev-redshift-mig/xyz_dwh/configurationmaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.countrymaster')
to 's3://dev-redshift-mig/xyz_dwh/countrymaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.custaddrdetails')
to 's3://dev-redshift-mig/xyz_dwh/custaddrdetails/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.custcitizenship')
to 's3://dev-redshift-mig/xyz_dwh/custcitizenship/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.customer_x_account')
to 's3://dev-redshift-mig/xyz_dwh/customer_x_account/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.customeraddresshistory')
to 's3://dev-redshift-mig/xyz_dwh/customeraddresshistory/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.customerdetailshistory')
to 's3://dev-redshift-mig/xyz_dwh/customerdetailshistory/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.custtaxresidency')
to 's3://dev-redshift-mig/xyz_dwh/custtaxresidency/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimaccount')
to 's3://dev-redshift-mig/xyz_dwh/dimaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimcurrency')
to 's3://dev-redshift-mig/xyz_dwh/dimcurrency/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimcustomer')
to 's3://dev-redshift-mig/xyz_dwh/dimcustomer/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimdate')
to 's3://dev-redshift-mig/xyz_dwh/dimdate/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimgeography')
to 's3://dev-redshift-mig/xyz_dwh/dimgeography/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimglaccount')
to 's3://dev-redshift-mig/xyz_dwh/dimglaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimnominatedaccount')
to 's3://dev-redshift-mig/xyz_dwh/dimnominatedaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimproduct')
to 's3://dev-redshift-mig/xyz_dwh/dimproduct/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.dimsavingaccount')
to 's3://dev-redshift-mig/xyz_dwh/dimsavingaccount/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factaccountinterest')
to 's3://dev-redshift-mig/xyz_dwh/factaccountinterest/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factacctbalssdaily')
to 's3://dev-redshift-mig/xyz_dwh/factacctbalssdaily/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factapplication')
to 's3://dev-redshift-mig/xyz_dwh/factapplication/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factfees')
to 's3://dev-redshift-mig/xyz_dwh/factfees/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factgljournal')
to 's3://dev-redshift-mig/xyz_dwh/factgljournal/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factnotificationevent')
to 's3://dev-redshift-mig/xyz_dwh/factnotificationevent/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.factsavingstrans')
to 's3://dev-redshift-mig/xyz_dwh/factsavingstrans/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_dwh.nationalitymaster')
to 's3://dev-redshift-mig/xyz_dwh/nationalitymaster/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_stg.stg_extract_log') 
to 's3://dev-redshift-mig/xyz_dwh_stg/stg_extract_log/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_stg.stg_source_tracking')
to 's3://dev-redshift-mig/xyz_dwh_stg/stg_source_tracking/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;
unload ('select * from xyz_stg.stg_unit_test_result')
to 's3://dev-redshift-mig/xyz_dwh_stg/stg_unit_test_result/'
iam_role 'arn:aws:iam::111111111111:role/dev-development-datalake-infr-RedshiftSpectrumRole-1EUNM5WVQHV31'
allowoverwrite
format as csv;

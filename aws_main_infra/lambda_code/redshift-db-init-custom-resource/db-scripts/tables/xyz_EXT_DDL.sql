/*
script: 		xyz_EXT_DDL.sql
purpose: 		This script will create external schema for reading spectrum data tables.
				iam role need to change as per dev/qa/uat/prod environment.
date created: 	22-Jan-2021
copy of script: Newly created
created by: 	PSL
Change History:
*/
drop schema if exists ext_spectrum;
create external schema ext_spectrum
from data catalog
database 'DATABASE_NAME'
iam_role 'SPRECTRUM_ROLE_ARN'
create external database if not exists;

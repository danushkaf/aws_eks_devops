/*
script: 		xyz_STG_DDL.sql
purpose: 		This script will create tables and constraints in stg schema.
date created: 	22-Jan-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/

set search_path=xyz_stg;

create table if not exists stg_unit_test_result
(
	loadtype VARCHAR(50)   
	,tablename VARCHAR(100)   
	,cnt BIGINT  
	,ext_dwh VARCHAR(50)
)
diststyle even;

CREATE TABLE IF NOT EXISTS stg_source_tracking
(
	sourcetable VARCHAR(28)
	,extractedon VARCHAR(16383)
)
DISTSTYLE EVEN;

create table stg_extract_log (extracttype varchar(50), extractfilename varchar(100), createdondate timestamp, accountsreported integer, status varchar(100)) DISTSTYLE EVEN;

create or replace view vw_xyz_stored_proc_call as select * from svl_stored_proc_call order by starttime desc; 

create or replace view vw_xyz_stored_proc_messages as select * from svl_stored_proc_messages order by recordtime desc;

create or replace view vw_xyz_query_log as select * from SVL_QLOG order by starttime desc;

create or replace view vw_xyz_procedure_info as select * from PG_PROC_INFO;

create or replace view vw_xyz_sessions as select * from stv_recents where status<>'Done';

create or replace view vw_xyz_unit_test_result as select tablename, case when count(*) =1 then 'Pass' else 'Fail' end TestResult from (select tablename, cnt from xyz_stg.stg_unit_test_result group by 1,2) group by tablename;

set search_path=REDSHIFT_SCHEMA_NAME;

create or replace VIEW vw_last_etl_Date
AS
WITH etlDate
AS
(SELECT replace(replace(replace(lower(querytxt),'call',''),'xyz_stg.',''),'()','') loadproc,
       MAX(endtime)::timestamp maxdate
FROM xyz_stg.vw_xyz_stored_proc_call
WHERE aborted = 0
GROUP BY 1
ORDER BY 2 DESC) 
SELECT Max(to_char(maxdate,'dd-mm-yyyy hh:mi:ss')) FROM etlDate WHERE trim(loadproc) ='prc_load_dwh';


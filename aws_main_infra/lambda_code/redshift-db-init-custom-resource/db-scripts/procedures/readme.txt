Procedures list


1. prc_addresslines_dwh.sql
prc_addresslines_dwh.sql handles the continuous address lines even if some address line is blank in-between till Postcode
This procedure Truncates and loads the table - REDSHIFT_SCHEMA_NAME.addresslines_fscs - which is used for final reporting view - vw_fscs_contact_details.sql
call REDSHIFT_SCHEMA_NAME.prc_addresslines();

2. 
### Creating AWS Infrastructure
* This code is created for control tower based infrastructure. So first control tower needs to be configured. That will need two email addresses for Log Archive Account and Audit Account created by Control Tower.
* This code expects a structure similar to below. Even though it doesn't depend on OU structure, it depends on existence of a shared account. So get an email address for Shared Account and create an account through Account Factory in Control Tower service. And note down the account id of shared account for the next step.
![Common AWS Account Structure](account_structure.png?raw=true)
* Then create a stack set in *MASTER ACCOUNT* using the base template (`aws_main_infra/cf_templates/stacker/templates/base/custom-base-stackset.yaml`). These are the information needed when you create the stack set. Note that stack set name should match for other automations. Description could differ but make sure its something makes sense.
     * Stack Set Name : Custom-ComtrolTower-Baseline-Stack
     * Stack Set Description : "Custom Base stack set for all accounts"
     * Parameters:
         * Master Account ID : Account ID of the Master Account.
         * Shared Account ID : Shared Account ID from the previous step.
     * Permission Model: Self-service permissions
         * IAM Admin Role Name: AWSControlTowerStackSetRole
         * IAM Execution Role Name: AWSControlTowerExecution
     * Deployment Options:
         * Deployment Locations Option : Deploy stacks in accounts
         * Account numbers: Shared Account ID
         * Regions: Main Deployment Region
* Then need to create a stack in *MASTER_ACCOUNT* to handle control tower account creation. So run the event template (`aws_main_infra/cf_templates/stacker/templates/base/create-account-event-cfn.yaml`).
* Then cicd infrastructure should be created in *SHARED ACCOUNT* using the cicd infra template (`aws_main_infra/cf_templates/stacker/templates/main-templates/cicd-infra.yaml`). Install and configure Jenkins and SonarQube components.
* Then for the application infrastructure deployment Jenkins is used and `aws_main_infra/InfraJenkinsfile` pipeline is created and configuring it for pipeline properly per deployment will create the infrastructure for deployment. This pipeline expects parameters as follows.
     * Choice Parameter
         * Name : Option
         * Values : Create, Delete
     * String Parameter
         * Name : Environment_Name
         * Description : This should be same as the .env file created for stacker within the folder `aws_main_infra/cf_templates/stacker/conf`
     * String Parameter
         * Name : DB_Username
         * Description : Username for RDS
     * Password Parameter
         * Name : DB_Password
         * Description : Password for RDS
     * String Parameter
         * Name : MambuUsername
         * Description : Username for Mambu
     * Password Parameter
         * Name : MambuPassword
         * Description : Password for Mambu
     * String Parameter
         * Name : OS_DB_Username
         * Description : Username for OS Database
     * Password Parameter
         * Name : OS_DB_Password
         * Description : Password for OS Database
     * String Parameter
         * Name : OS_Admin_DB_Username
         * Description : Username for OS Database Admin User
     * Password Parameter
         * Name : OS_Admin_DB_Password
         * Description : Password for OS Database Admin User
     * String Parameter
         * Name : OS_Runtime_Admin_DB_Username
         * Description : Username for OS Database Runtime Admin User
     * Password Parameter
         * Name : OS_Runtime_Admin_DB_Password
         * Description : Password for OS Database Runtime Admin User
     * String Parameter
         * Name : OS_Runtime_Log_Admin_DB_Username
         * Description : Username for OS Database Runtime Log Admin User
     * Password Parameter
         * Name : OS_Runtime_Log_Admin_DB_Password
         * Description : Password for OS Database Runtime Log Admin User
     * String Parameter
         * Name : OS_Session_DB_Admin_Username
         * Description : Username for OS Database Session Admin User
     * Password Parameter
         * Name : OS_Session_DB_Admin_Password
         * Description : Password for OS Database Session Admin User
     * Password Parameter
         * Name : OS_Platform_Admin_Password
         * Description : Password for OS Platform Admin User
     * Password Parameter
         * Name : OS_Service_Password
         * Description : Password for OS Service Admin User
     * String Parameter
         * Name : DataLake_Redshift_Username
         * Description : Username for datalake Redshift DB
     * Password Parameter
         * Name : DataLake_Redshift_Password
         * Description : Password for for datalake Redshift DB
     * Password Parameter
         * Name : TruNarative_Credential
         * Description : Credentials for TruNarrative Connection
     * Password Parameter
         * Name : ClearBank_Credential
         * Description : Credentials for ClearBank Connection
     * Password Parameter
         * Name : ClearBank_Account
         * Description : ClearBank Account Details
     * Password Parameter
         * Name : ClearBank_PublicKey
         * Description : PublicKey for ClearBank
     * Password Parameter
         * Name : Almis_SFTP_SSH_Key
         * Description : SFTP Public SSH Key for Almis User
     * Password Parameter
         * Name : Access_SFTP_SSH_Key
         * Description : SFTP Public SSH Key for Access User
     * String Parameter
         * Name : ETL_Mambu_Username
         * Description : ETL Mambu Username
     * Password Parameter
         * Name : ETL_Mambu_Password
         * Description : ETL Mambu Password
     * String Parameter
         * Name : OS_ETL_Admin_DB_Username
         * Description : OS DB Admin username for ETL
     * Password Parameter
         * Name : OS_ETL_Admin_DB_Password
         * Description : OS DB Admin password for ETL
     * String Parameter
         * Name : OS_ETL_RO_DB_Username
         * Description : OS DB Read Only username for ETL
     * Password Parameter
         * Name : OS_ETL_RO_DB_Password
         * Description : OS DB Read Only password for ETL
     * String Parameter
         * Name : OS_Lifetime_Admin_DB_Username
         * Description : Username for OS Lifetime Database Admin User. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Admin_DB_Password
         * Description : Username for OS Lifetime Database Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * String Parameter
         * Name : OS_Lifetime_Runtime_Admin_DB_Username
         * Description : Username for OS Lifetime Database Runtime Admin User. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Runtime_Admin_DB_Password
         * Description : Username for OS Lifetime Database Runtime Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * String Parameter
         * Name : OS_Lifetime_Runtime_Log_Admin_DB_Username
         * Description : Username for OS Lifetime Database Runtime Log Admin User. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Runtime_Log_Admin_DB_Password
         * Description : Username for OS Lifetime Database Runtime Log Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * String Parameter
         * Name : OS_Lifetime_Session_DB_Admin_Username
         * Description : Username for OS Lifetime Database Session Admin User. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Session_DB_Admin_Password
         * Description : Username for OS Lifetime Database Session Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Platform_Admin_Password
         * Description : Username for OS Lifetime Platform Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
     * Password Parameter
         * Name : OS_Lifetime_Service_Password
         * Description : Username for OS Lifetime Service Admin User Password. Applicable only for Prod. For other envs put a dummy value like "xxxxxxxxxxxxxxxxxxxxx".
* For Shared Account Infrastructure setup use the `aws_main_infra/SharedAccountJenkinsfile` pipeline with following parameters.
     * Choice Parameter
         * Name : Option
         * Values : Create, Delete
* AMG (AWS Managed Grafana) configuration is manual as for now. In Grafana
    * Configure Datasource of AMP
    * Add users/groups accordingly
    * Configure aws datasource in Grafana
    * Import dashboards 3119, 6417

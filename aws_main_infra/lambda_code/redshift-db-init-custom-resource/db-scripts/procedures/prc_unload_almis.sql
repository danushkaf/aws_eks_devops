 CREATE OR REPLACE PROCEDURE xyz_stg.prc_unload_almis(pObjectName varchar,pS3Path varchar,pFileName varchar)
    LANGUAGE plpgsql AS
    $$
    DECLARE
       lday varchar(2);
	   lmonth varchar(2);
	   lyear varchar(4);
	   lquery varchar(500);
       ldelimiter varchar(100);
       lunloadscript varchar(500);
       ls3path varchar(500);
       liamrole varchar(500);

    BEGIN
       select to_char(GETDATE(),'DD') into lday;
	   select to_char(GETDATE(),'MM') into lmonth;
       select to_char(GETDATE(),'yyyy') into lyear;
	   select 'SPRECTRUM_ROLE_ARN'  into liamrole;

       lquery:='select * from REDSHIFT_SCHEMA_NAME.'||pObjectName;
       ls3path:=replace(pS3Path,'{env}',split_part(current_database(),'-',1))||lday||lmonth||lyear||pFileName;
       ldelimiter:='CSV MAXFILESIZE 6.2 GB PARALLEL OFF HEADER';
       lunloadscript := 'unload ('''||lquery||''') to '''||ls3path||''' iam_role '''||liamrole||''' ALLOWOVERWRITE '||ldelimiter||'';

       execute lunloadscript;

    EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'error message SQLERRM %', SQLERRM;
	RAISE WARNING 'error message SQLSTATE %', SQLSTATE;
    END
    $$;

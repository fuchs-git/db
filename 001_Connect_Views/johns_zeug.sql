SELECT rolname, rolinherit, rolsuper, rolcanlogin, rolpassword
from pg_authid
WHERE rolname not LIKE 'pg_%';


SELECT *
FROM pg_catalog.pg_namespace
         INNER JOIN pg_authid ON pg_namespace.nspowner = pg_authid.oid;

SELECT *
from pg_authid;

CREATE SCHEMA johns_schema authorization john;

-- In welchem Schema soll es suchen?
SHOW SEARCH_PATH;
SET SEARCH_PATH to johns_schema;

SELECT version();
SELECT current_database();

-- welche Rollen gibt es?
SELECT * from information_schema.administrable_role_authorizations;

SELECT rolname FROM pg_roles WHERE rolname NOT ILIKE 'pg_%'; -- ILIKE ignoriert groß/kleinschreibung

CREATE ROLE john WITH PASSWORD 'Oberstufe' LOGIN;
SELECT rolname, rolpassword FROM pg_roles where rolname not like 'pg_%';


SELECT rolname, rolinherit, rolsuper, rolcreatedb, rolcanlogin, rolpassword from pg_authid WHERE rolname not LIKE 'pg_%';

SELECT * from pg_authid;


SELECT nspname as schema, rolname as besitzer FROM pg_catalog.pg_namespace INNER JOIN pg_authid ON pg_namespace.nspowner = pg_authid.oid;

CREATE SCHEMA dinge;
create TABLE in_dinge(dings_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY , dings_inhalt text);

CREATE DATABASE db_privileges;

drop TABLE in_dinge;
DROP SCHEMA dinge;



--
CREATE SCHEMA johns_schema AUTHORIZATION john;



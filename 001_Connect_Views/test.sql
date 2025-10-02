SELECT version();
SELECT current_database();

-- welche Rollen gibt es?
SELECT * from information_schema.administrable_role_authorizations;

SELECT rolname FROM pg_roles WHERE rolname NOT ILIKE 'pg_%'; -- ILIKE ignoriert groß/kleinschreibung

CREATE ROLE john WITH PASSWORD 'Oberstufe' LOGIN;
SELECT rolname, rolpassword FROM pg_roles where rolname not like 'pg_%';


SELECT rolname, rolinherit, rolsuper, rolcreatedb, rolcanlogin, rolpassword from pg_authid WHERE rolname not LIKE 'pg_%';
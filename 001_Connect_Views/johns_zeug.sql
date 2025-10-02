
SELECT rolname, rolinherit, rolsuper, rolcanlogin, rolpassword from pg_authid WHERE rolname not LIKE 'pg_%';
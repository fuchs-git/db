select rolname from pg_roles where rolname not like 'pg_%';
select * from pg_roles;
drop schema if exists johns_schema;
drop role john;
create role john login password 'P@ssw0rd!';


show search_path ;

grant SELECT, delete on test to john;
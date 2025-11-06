select current_database();


CREATE VIEW say_hello as
    select 'Hello World' as hello;

select * from say_hello;
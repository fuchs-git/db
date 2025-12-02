select current_database();


CREATE VIEW say_hello as
select 'Hello World' as hello;

select *
from say_hello;

select kunde.kunde_id, kunde.name,
       concat(adresse.hausnummer, ' ', adresse.strasse,' ', adresse.plz,' ', adresse.ort) as Adresse
from kunde
    left join adresse on kunde.fk_rechnungsadresse = adresse.adresse_id;
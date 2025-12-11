-- CREATE DATABASE db_wache;

SELECT CURRENT_DATABASE(); --Statement zum Verbindungsaufbau

CREATE TABLE wache (
    id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum  DATE,
    person TEXT -- das ist natürlich nicht schlau, aber es ist anschaulich
);

-- ein paar Daten über 2 Monate
INSERT INTO wache(datum, person)
VALUES ('01.10.2025', 'Pimpelhuber'),
       ('05.10.2025', 'Pimpelhuber'),
       ('05.10.2025', 'Dosenbier'),
       ('05.10.2025', 'Hülsensack'),
       ('10.10.2025', 'Pimpelhuber'),
       ('12.10.2025', 'Pimpelhuber'),

       ('06.11.2025', 'Pimpelhuber'),
       ('06.11.2025', 'Dosenbier'),
       ('11.11.2025', 'Pimpelhuber'),
       ('14.11.2025', 'Pimpelhuber')
;


SELECT datum, person
FROM wache;

SELECT person, COUNT(:)
FROM wache
GROUP BY person;


SELECT person, EXTRACT(MONTH FROM datum) AS monat, COUNT(*) AS anzahl
FROM wache
GROUP BY monat, person
ORDER BY monat, anzahl DESC;


SELECT person, COUNT(*) AS anzahl
FROM wache
GROUP BY person
ORDER BY anzahl
LIMIT 2;


SELECT person, COUNT(*) AS anzahl
FROM wache
GROUP BY person
HAVING COUNT(*) > 5;


SELECT person, anzahl
FROM (SELECT person, COUNT(*) AS anzahl FROM wache GROUP BY person)
WHERE anzahl > 5;

select person, anzahl from (SELECT person, COUNT(*) AS anzahl FROM wache GROUP BY person) as t WHERE anzahl > 5;

CREATE ROLE Nutzergruppe NOLOGIN

GRANT select, update(person) ON wache TO John;

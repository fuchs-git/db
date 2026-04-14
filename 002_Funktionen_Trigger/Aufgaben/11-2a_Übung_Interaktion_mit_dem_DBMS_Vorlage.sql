-- 11-2a Übung Interaktion mit dem DBMS

-- mit der postgres-Datenbank
-- DROP DATABASE IF EXISTS db_personalverwaltung;
-- CREATE DATABASE db_personalverwaltung;

--mit einer neuen Datenbankverbindung zur db_personalverwaltung
SELECT current_database();
-- erwartete Antwort: db_personalverwaltung

-- Tabellen löschen
--DROP TABLE IF EXISTS skill, person, person_hat_skill CASCADE;

-- Tabellen leeren
--TRUNCATE TABLE person_hat_skill, skill, person RESTART IDENTITY CASCADE ;

CREATE TABLE person (
    person_id    INTEGER GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,
    name         text NOT NULL,
    rufname      text NOT NULL,
    geburtsdatum DATE NOT NULL,
    geburtsort   text NOT NULL
);

CREATE TABLE skill (
    skill_id          INTEGER GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,
    skill_bezeichnung text NOT NULL
        UNIQUE
);

CREATE TABLE person_hat_skill (
    fk_person_id INTEGER
        REFERENCES person (person_id) ON UPDATE CASCADE ON DELETE CASCADE,
    fk_skill_id  INTEGER
        REFERENCES skill (skill_id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (fk_person_id, fk_skill_id)
);

-- Personendaten zum Testen:
-- Nachname;Rufname;Geburtsdatum;Geburtsort;Fähigkeiten (IT)
-- Müller;Anna;15.03.1985;Berlin;Entwickler, Datenbankadministrator
-- Schmidt;Peter;22.09.1978;München;Systemadministrator, IT-Sicherheit
-- Schneider;Julia;01.12.1992;Hamburg;Entwickler, Projektmanager
-- Fischer;Michael;10.06.1965;Köln;Netzwerktechniker, Cloud-Experte
-- Weber;Sabine;28.04.2001;Frankfurt;Entwickler, UX-Designer

-- Aufgabe 1:


--Test-Aufruf
SELECT py_hole_skill_id_fuer('Entwickler');

SELECT *
FROM skill;


-- Aufgabe 2:

-- Testaufruf für Anna
SELECT py_person_einfuegen('Müller', 'Anna', '15.03.1985', 'Berlin');

--Testaufruf für ein kaputtes Datum
SELECT py_person_einfuegen('Müller', 'Anna', '35.03.1985', 'Berlin');


-- Aufgabe 3

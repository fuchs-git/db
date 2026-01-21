-- Ausgangslage: Der Kommandant der 'FGS Brandenburg' benötigt eine kompakte Liste seiner Mannschaft, aber nur
-- von Soldaten mit dem Dienstgrad 'Hauptgefreiter' . Zusätzlich soll diese Abfrage und der Zugriff darauf für die
-- Zukunft fest eingerichtet werden.
-- Aufgabe: Erstellen Sie eine VIEW. Nutzen Sie CONCAT (oder || ), um Dienstgrad und Name zusammenzufügen.
-- Filtern Sie mittels WHERE nach Schiff und Dienstgrad. Richten Sie anschließend die Security ein: Erstellen Sie ein
-- Schema, Rollen und Benutzer und vergeben Sie die Rechte mittels GRANT.
-- Erwartetes Ergebnis:
-- Soldat
-- HptGefr Schulz
-- HptGefr Becker
-- Einheit
-- FGS Brandenburg (2. Fregattengeschwader)
-- FGS Brandenburg (2. Fregattengeschwader)
create schema Schiffe;
create role r_fuehrung_vollzugriff;
create role r_fuehrung_lesen;
create role u_kommandant login password '1234_qwer!';
create role u_io login password '1234_qwer!';
create role u_wachmeister login password '1234_qwer!';

revoke all on schema Schiffe from public;
grant usage on schema Schiffe to r_fuehrung_vollzugriff, r_fuehrung_lesen;
grant all privileges on schema Schiffe to r_fuehrung_vollzugriff;
grant r_fuehrung_lesen to u_wachmeister;

create view v_besatzungliste_hg as
select concat(d.dg_kurz, ' ', soldat.name) "Soldat", concat(schiffsname, '( ', g.name, ' )') "Einheit"
from soldat
         inner join public.dienstgrad d on d.dienstgradid = soldat.dienstgradid
         inner join public.schiff s on s.schiffid = soldat.stammschiffid
         inner join public.geschwader g on g.geschwaderid = s.geschwaderid
where d.dienstgradid = 400;

grant select on v_besatzungliste_hg to r_fuehrung_lesen;

-- Aufgabe 2: Kostenanalyse nach Klassen
-- Ausgangslage: Der Rechnungsführer muss die Wachen abrechnen und benötigt die Gesamtkosten aller Wachdienste,
-- aufgeschlüsselt nach den Schiffstypen.
-- Aufgabe: Berechnen Sie die SUMME der Kosten mit der Formel: RisikoZuschlag + (Stunden * Stundensatz)
-- Ziel: Anzeige der Spalten Klasse und Gesamtkosten .
-- Hinweis zur Berechnung:
-- EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 -- Ergibt die Stunden
-- Erwartetes Ergebnis:
-- klasse
-- 702
-- gesamtkosten
-- 1298.1

select klasse,
       sum(risikozuschlag +
           EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 * stundensatz)::NUMERIC(100, 2) gesamtkosten
from soldat
         inner join dienstgrad on soldat.dienstgradid = dienstgrad.dienstgradid
         inner join wachdienst on soldat.persnr = wachdienst.soldatid
         inner join schiff on soldat.stammschiffid = schiff.schiffid
group by klasse
order by klasse;

-- Aufgabe 3: Spezifische Belastungsprüfung
-- Ausgangslage: Es gibt Beschwerden über zu hohe Belastung der Hauptgefreiten auf den Fregatten der Klasse F124.
-- Dies soll überprüft werden.
-- Aufgabe: Filtern Sie mittels WHERE nach der Klasse 'F124' UND dem Dienstgrad 'Hauptgefreiter' . Summieren
-- (SUM) Sie anschließend die Stunden.
-- Ziel: Zeigen Sie die Schiffsklasse und die Summe der Stunden an.
-- Erwartetes Ergebnis:
-- klasse
--  stunden_hg_auf_f124
-- F124
--  8.0

select klasse, EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 as stunden_hg_auf_f124
from schiff
         inner join soldat on schiff.schiffid = soldat.stammschiffid
         inner join dienstgrad on soldat.dienstgradid = dienstgrad.dienstgradid
         inner join wachdienst on soldat.persnr = wachdienst.soldatid

where klasse = 'F124'
  and soldat.dienstgradid = 400;

-- Aufgabe 4: Identifikation von Dauerläufern
-- Ausgangslage: Um Übermüdung zu vermeiden, sollen Soldaten identifiziert werden, die insgesamt sehr viel Wache
-- geschoben haben.
-- Aufgabe: Berechnen Sie die Summe der Stunden der Soldaten. Filtern Sie das Ergebnis der Berechnung, um nur
-- Soldaten mit mehr als 5 Stunden anzuzeigen.
-- Ziel: Zeigen Sie Name des Soldaten verbunden mit Dienstgrad (kurz) und die Gesamtstunden an. Sortieren Sie nach
-- Gesamtstunden absteigend.
-- Erwartetes Ergebnis:
-- Soldat
--  gesamtstunden
-- Btsm Christ
--  10.0

select dg_kurz, soldat.name, EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 as gesamtstunden
from soldat
         inner join dienstgrad on soldat.dienstgradid = dienstgrad.dienstgradid
         inner join wachdienst on soldat.persnr = wachdienst.soldatid
where EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 > 5
order by gesamtstunden desc;

-- Aufgabe 5: Übersicht Gefahrenzulagen
-- Ausgangslage: Für den Rechnungsführer soll eine permanente Übersicht aller Wachen erstellt werden, für die ein
-- Risikozuschlag gezahlt wird.
-- Aufgabe: Erstellen Sie eine VIEW namens V_Gefahrenzulage . Filtern Sie mittels WHERE, sodass nur Wachen mit
-- Risikozuschlag > 0 enthalten sind. Sortieren Sie mittels ORDER BY aufsteigend nach dem Zuschlag. Richten Sie
-- anschließend die Security ein: Erstellen Sie ein Schema, Rollen und Benutzer und vergeben Sie die Rechte mittels
-- GRANT.
-- Ziel:
-- 1. Erstellen der View V_Gefahrenzulage .
-- 2. Spalten: Name , PersNr , Schiffsname , Risikozuschlag .
-- 3. Schema: besoldung .
-- 4. Rolle r_refue_vollzugriff (für u_refue) und r_refue_lesen (für u_svo & u_refue_uffz).
-- Erwartetes Ergebnis:
-- name --  persnr --  schiffsname --  risikozuschlag
-- Bauer --  10012 --  FGS Brandenburg --  20.0
create role r_refue_vollzugriff;
create role r_refue_lesen;
grant r_refue_lesen to u_wachmeister;


create view v_gefahrenzulage as
select soldat.name, persnr, schiff.schiffsname, sum(risikozuschlag)
from soldat
         inner join dienstgrad on soldat.dienstgradid = dienstgrad.dienstgradid
         inner join wachdienst on soldat.persnr = wachdienst.soldatid
         inner join schiff on soldat.stammschiffid = schiff.schiffid
where risikozuschlag > 0
group by soldat.name, persnr, schiff.schiffsname;

grant select on v_gefahrenzulage to r_refue_lesen;


-- Aufgabe 10: Überdurchschnittliche Wachen
-- Ausgangslage: Der Flottenarzt möchte wissen, welche einzelnen Wachdienste länger als der Durchschnitt aller jemals
-- geleisteten Wachen waren, um extreme Belastungsspitzen zu erkennen.
-- Aufgabe: Nutzen Sie eine Sub-Query (Unterabfrage) in der WHERE-Klausel. Berechnen Sie in der Sub-Query den
-- Durchschnitt (AVG) aller Wachen und vergleichen Sie die einzelne Dauer damit ( > ).
-- Ziel: Zeigen Sie WachID , Name und Dauer (Std) an.
-- Erwartetes Ergebnis:
-- wachid --  name --  dauer_std
-- 3 --  Matr Bauer --  5.0

select wachid, soldat.name, EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 as gesamtstunden
from wachdienst
inner join soldat on wachdienst.soldatid = soldat.persnr
where EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600 >
      (SELECT AVG(EXTRACT(EPOCH FROM (EndeZeit - StartZeit)) / 3600) FROM wachdienst)
order by gesamtstunden;

-- Aufgabe 11: Generierung Taktischer IDs
-- Ausgangslage: Für den verschlüsselten Funkverkehr soll eine „Taktische ID“ für jeden Soldaten generiert werden.
-- Aufgabe: Nutzen Sie String-Funktionen, um die ersten 3 Buchstaben des Namens großzuschreiben, und verbinden Sie
-- diese mit der Personalnummer.
-- Ziel: Anzeige von Name , PersNr und der generierten taktische_id . Format: NAM-12345
-- Erwartetes Ergebnis:
-- name --  persnr --  taktische_id
-- Just --  20211 --  JUS-20211

select name, persnr, upper(left(name, 3)) || '-' || persnr as  taktische_id from soldat;
-- Probeklausur SQL / PostgreSQL
-- Thema: Iran-Konflikt, Straße von Hormus, verminte Routen, Wegzoll, Militär- und Handelsschiffe
-- Wichtiger Hinweis: INSERT, ALTER und UPDATE sind ausdrücklich NICHT Teil dieser Aufgabensammlung.
-- Für die Aufgaben 26 bis 30 wird ggf. plpython3u benötigt:
-- CREATE EXTENSION IF NOT EXISTS plpython3u;

-- Aufgabe 01
-- Zeige alle unterschiedlichen Akteure.
-- Erwartete Treffer: 13
-- Tipp: Nutze DISTINCT.

SELECT DISTINCT country
FROM actor;
-- hier ergänzen
;

-- Aufgabe 02
-- Gib alle Tanker mit Alias "Schiffsname" aus.
-- Erwartete Treffer: 200

SELECT name AS schiffsname
FROM ship
WHERE ship_type_id = 1;


-- Aufgabe 03
-- Welcher Akteur hat die meisten Schiffe? Gib nur den ersten Datensatz aus.
-- Erwartete Treffer: 1

SELECT a.name, COUNT(ship_id)
FROM ship
         INNER JOIN public.actor a ON ship.actor_id = a.actor_id
GROUP BY a.name
ORDER BY COUNT(ship_id) DESC
LIMIT 1;
;

-- Aufgabe 04
-- Gib den zweitgrößten Tanker nach Tonnage aus.
-- Erwartete Treffer: 1

SELECT name, ship.tonnage FROM ship ORDER BY tonnage DESC OFFSET 1 LIMIT 1;

-- Aufgabe 05
-- Welche blockierten Durchfahrten fanden auf verminten Routen statt?
-- Erwartete Treffer: 1251

SELECT * from passage WHERE status ILIKE '%blockiert%';

-- Aufgabe 06
-- Zeige alle Zollzahlungen zwischen 100000 und 130000 USD.
-- Erwartete Treffer: 295

SELECT
-- hier ergänzen
;

-- Aufgabe 07
-- Zeige Durchfahrten mit mehr als 60000 t Ladung und weniger als 40000 t Gefahrgut.
-- Erwartete Treffer: 279

SELECT
-- hier ergänzen
;

-- Aufgabe 08
-- Zeige alle Schiffe, die weder Kriegsschiff noch Schnellboot sind.
-- Erwartete Treffer: 1900

SELECT
-- hier ergänzen
;

-- Aufgabe 09
-- Welche Akteure besitzen mehr als 100 Schiffe?
-- Erwartete Treffer: 7

SELECT
-- hier ergänzen
;

-- Aufgabe 10
-- Welche Empfänger erhielten insgesamt mehr als 10.000.000 USD Wegzoll?
-- Erwartete Treffer: 2

SELECT
-- hier ergänzen
;

-- Aufgabe 11
-- Zeige alle Schiffe des Akteurs Iran.
-- Erwartete Treffer: 0

SELECT
-- hier ergänzen
;

-- Aufgabe 12
-- Welche Akteure besitzen kein einziges Schiff?
-- Erwartete Treffer: 2

SELECT
-- hier ergänzen
;

-- Aufgabe 13
-- Welche Häfen kommen in keiner Route vor?
-- Erwartete Treffer: 3

SELECT
-- hier ergänzen
;

-- Aufgabe 14
-- Verknüpfe Schiffsname und Akteur in einer einzigen Spalte.
-- Erwartete Treffer: 2200

SELECT
-- hier ergänzen
;

-- Aufgabe 15
-- Gib von jedem Schiff nur die ersten 6 Zeichen des Namens aus.
-- Erwartete Treffer: 2200

SELECT
-- hier ergänzen
;

-- Aufgabe 16
-- Gib aus jedem Akteursnamen das letzte Wort aus.
-- Erwartete Treffer: 13

SELECT
-- hier ergänzen
;

-- Aufgabe 17
-- Wie viele Schiffe gibt es pro Schiffstyp?
-- Erwartete Treffer: 7

SELECT
-- hier ergänzen
;

-- Aufgabe 18
-- Summiere die Zollbeträge pro Zahlungsdatum.
-- Erwartete Treffer: 30

SELECT
-- hier ergänzen
;

-- Aufgabe 19
-- Zeige die Monate, in denen Durchfahrten gestartet sind.
-- Erwartete Treffer: 2

SELECT
-- hier ergänzen
;

-- Aufgabe 20
-- Berechne die durchschnittliche Tonnage pro Schiffstyp, gerundet auf 2 Nachkommastellen.
-- Erwartete Treffer: 7

SELECT
-- hier ergänzen
;

-- Aufgabe 21
-- Berechne die Tonnage jedes Tankers in Prozent von 100000.
-- Erwartete Treffer: 200

SELECT
-- hier ergänzen
;

-- Aufgabe 22
-- Erzeuge per VALUES-Tabelle eine kleine Gefahrenstufen-Tabelle mit den Werten 1 bis 4.
-- Erwartete Treffer: 4

SELECT
-- hier ergänzen
;

-- Aufgabe 23
-- Erzeuge eine Wahrheitstabelle für zwei boolesche Eingaben e1 und e2.
-- Erwartete Treffer: 4

SELECT
-- hier ergänzen
;

-- Aufgabe 24
-- Gib den String Grocer's apostrophe korrekt mit Escape aus.
-- Erwartete Treffer: 1

SELECT
-- hier ergänzen
;

-- Aufgabe 25
-- Gib das Unicode-Zeichen für eine Schlange aus.
-- Erwartete Treffer: 1

SELECT
-- hier ergänzen
;

-- Aufgabe 26
-- Erstelle eine PL/Python-Funktion py_hallo_hormus(), die eine Info-Ausgabe mit dem Text 'Hallo aus Hormus' schreibt.
-- Erwartete Treffer: 1
-- Hinweis: Anschließend mit SELECT py_hallo_hormus(); aufrufen.

CREATE FUNCTION py_hallo_hormus()
RETURNS VOID
LANGUAGE plpython3u
AS
$$
plpy.info('Hallo aus Hormus')
$$;
SELECT py_hallo_hormus();

-- Aufgabe 27
-- Erstelle eine PL/Python-Funktion py_summe_wegzoll(a INTEGER, b INTEGER), die die Summe zurückgibt.
-- Erwartete Treffer: 1
-- Testidee: SELECT py_summe_wegzoll(5, 7);

create FUNCTION py_summe_wegzoll(a INTEGER, b INTEGER)
RETURNS INTEGER
LANGUAGE plpython3u
AS
$$
    return a+b
$$;
SELECT py_summe_wegzoll(5,4);


-- Aufgabe 28
-- Erstelle eine PL/Python-Funktion py_naechster_tag(heute DATE), die den Folgetag berechnet.
-- Erwartete Treffer: 1
-- Testidee: SELECT py_naechster_tag('2026-04-01');

CREATE FUNCTION py_morgen(heute DATE)
RETURNS VOID
LANGUAGE plpython3u
AS
    $$
    from datetime import date, timedelta
    morgen = date.fromisoformat(heute) + timedelta(days=1)
    plpy.info(f'Heute ist der {heute} und moren ist der {morgen}.')
    plpy.info(f'Typ: {type(heute)} Morgen-Typ: {type(morgen)}.')
    $$;
SELECT py_morgen('01.04.2026');



-- Aufgabe 29
-- Erstelle eine PL/Python-Funktion py_route_info(IN p_route_id INTEGER, OUT route_name TEXT, OUT anzahl_zwischenfaelle INTEGER).
-- Erwartete Treffer: 1
-- Testidee: SELECT * FROM py_route_info(1);

-- hier ergänzen

-- Aufgabe 30
-- Erstelle eine PL/Python-Funktion py_ersten_drei_tanker(), die eine Tabelle mit id und name der ersten drei Tanker zurückgibt.
-- Erwartete Treffer: 3
-- Testidee: SELECT * FROM py_ersten_drei_tanker();

-- hier ergänzen

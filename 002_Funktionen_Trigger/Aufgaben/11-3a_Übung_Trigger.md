# Übungsaufgaben Trigger

Diese Übungsaufgaben dienen dazu, sich mit der Programmierung von (PL/Python3-)Trigger-Funktionen in PostgreSQL vertraut
zu
machen.

Sie müssen in der `db_personalverwaltung`-Datenbank (s. Datei `11-2a_Übung_Interaktion_mit_dem_DBMS_Vorlage.sql`) gelöst
werden.

Die genannte Datei enthält die notwendigen Anweisungen für

- das Anlegen der Datenbank
- das Anlegen der Tabellen
- das Leeren der Tabellen

Hinweise zur Nutzung sind in den Kommentaren gegeben.
Es ist nicht so gedacht, dass diese Datei hirnlos ausgeführt wird!

Die Datenbank entspricht dem folgenden Relationenschema:

---
skill(*skill_id*, skill_bezeichnung)

person(*person_id*, name, rufname, geburtsdatum, geburtsort)

person_hat_skill(*fk_person_id, fk_skill_id*)

---

## Vorbereitung

Ergänzen Sie die Datenbank um eine Tabelle gehalt(*fk_person_id*, monatsgehalt NUMERIC(6,2) ) - hier besteht also eine
1:1-Beziehung zu den Personen.

Ergänzen Sie die Datenbank um eine weitere Tabelle
log_gehalt_aenderung (*log_id* BIGINT-Surrogatschlüssel, username TEXT, zeit TIMESTAMP WITH TIMEZONE, person_id,
gehalt_alt, gehalt_neu ) (Datentypen
wie oben).

## Aufgabe 1

Programmieren Sie eine Trigger-Funktion `log_gehalt_aenderung_funktion`, die die Protokolltabelle pflegt.

Richten Sie einen Trigger ein, der *nach* jedem `UPDATE` der Tabelle `gehalt` läuft und diese Triggerfunktion aufruft.

Fügen Sie ein paar Gehaltsdaten ein, ändern Sie sie und beobachten die Protokolltabelle.

## Aufgabe 2

Programmieren Sie eine Trigger-Funktion `brich_update_gehalt_ab_funktion`.
Diese Funktion prüft, ob der neue Gehaltswert kleiner als der alte ist und wirft in diesem Fall eine Exception mit einer
aussagekräftigen Fehlermeldung, den Beträgen, dem Namen und der `person_id` des betroffenen Mitarbeiters.

Richten Sie einen Trigger ein, der *vor* jedem `UPDATE` der Tabelle `gehalt` läuft und diese Triggerfunktion aufruft.

Ändern Sie ein paar Gehaltsdaten so, dass die Exception ausgelöst wird.
Untersuchen Sie die Tabelle `gehalt` und die Protokolltabelle.

## Aufgabe 3

In dieser Aufgabe geht es um die selbständige Erarbeitung von [
`INSTEADOF`-Triggern](https://neon.tech/postgresql/postgresql-triggers/postgresql-instead-of-triggers).
Diese arbeiten auf `VIEWs`. Hiermit können `VIEWs`, die
nicht [updateable](https://www.postgresql.org/docs/current/sql-createview.html) sind (weil sie z.B. einen `JOIN`
enthalten) so tun, als wären Sie veränderlich.

Der `INSTEADOF`-Trigger für `INSERT` liegt auf der `VIEW`, fängt "seinen" `INSERT`-Befehl ab und führt stattdessen
ein oder mehrere passende `INSERT`(s) auf die unter der `VIEW` liegenden Tabellen aus.

Gleiches gilt für den `INSTEADOF`-Trigger für `UPDATE` oder `DELETE`.

Beginnen Sie damit, dass Sie eine `VIEW` anlegen, in der die `person`en mit `person_id`, `name` und `monatsgehalt`
sichtbar sind. Versuchen Sie, das Gehalt eines Mitarbeiters per `UPDATE` auf der `VIEW` zu ändern (Spoiler: das sollte
nicht gehen).

Programmieren Sie als nächstes eine Triggerfunktion, die `UPDATE`-Statements auf der `gehalt`-Tabelle ausführen kann,
wenn in `TD` steht, dass es sich um ein `UPDATE` für Ihre `VIEW` handelt.

Richten Sie dann diese Funktion als `INSTEADOF`-Trigger für `UPDATE`s auf Ihrer `VIEW` ein.
Versuchen Sie erneut, das Gehalt eines Mitarbeiters per `UPDATE` auf der `VIEW` zu ändern (jetzt sollte es so aussehen,
als ob das ginge, weil in Wirklichkeit Ihre Triggerfunktion die Arbeit macht).

Achten Sie insbesondere auf die Protokollierung und die Abbrüche, die man mit den `UPDATE`-Triggern auf `gehalt` jetzt
implizit auslöst... 




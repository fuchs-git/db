# Übungsaufgaben Funktionen 1

Diese Übungsaufgaben dienen dazu, sich mit der Programmierung von (PL/Python3-)Funktionen in PostgreSQL vertraut zu
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



Folgende Daten sollen dort später eingepflegt werden:

| Nachname  | Rufname | Geburtsdatum | Geburtsort | Fähigkeiten (IT)                   |
|-----------|---------|--------------|------------|------------------------------------|
| Müller    | Anna    | 15.03.1985   | Berlin     | Entwickler, Datenbankadministrator |
| Schmidt   | Peter   | 22.09.1978   | München    | Systemadministrator, IT-Sicherheit |
| Schneider | Julia   | 01.12.1992   | Hamburg    | Entwickler, Projektmanager         |
| Fischer   | Michael | 10.06.1965   | Köln       | Netzwerktechniker, Cloud-Experte   |
| Weber     | Sabine  | 28.04.2001   | Frankfurt  | Entwickler, UX-Designer            |

Diese Daten stehen "Semikolon-separiert" in der Vorlagedatei zur Verfügung.

## Aufgabe 1

Programmieren Sie eine Funktion `py_hole_skill_id_fuer()`.
Die Funktion übernimmt eine Skillbezeichnung (`TEXT`) und liefert die zugehörige `skill_id` aus der Tabelle zurück.

Falls es in der Tabelle noch keinen Eintrag für diesen Skill gibt, wird ein Eintrag eingefügt und dessen `skill_id`
zurückgegeben.

Denken Sie daran, dass SQL-Strings mit `'` eingefasst werden müssen (und Sie das in Ihren `INSERT`-Befehlen selbst
machen müssen).

Für die Rückgabe kann man davon ausgehen, dass es keine doppelten `skill_bezeichnung`en in der Tabelle gibt (dafür sorgt
das `UNIQUE`-Constraint).

Besser liest man in
der [Dokumentation den Abschnitt über den RETURNING-Zusatz](https://www.postgresql.org/docs/current/dml-returning.html)
zu `INSERT` und `UPDATE` und nutzt das.

Zukünftig muss ein Frontend-Entwickler gar nicht wissen, ob es eine bestimmte Skill-Eintragung schon gibt - es wird
einfach diese Funktion genutzt, und die liefert immer die richtige `skill_id` (so lange niemand `eNtWiCkLeR` schreibt).

## Aufgabe 2

Programmieren Sie eine Funktion `py_person_einfuegen()` zum Einfügen von Personal in die `person`-Tabelle.

Die Funktion übernimmt folgende Parameter mit den angegebenen SQL-Datentypen:

- name (`TEXT`)
- rufname (`TEXT`)
- geburtsdatum (`TEXT`)
- geburtsort (`TEXT`)

Die Funktion gibt die `person_id` des neu eingefügten Datensatzes zurück.

Das Geburtsdatum muss python-seitig überprüft werden, ob es ein gültiges Datum enthält.
Das geht am einfachsten mithilfe von

```python
datetime.strptime(geburtsdatum, '%d.%m.%Y').date()
```

aus dem entsprechenden Modul. `strptime` kann dabei aus verschiedenen "Mustern" Datumswerte zu `datetime`-Objekten
parsen.
Hier ist das im deutschen Sprachraum übliche Muster "Tag.Monat.Jahr" bereits angegeben, das den Strings in der Vorlage
entspricht.

Bei einem ungültigen Datum soll unsere Funktion einen Fehler (`error`) werfen, der eine aussagekäftige Fehlermeldung und
den fehlerhaften Wert enthält. Testen Sie dieses Fehlerverhalten.

### Aufgabe 2a

Ändern Sie den Datentyp des `geburtsdatum`-Parameters auf den SQL-Typ `DATE`.
Beobachten Sie das geänderte Verhalten Ihrer Funktion bei unveränderten Aufrufen.

Was ist das Problem?

... machen Sie diese Änderung nach dem Erkenntnisgewinn wieder rückgängig.

## Aufgabe 3

Nachdem in unsere Datenbank nun Skills und Personen mittels Funktionen einpflegen können, fehlt noch eine Funktion, die
Personen mit Fähigkeiten versieht.

Programmieren Sie eine Funktion, die eine `person_id` (`INTEGER`) und einen String mit einem oder mehreren
komma-getrennten SKills (`TEXT`) übernimmt.

Die Funktion gibt nichts (`VOID`) zurück.

Zunächst muss die Funktion prüfen, ob die `person_id` wirklich gültig ist, d.h. ein zugehöriger Eintrag in der `person`
-Tabelle existiert.
Wenn das nicht der Fall ist, soll die Verarbeitung mit einem aussagekräftigen `error` abgebrochen werden.

Im anderen (positiven) Fall werden die `skill_id`s mit der Funktion aus [Aufgabe 1](#aufgabe-1) geholt.
Denken Sie daran, die Skillbezeichnungen von eventuellen Leerzeichen am Anfang und am Ende zu befreien.

Die überprüfte `person_id` und die `skill_id` werden dann in die n:m-Tabelle eingefügt.

Testen Sie Ihre Funktion mit den beigefügten Daten, testen Sie insbesondere auch die Reaktion auf ungültige `person_id`
s.

### Aufgabe 3a

Jetzt könnte man beliebig weiter eskalieren, indem man eine Funktion programmiert, die die Person anlegt und gleich mit
Skills versieht.

Das ist hier nicht vorgesehen, denn wir glauben, dass wir diesen Fall (neue Person kommt mit möglicherweise neuen
Skills) dafür zu selten haben.
Gängige Geschäftsvorfälle, die nun abgebildet wurden: Personen einstellen, Persone erwirbt zusätzliche Skills (die
bisher vielleicht noch nicht in der Firma vorhanden waren).

... das kann man also machen, muss man aber gar nicht

### Aufgabe 3c

Man könnte eine Funktion zum Entlassen von Mitarbeitern programmieren, die vorher prüfen, welche Fähigkeiten der Firma verloren gehen werden...















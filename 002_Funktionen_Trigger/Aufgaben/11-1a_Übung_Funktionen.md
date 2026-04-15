# Übungsaufgaben Funktionen 1

Diese Übungsaufgaben dienen dazu, sich mit der Programmierung von (PL/Python3-)Funktionen in PostgreSQL vertraut zu
machen.
Sie können in der postgres-Datenbank oder einer beliebigen anderen Datenbank angelegt werden, da sie nicht mit der
Datenbank selbst interagieren werden.

## Aufgabe 1 - Funktion mit einem Parameter und einfachem Return

Programmieren Sie eine Funktion, die eine übergebene Ziffer (Ganzzahl mit 0 <= n < 10) in das zugehörige englische
Zahlwort übersetzt und dieses als TEXT zurückgibt.

---
**Beispiel**

```SELECT py_digit_to_text(5);```
liefert
```'five'```

---

Falls die übergebene Zahl zu klein oder zu groß ist, soll ein Fehler mit einer aussagekräftigen Fehlermeldung geworfen
werden, in der insbesondere die verkehrte Zahl vorkommt.

## Aufgabe 2 - Funktion, die eine Tabelle zurückgibt

Programmieren Sie eine Funktion, die das Lied [99 Bottles of Beer](https://de.wikipedia.org/wiki/99_Bottles_of_Beer)
"singt".
Die Funktion übernimmt eine positive Ganzzahl, die als Startwert dient.
Wenn jemand versucht, mit weniger als einer Flasche Bier zu starten, bekommt er eine entsprechende Fehlermeldung.

Das Lied soll gesungen werden, bis das Bier wirklich aus ist und jemand Nachschub holen muss.
Es wird soviel Nachschub geholt, wie der Startwert betrug (letzteStrophe des Beispiels).

Die Zeilenumbrüche im Beispiel sind HTML-Zeilenumbrüche, aber das liegt an der
Markdown-Darstellung.

Die einzelnen Strophen sollen dabei als Zeilen einer Tabelle dargestellt werden, deren erste Spalte die Zahl (als
Ganzzahl), die zweite den Text der Strophe enthält.

Zahlen können dabei als Zahl geschrieben werden.


---
**Beispiel**

```SELECT beers, lyrics FROM py_beer(5);```
liefert

| beers | lyrics                                                                                                                                        |
|:------|:----------------------------------------------------------------------------------------------------------------------------------------------|
| 5     | 5 bottles of beer on the wall,<br/>5 bottles of beer.<br/>Take one down, pass it around,<br/>4 bottles of beer on the wall.                   |
| 4     | 4 bottles of beer on the wall,<br/>4 bottles of beer.<br/>Take one down, pass it around,<br/>3 bottles of beer on the wall.                   |
| 3     | 3 bottles of beer on the wall,<br/>3 bottles of beer.<br/>Take one down, pass it around,<br/>2 bottles of beer on the wall.                   |
| 2     | 2 bottles of beer on the wall,<br/>2 bottles of beer.<br/>Take one down, pass it around,<br/>1 bottle of beer on the wall.                    |
| 1     | One last bottle of beer on the wall,<br/>One last bottle of beer.<br/>Take one down, pass it around,<br/>No more bottles of beer on the wall. |
| 0     | No more bottles of beer on the wall,<br/>No more last bottles of beer.<br/>Go to the store, buy some more,<br/>5 bottles of beer on the wall. |

---

## Aufgabe 3 - Funktionen benutzen andere Funktionen ist nicht so einfach

Programmieren Sie eine Funktion, die zwei Ganzzahlen (mit n >= 0) übernimmt.
Diese dienen als Start- und Endwerte (jeweils einschließlich), Start muss dabei kleiner als Ende sein.

Falls etwas davon nicht der Fall ist, soll ein Fehler mit einer aussagekräftigen Fehlermeldung geworfen werden, in der
insbesondere die verkehrten Zahlen vorkommt.

Die Funktion gibt eine Tabelle mit zwei Spalten zurück: ```INTEGER``` mit der Zahl und ```TEXT``` mit der ziffernweisen
Übersetzung in die entsprechenden Zahlwörter.

---
**Beispiel**

```SELECT number, name FROM py_numbers_to_text(123, 127);```

liefert:

| number | name          |
|:-------|:--------------|
| 123    | one-two-three |
| 124    | one-two-four  |
| 125    | one-two-five  |
| 126    | one-two-six   |
| 127    | one-two-seven |

---

Versuchen Sie insbesondere, hierfür die Funktion
aus [Aufgabe 1](#aufgabe-1---funktion-mit-einem-parameter-und-einfachem-return) zu benutzen - und überlegen Sie, warum
das nicht so einfach funktioniert.

Python erlaubt zum Glück die Definition von Funktionen innerhalb von anderen Funktionen. Falls jemand bisher noch keine
Idee hat, wann man das brauchen kann: jetzt. 

Aber es geht natürlich auch ohne lokale Funktion.

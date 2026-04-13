# plpy.pyi – Type Stub für PL/Python3u in PostgreSQL

from typing import Any, Protocol, Iterator


class Plan(Protocol):
    """
    Ein Ausführungsplan-Objekt
    """
    def __call__(self, *args: Any) -> list[dict[str, Any]]: ...

    def cursor(self, *args: Any) -> 'Cursor':
        """
        Holt einen Cursor für diesen Plan.
        :param args: Parameter für die Abfrage, die hinter diesem Plan steht
        :return: der Cursor
        """
        ...


class Cursor(Protocol):
    """
    Der Cursor ist ein Iterator für das Ergebnis einer Abfrage.
    Er erlaubt die zeilenweise Verarbeitung des Ergebnisses in einer for-Schleife
    """

    def fetch(self, n: int = 0) -> list[dict[str, Any]]:
        """
        Holt die nächsten n Zeilen des Ergebnisses.
        :param n: n Zeilen des Ergebnisses, default 0 für "hole alle"
        :return: das Abfrageergebnis als Ergebnis-Objekt (das sich ähnlich wie eine Liste von Tupeln mit benannten Spalten benimmt)
        """
        ...

    def move(self, n: int = 1) -> None:
        """
        Bewegt den Cursor über n Zeilen des Ergebnisses, *ohne die zu holen*
        :param n: n Zeilen "vorspulen"
        :return: nichts
        """
        ...

    def close(self) -> None:
        """
        Schließt den Cursor (braucht nicht explizit aufgerufen zu werden!)
        :return: Nichts
        """
        ...

    def __iter__(self) -> Iterator[dict[str, Any]]: ...


def execute(query: str, max_rows: int = 0) -> list[dict[str, Any]]:
    """
    Führt die Abfrage aus und liefert das Ergebnis
    :param query: Die Abfrage als String
    :param max_rows:  die Anzahl der zu liefernden Zeilen (wie SQL LIMIT), default 0 für kein Limit
    :return: das Abfrageergebnis als Ergebnis-Objekt (das sich ähnlich wie eine Liste von Tupeln mit benannten Spalten benimmt)
    """
    ...


def prepare(query: str, argtypes: list[str]) -> Plan:
    """
    Bereitet die Abfrage vor und erzeugt einen Ausführungsplan.
    :param query: die Abfrage als String
    :param argtypes: die Datentypen der Parameter in der Abfrage (als Strings)
    :return: ein Plan-Objekt
    """
    ...


def cursor(query: str, plan: Plan = None, args: list[Any] = []) -> Cursor:
    """
    Führt die Abfrage aus und liefert einen Cursor, mit dem das Ergebnis schrittweise bearbeitet werden kann.
    :param query: die Abfrage
    :param plan: ein Plan-Objekt
    :param args: die Parameter
    :return: ein Cursor
    """
    ...


def debug(msg: str, **kwargs) -> None:
    """
    Unterdrücktes Nachricht!
    Schickt eine Debug-Nachricht an den Client (oder auch nicht)
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def log(msg: str, **kwargs) -> None:
    """
    Unterdrücktes Nachricht!
    Schickt eine Log-Nachricht an den Client (oder auch nicht)
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def info(msg: str, **kwargs) -> None:
    """
    Schickt eine Nachricht an den Client, die dort auf der Konsole ausgegeben wird.
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def notice(msg: str, **kwargs) -> None:
    """
    Schickt eine Nachricht an den Client, die dort auf der Konsole ausgegeben wird.
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def warning(msg: str, **kwargs) -> None:
    """
    Schickt eine Warnung an den Client, die dort auf der Konsole ausgegeben wird.
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def error(msg: str, **kwargs) -> None:
    """
    Schickt eine Exception an den Client, die dort behandelt werden muss.
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


def fatal(msg: str, **kwargs) -> None:
    """
    Schickt eine Exception an den Client, die dort behandelt werden muss.
    Dieses Level ist für Fehler gedacht, die für den Serverdienst tödlich sein könnten!
    :param msg: die Nachricht als String
    :param kwargs: akzeptierte Schlüsselwörter für weitere Strings: detail, hint, sqlstate, schema_name, table_name, column_name, datatype_name, constraint_name
    :return: nichts
    """
    ...


__all__: list[str]

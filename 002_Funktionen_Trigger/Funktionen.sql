FROM importlib
IMPORT import_module
    select current_database();
SELECT *
FROM pg_available_extensions;

SELECT *
FROM pg_available_extensions
WHERE comment ILIKE '%lang%';
SELECT *
FROM pg_available_extensions
WHERE name ILIKE '%python%';

-- 1x pro Datenbank
CREATE EXTENSION plpython3u;


SELECT $$Hallo Welt$$                AS dollar_quoted,
       'Hallo Welt'                  AS normal,
       $$Hallo Welt$$ = 'Hallo Welt' AS vergleich;


DO LANGUAGE plpython3u
$$
print('Hello World!')
$$;

-- Ausgabe ohne print
DO LANGUAGE plpython3u
$$
import plpy
import sys

plpy.info(f'Hello World!\n{sys.version_info}')
$$;

-- Welche LogLevel sind eingestellt?
SELECT *
FROM pg_settings
WHERE name ILIKE '%messages%';

-- Unsichtbar: plpy.debug() / plpy.log()
-- Sichtbar: plpy.info()  / plpy.notice() / plpy.warning() / plpy.error() / plpy.fatal()

DO LANGUAGE plpython3u
$$
import plpy
import sys

plpy.fatal(f'Hello World!')
$$;

-- Funktion
DROP FUNCTION IF EXISTS py_hallo_funktion;


CREATE FUNCTION py_hallo_funktion()
    RETURNS VOID
    LANGUAGE plpython3u
AS
$$
    plpy.info('Hallo aus der Funktion im DBMS!')

$$;

SELECT py_hallo_funktion();


-- Funktion mit Parameter
DO LANGUAGE plpython3u
$$
import plpy

me = 'Erwin'
plpy.info(f'Hallo {me}, schön, dass Du Funktionen schreibst!')
$$;

DROP FUNCTION IF EXISTS py_greet_me;

CREATE FUNCTION py_greet_me(me TEXT)
    RETURNS VOID
    LANGUAGE plpython3u AS
$$
    import plpy
    plpy.info(f'Hallo {me}, schön, dass Du Funktionen schreibst!')
$$;
SELECT py_greet_me('Alice');


DROP FUNCTION py_what_type_is;
CREATE FUNCTION py_what_type_is(this TEXT)
    RETURNS VOID
    LANGUAGE plpython3u
AS
$$
    plpy.info(f'Es wurde "{this}" übertragen. Typ: {type(this)}.')
$$;
SELECT py_what_type_is('Hallo');


DROP FUNCTION py_what_type_is;
CREATE FUNCTION py_what_type_is(this INT)
    RETURNS VOID
    LANGUAGE plpython3u
AS
$$
    plpy.info(f'Es wurde "{this}" übertragen. Typ: {type(this)}.')
$$;
SELECT py_what_type_is(500000);


DROP FUNCTION py_what_type_is;
CREATE FUNCTION py_what_type_is(this DATE)
    RETURNS VOID
    LANGUAGE plpython3u
AS
$$
    plpy.info(f'Es wurde "{this}" übertragen. Typ: {type(this)}.')
$$;
SELECT py_what_type_is('01.04.2026');


DROP FUNCTION py_morgen;
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


DROP FUNCTION py_dumme_summe;
CREATE FUNCTION py_dumme_summe(a INTEGER, b INTEGER)
    RETURNS INTEGER
    LANGUAGE plpython3u
AS
$$
    return a + b
$$;
SELECT py_dumme_summe(b := 5, a := 3), PG_TYPEOF(py_dumme_summe(b := 5, a := 3));


DROP FUNCTION py_tupel();
CREATE FUNCTION py_tupel(IN kommt_rein TEXT, OUT kommt_raus TEXT, OUT kommt_auch_raus INTEGER)
    RETURNS RECORD
    LANGUAGE plpython3u
AS
$$
    kommt_raus = f'verändert: {kommt_rein} mit Dingen dran'
    kommt_auch_raus = 3
    return kommt_raus, kommt_auch_raus
$$;
SELECT *
FROM py_tupel('hallo welt');

DROP FUNCTION py_tabelle;
CREATE FUNCTION py_tabelle()
    RETURNS TABLE (
        code      INTEGER,
        buchstabe CHAR(1)
    )
    LANGUAGE plpython3u
AS
    $$
        ergebnis = []
        for buchstabe in 'ABC':
            code = ord(buchstabe)
            ergebnis.append((code, buchstabe))
        return ergebnis
    $$;
SELECT * FROM py_tabelle();


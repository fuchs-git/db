CREATE EXTENSION plpython3u;
DO LANGUAGE plpython3u
$$
import plpy

result = plpy.execute("select current_database() as wo_sind_wir;")
plpy.notice(result)
plpy.notice(f'Die Abfrage hatte {len(result)} Zeilen')
plpy.notice(f'Die Spalten habene die Namen {result.colnames()}')
plpy.notice(f'Die Spalten habene die Typen {result.coltypes()}')

plpy.notice(f'Da steht "{result[0]['wo_sind_wir']}" drin')
$$;

SELECT typname
FROM pg_type
WHERE oid = 19;

DROP FUNCTION py_oid_to_typname(a INTEGER);
CREATE FUNCTION py_oid_to_typname(a INTEGER)
    RETURNS TABLE (
        nummer INTEGER,
        name   TEXT
    )
    LANGUAGE plpython3u
AS
$$
    import plpy
    result = plpy.execute(f"SELECT typname FROM pg_type WHERE oid = {a};")

    if not len(result) == 1:
        plpy.error('kein Datentyp gefunden')
    return [{
        "nummer": a,
        "name": result[0]["typname"]
    }]
$$;

SELECT py_oid_to_typname(23);

DROP FUNCTION py_what_the_dict();
CREATE FUNCTION py_what_the_dict()
    RETURNS VOID
    LANGUAGE plpython3u
AS
$$
    import plpy
    plpy.notice(f'{SD=}')
    plpy.notice(f'{GD=}')
$$;
SELECT py_what_the_dict();


SELECT density
FROM satellite;
DROP FUNCTION py_leichte_und_schwere_monde();
CREATE FUNCTION py_leichte_und_schwere_monde(
    OUT durchsch_leichte NUMERIC(6,5),
    OUT durchsch_schwere NUMERIC(6,5)
)
LANGUAGE plpython3u
AS
$$
    anzahl_leichte = 0
    summe_leichte = 0
    anzahl_schwere = 0
    summe_schwere = 0
    for x in plpy.cursor('SELECT density FROM satellite;'):
        if x['density'] is not None:
            if x['density'] < 1:
                summe_leichte += x['density']
                anzahl_leichte += 1
            else:
                summe_schwere += x['density']
                anzahl_schwere += 1
        else:
            plpy.notice('Fehler')
    durchsch_leichte = summe_leichte / anzahl_leichte
    durchsch_schwere = summe_schwere / anzahl_schwere

    return durchsch_leichte, durchsch_schwere
$$;

SELECT * FROM py_leichte_und_schwere_monde();
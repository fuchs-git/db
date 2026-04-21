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

SELECT *
FROM pg_type
WHERE oid = 19;


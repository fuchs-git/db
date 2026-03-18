SELECT CURRENT_DATABASE();
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



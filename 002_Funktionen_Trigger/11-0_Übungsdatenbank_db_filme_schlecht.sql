-- CREATE DATABASE db_filme_schlecht;

SELECT datname
FROM pg_database;

DROP TABLE IF EXISTS top_rated_films, most_popular_films;

-- die Normalisierung ist hier totaler Mist!
-- nicht nachmachen!
-- das ist eine Übungskünstlichkeit, um die Mengenoperationen zeigen zu können!

CREATE TABLE top_rated_films (
    title        TEXT NOT NULL,
    release_year SMALLINT
);

CREATE TABLE most_popular_films (
    title        TEXT NOT NULL,
    release_year SMALLINT
);

INSERT INTO top_rated_films(title, release_year)
VALUES ('Fast and Furious 7', 2011),
       ('The Redemption', 2015),
       ('Shooter', 2017);

INSERT INTO most_popular_films(title, release_year)
VALUES ('American Sniper', 2015),
       ('Doulou Continent', 2018),
       ('Outpost', 2019),
       ('Shooter', 2017);

-- Union
SELECT *
FROM top_rated_films
UNION
SELECT *
FROM most_popular_films;

-- Mit Duplikaten
SELECT title, release_year
FROM top_rated_films
UNION ALL
SELECT title, release_year
FROM most_popular_films;

-- INTERSEC
SELECT title, release_year
FROM top_rated_films
INTERSECT
SELECT title, release_year
FROM most_popular_films;


-- INTERSEC ALL
SELECT title, release_year
FROM top_rated_films
INTERSECT ALL
SELECT title, release_year
FROM most_popular_films;


-- EXCEPT (ohne) A ohne B ist nicht = B ohne A!
SELECT title, release_year
FROM top_rated_films
EXCEPT
-- ALL
SELECT title, release_year
FROM most_popular_films;

-- IF /Else -> CASE WHEN THEN
SELECT title,
       release_year,
       CASE
           WHEN release_year % 2 = 0 THEN 'gerade'
           WHEN release_year % 3 = 0 THEN CONCAT(release_year, ' ist durch 3 teilbar')
           ELSE 'nix schlaues'
           END AS schlaue_sachen_zum_jahr
FROM most_popular_films;
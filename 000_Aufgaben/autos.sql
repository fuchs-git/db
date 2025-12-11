-- CREATE DATABASE db_autos;

-- Hersteller / Marken
CREATE TABLE brand
(
    brand_id     SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    country      VARCHAR(50)  NOT NULL,
    group_name   VARCHAR(100), -- Konzern, z.B. "Volkswagen Group"
    founded_year INT
);

-- Modelle
CREATE TABLE model
(
    model_id       SERIAL PRIMARY KEY,
    brand_id       INT          NOT NULL REFERENCES brand (brand_id),
    name           VARCHAR(100) NOT NULL,
    body_type      VARCHAR(50),   -- Hatchback, Sedan, SUV, Coupe, ...
    segment        VARCHAR(50),   -- Compact, Mid-size, SUV, Luxury, Electric, ...
    launch_year    INT,
    base_price_eur NUMERIC(10, 2) -- Listenpreis (Basis)
);

-- Motoren
CREATE TABLE engine
(
    engine_id      SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    fuel_type      VARCHAR(20)  NOT NULL, -- Petrol, Diesel, Hybrid, Electric
    horsepower     INT          NOT NULL,
    displacement_l NUMERIC(4, 1)          -- Hubraum in Litern (bei Elektro 0.0)
);

-- Zuordnung Modelle <-> Motoren (N:M)
CREATE TABLE model_engine
(
    model_id  INT NOT NULL REFERENCES model (model_id),
    engine_id INT NOT NULL REFERENCES engine (engine_id),
    PRIMARY KEY (model_id, engine_id)
);

-- Händler
CREATE TABLE dealership
(
    dealer_id SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    city      VARCHAR(100) NOT NULL,
    country   VARCHAR(50)  NOT NULL
);

-- Bestände pro Händler & Modell
CREATE TABLE car_stock
(
    dealer_id            INT NOT NULL REFERENCES dealership (dealer_id),
    model_id             INT NOT NULL REFERENCES model (model_id),
    quantity             INT NOT NULL,
    avg_discount_percent NUMERIC(5, 2), -- durchschnittlicher Rabatt in %
    PRIMARY KEY (dealer_id, model_id)
);

-- ============================================
-- BEISPIELDATEN
-- ============================================

-- Marken
INSERT INTO brand (name, country, group_name, founded_year)
VALUES ('Volkswagen', 'Germany', 'Volkswagen Group', 1937),
       ('Audi', 'Germany', 'Volkswagen Group', 1909),
       ('BMW', 'Germany', 'BMW Group', 1916),
       ('Mercedes-Benz', 'Germany', 'Mercedes-Benz Group', 1926),
       ('Toyota', 'Japan', 'Toyota Motor Corp.', 1937),
       ('Tesla', 'USA', 'Tesla Inc.', 2003),
       ('Ford', 'USA', 'Ford Motor Company', 1903);

-- Modelle
INSERT INTO model (brand_id, name, body_type, segment, launch_year, base_price_eur)
VALUES ((SELECT brand_id FROM brand WHERE name = 'Volkswagen'),
        'Golf', 'Hatchback', 'Compact', 1974, 23000),
       ((SELECT brand_id FROM brand WHERE name = 'Volkswagen'),
        'Tiguan', 'SUV', 'SUV', 2007, 34000),
       ((SELECT brand_id FROM brand WHERE name = 'Volkswagen'),
        'ID.3', 'Hatchback', 'Electric', 2019, 38000),

       ((SELECT brand_id FROM brand WHERE name = 'Audi'),
        'A3', 'Hatchback', 'Compact', 1996, 30000),
       ((SELECT brand_id FROM brand WHERE name = 'Audi'),
        'A4', 'Sedan', 'Mid-size', 1994, 38000),
       ((SELECT brand_id FROM brand WHERE name = 'Audi'),
        'Q5', 'SUV', 'SUV', 2008, 52000),

       ((SELECT brand_id FROM brand WHERE name = 'BMW'),
        '1 Series', 'Hatchback', 'Compact', 2004, 31000),
       ((SELECT brand_id FROM brand WHERE name = 'BMW'),
        '3 Series', 'Sedan', 'Mid-size', 1975, 42000),
       ((SELECT brand_id FROM brand WHERE name = 'BMW'),
        'X3', 'SUV', 'SUV', 2003, 50000),

       ((SELECT brand_id FROM brand WHERE name = 'Mercedes-Benz'),
        'A-Class', 'Hatchback', 'Compact', 1997, 32000),
       ((SELECT brand_id FROM brand WHERE name = 'Mercedes-Benz'),
        'C-Class', 'Sedan', 'Mid-size', 1993, 43000),

       ((SELECT brand_id FROM brand WHERE name = 'Toyota'),
        'Corolla', 'Sedan', 'Compact', 1966, 22000),
       ((SELECT brand_id FROM brand WHERE name = 'Toyota'),
        'RAV4', 'SUV', 'SUV', 1994, 32000),
       ((SELECT brand_id FROM brand WHERE name = 'Toyota'),
        'Prius', 'Hatchback', 'Hybrid', 1997, 28000),

       ((SELECT brand_id FROM brand WHERE name = 'Tesla'),
        'Model 3', 'Sedan', 'Electric', 2017, 45000),
       ((SELECT brand_id FROM brand WHERE name = 'Tesla'),
        'Model Y', 'SUV', 'Electric', 2020, 48000),

       ((SELECT brand_id FROM brand WHERE name = 'Ford'),
        'Focus', 'Hatchback', 'Compact', 1998, 21000),
       ((SELECT brand_id FROM brand WHERE name = 'Ford'),
        'Kuga', 'SUV', 'SUV', 2008, 32000);

-- Motoren
INSERT INTO engine (name, fuel_type, horsepower, displacement_l)
VALUES ('VW 1.5 TSI', 'Petrol', 150, 1.5),
       ('VW 2.0 TDI', 'Diesel', 150, 2.0),
       ('Audi 2.0 TFSI', 'Petrol', 190, 2.0),
       ('BMW 320d', 'Diesel', 190, 2.0),
       ('Toyota Hybrid 1.8', 'Hybrid', 122, 1.8),
       ('Tesla Dual Motor', 'Electric', 350, 0.0),
       ('Ford EcoBoost 1.0', 'Petrol', 125, 1.0);

-- Zuordnung Modelle <-> Motoren (vereinfachte Beispiele)
INSERT INTO model_engine (model_id, engine_id)
SELECT m.model_id, e.engine_id
FROM model m
         JOIN engine e ON
    (m.name = 'Golf' AND e.name IN ('VW 1.5 TSI', 'VW 2.0 TDI')) OR
    (m.name = 'Tiguan' AND e.name IN ('VW 2.0 TDI')) OR
    (m.name = 'ID.3' AND e.name IN ('Tesla Dual Motor')) OR
    (m.name = 'A3' AND e.name IN ('Audi 2.0 TFSI')) OR
    (m.name = 'A4' AND e.name IN ('Audi 2.0 TFSI')) OR
    (m.name = 'Q5' AND e.name IN ('Audi 2.0 TFSI', 'VW 2.0 TDI')) OR
    (m.name = '3 Series' AND e.name IN ('BMW 320d')) OR
    (m.name = 'Corolla' AND e.name IN ('Toyota Hybrid 1.8')) OR
    (m.name = 'Prius' AND e.name IN ('Toyota Hybrid 1.8')) OR
    (m.name = 'Model 3' AND e.name IN ('Tesla Dual Motor')) OR
    (m.name = 'Model Y' AND e.name IN ('Tesla Dual Motor')) OR
    (m.name = 'Focus' AND e.name IN ('Ford EcoBoost 1.0')) OR
    (m.name = 'Kuga' AND e.name IN ('Ford EcoBoost 1.0', 'Toyota Hybrid 1.8'));

-- Händler
INSERT INTO dealership (name, city, country)
VALUES ('Autohaus Müller', 'Berlin', 'Germany'),
       ('City Cars', 'Munich', 'Germany'),
       ('Electric Drive', 'Hamburg', 'Germany'),
       ('Sunrise Motors', 'Tokyo', 'Japan'),
       ('Highway Autos', 'Los Angeles', 'USA');

-- Bestände
INSERT INTO car_stock (dealer_id, model_id, quantity, avg_discount_percent)
VALUES ((SELECT dealer_id FROM dealership WHERE name = 'Autohaus Müller'),
        (SELECT model_id FROM model WHERE name = 'Golf'), 12, 5.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'Autohaus Müller'),
        (SELECT model_id FROM model WHERE name = 'Tiguan'), 5, 7.5),
       ((SELECT dealer_id FROM dealership WHERE name = 'Autohaus Müller'),
        (SELECT model_id FROM model WHERE name = 'ID.3'), 3, 4.0),

       ((SELECT dealer_id FROM dealership WHERE name = 'City Cars'),
        (SELECT model_id FROM model WHERE name = 'A3'), 6, 6.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'City Cars'),
        (SELECT model_id FROM model WHERE name = '3 Series'), 4, 8.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'City Cars'),
        (SELECT model_id FROM model WHERE name = 'C-Class'), 2, 10.0),

       ((SELECT dealer_id FROM dealership WHERE name = 'Electric Drive'),
        (SELECT model_id FROM model WHERE name = 'ID.3'), 4, 3.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'Electric Drive'),
        (SELECT model_id FROM model WHERE name = 'Model 3'), 7, 2.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'Electric Drive'),
        (SELECT model_id FROM model WHERE name = 'Model Y'), 5, 1.5),

       ((SELECT dealer_id FROM dealership WHERE name = 'Sunrise Motors'),
        (SELECT model_id FROM model WHERE name = 'Corolla'), 10, 5.0),
       ((SELECT dealer_id FROM dealership WHERE name = 'Sunrise Motors'),
        (SELECT model_id FROM model WHERE name = 'RAV4'), 6, 6.5),

       ((SELECT dealer_id FROM dealership WHERE name = 'Highway Autos'),
        (SELECT model_id FROM model WHERE name = 'Focus'), 8, 4.5),
       ((SELECT dealer_id FROM dealership WHERE name = 'Highway Autos'),
        (SELECT model_id FROM model WHERE name = 'Kuga'), 3, 7.0);


-- ============================================
-- AUFGABEN: Automarken-Datenbank (PostgreSQL)
-- Erlaubt: Grund-Aggregatfunktionen, CONCAT/||,
--          SELECT/INSERT/UPDATE/DELETE, JOIN,
--          GROUP BY, HAVING, ORDER BY, LIMIT, VIEWs
-- Verboten: CASE, FILTER, Subqueries
-- ============================================

-- --------------------------------------------
-- LEVEL 1 – Einfache SELECTs
-- --------------------------------------------

-- 1) Gib alle Marken aus.
--    Spalten: brand_id, name, country, group_name, founded_year.
--    Sortiere nach name aufsteigend.
SELECT name
FROM brand
ORDER BY name;

-- 2) Liste alle Modelle mit ihrer Marke.
--    Spalten: brand.name, model.name, segment, base_price_eur.
--    Sortiere zuerst nach brand.name, dann nach model.name.
SELECT brand.name, m.name, segment, base_price_eur
FROM brand
         INNER JOIN model m ON brand.brand_id = m.brand_id
ORDER BY brand.name, m.name;


-- 3) Gib alle Motoren aus.
--    Spalten: name, fuel_type, horsepower, displacement_l.
--    Sortiere nach horsepower absteigend.

SELECT name, fuel_type, horsepower, displacement_l
FROM engine
ORDER BY horsepower DESC;

-- 4) Zeige alle Händler mit Stadt und Land.
--    Verwende CONCAT oder ||, um eine Spalte "full_location"
--    im Format "city, country" auszugeben.
SELECT CONCAT(city, ', ', country) AS full_location
FROM dealership;



-- 5) Zeige alle Modelle, die im Segment 'SUV' sind.
--    Spalten: brand.name, model.name, launch_year, base_price_eur.
SELECT b.name, model.name, launch_year, base_price_eur
FROM model
         INNER JOIN brand b ON b.brand_id = model.brand_id
WHERE body_type ILIKE 'SUV';

-- --------------------------------------------
-- LEVEL 2 – Aggregatfunktionen & GROUP BY
-- --------------------------------------------

-- 6) Zähle, wie viele Marken pro Land existieren.
--    Spalten: country, brand_count.
SELECT country, COUNT(*)
FROM brand
GROUP BY country;


-- 7) Zähle, wie viele Modelle jede Marke hat.
--    Spalten: brand.name, model_count.
SELECT b.name, COUNT(*)
FROM model
         INNER JOIN brand b ON b.brand_id = model.brand_id
GROUP BY b.name;


-- 8) Berechne die durchschnittliche Basispreishöhe (base_price_eur)
--    pro Segment.
--    Spalten: segment, avg_base_price_eur.
SELECT segment, ROUND(AVG(base_price_eur)::NUMERIC, 2)
FROM model
GROUP BY segment;


-- 9) Gib die maximale und minimale Motorleistung (horsepower)
--    pro Kraftstoffart (fuel_type) aus.
--    Spalten: fuel_type, min_hp, max_hp.
SELECT fuel_type, MIN(horsepower), MAX(horsepower)
FROM engine
GROUP BY fuel_type;


-- 10) Ermittle die durchschnittliche Motorleistung je Marke.
--     Nutze die Tabellen brand, model, model_engine und engine.
--     Spalten: brand.name, avg_horsepower.
SELECT b.name, AVG(e.horsepower)
FROM model
         INNER JOIN model_engine me ON model.model_id = me.model_id
         INNER JOIN engine e ON e.engine_id = me.engine_id
         INNER JOIN brand b ON b.brand_id = model.brand_id
GROUP BY b.name;


-- 11) Zeige pro Händler die Gesamtanzahl an Fahrzeugen im Bestand.
--     Spalten: dealership.name, total_quantity.
SELECT d.name, SUM(quantity)
FROM car_stock
         INNER JOIN dealership d ON car_stock.dealer_id = d.dealer_id
GROUP BY d.name;

-- 12) Zeige pro Marke die Gesamtanzahl an Fahrzeugen im Bestand
--     über alle Händler.
--     Spalten: brand.name, total_quantity.
--     Hinweis: Nutze brand, model und car_stock.
SELECT brand.name, SUM(quantity)
FROM brand
         INNER JOIN model m ON brand.brand_id = m.brand_id
         INNER JOIN car_stock cs ON m.model_id = cs.model_id
GROUP BY brand.name;

-- --------------------------------------------
-- LEVEL 3 – HAVING, ORDER BY, CONCAT
-- --------------------------------------------

-- 13) Zeige pro Segment die Anzahl der Modelle und die durchschnittliche
--     Basispreishöhe.
--     Spalten: segment, model_count, avg_price.
--     Sortiere nach avg_price absteigend.
SELECT segment, ROUND(AVG(base_price_eur)::NUMERIC, 2) avg_price
FROM model
         INNER JOIN car_stock cs ON model.model_id = cs.model_id
GROUP BY segment
ORDER BY avg_price DESC;

-- 14) Zeige alle Segmente, in denen es mehr als 3 Modelle gibt.
--     Spalten: segment, model_count.
--     Nutze GROUP BY und HAVING (keine Subquery).
SELECT segment, COUNT(*)
FROM model
GROUP BY segment
HAVING COUNT(*) > 3;

-- 15) Zeige eine Liste aller verfügbaren Modellnamen inkl. Marke
--     in einer Spalte "full_model_name".
--     Format: "BrandName ModelName".
--     Sortiere alphabetisch nach full_model_name.
SELECT CONCAT(brand.name, ' ', m.name) AS full_model_name
FROM brand
         INNER JOIN model m ON brand.brand_id = m.brand_id
         INNER JOIN car_stock cs ON m.model_id = cs.model_id
ORDER BY full_model_name;



-- 16) Zeige pro Kraftstoffart (fuel_type) die Anzahl der verschiedenen
--     Motoren und die durchschnittliche Leistung.
--     Spalten: fuel_type, engine_count, avg_hp.

SELECT fuel_type, COUNT(*) engine_count, AVG(horsepower) avg_hp
FROM engine
GROUP BY fuel_type;

-- --------------------------------------------
-- LEVEL 4 – Views erstellen
-- --------------------------------------------

-- 17) Erstelle eine View v_model_details:
--     Enthalten sein sollen:
--       - brand_id
--       - brand_name
--       - model_id
--       - model_name
--       - segment
--       - base_price_eur
--     Nutze einen JOIN zwischen brand und model.

CREATE VIEW v_model_details AS
SELECT brand.brand_id, brand.name brand_name, m.model_id, m.name model_name, m.segment, m.base_price_eur
FROM brand
         INNER JOIN model m ON brand.brand_id = m.brand_id;


-- 18) Erstelle eine View v_engine_stats:
--     Pro Kraftstoffart:
--       - fuel_type
--       - engine_count (Anzahl Motoren)
--       - min_hp
--       - max_hp
--       - avg_hp
--     Nutze engine und Aggregatfunktionen, aber keine Subqueries.
CREATE VIEW v_engine_stats AS
SELECT fuel_type, COUNT(*) engine_count, MIN(horsepower) min_hp, MAX(horsepower) max_hp, AVG(horsepower) avg_hp
FROM engine
GROUP BY fuel_type;


-- 19) Erstelle eine View v_dealer_stock:
--     Enthalten sein sollen:
--       - dealer_id
--       - dealer_name
--       - city
--       - brand_name
--       - model_name
--       - segment
--       - quantity
--       - avg_discount_percent
--     Nutze dealership, car_stock, model, brand.
create view v_dealer_stock as
select dealership.dealer_id dealer_id,
       dealership.name      dealer_name,
       city,
       b.name               brand_name,
       m.name               model_name,
       segment,
       quantity,
       avg_discount_percent
from dealership
         inner join car_stock cs on dealership.dealer_id = cs.dealer_id
         inner join model m on m.model_id = cs.model_id
         inner join brand b on b.brand_id = m.brand_id;

-- 20) Erstelle eine View v_brand_model_counts:
--     Pro Marke:
--       - brand_id
--       - brand_name
--       - model_count
--     Nutze Aggregatfunktionen über die Tabelle model.
select brand.brand_id, brand.name, count(m)
from brand
         inner join model m on brand.brand_id = m.brand_id
group by brand.brand_id, brand.name
order by brand_id;

-- --------------------------------------------
-- LEVEL 5 – Views auf Views
-- --------------------------------------------

-- 21) Erstelle eine View v_expensive_brands:
--     Basis: v_brand_model_counts + v_model_details.
--     Ziel: Zeige pro Marke:
--       - brand_id
--       - brand_name
--       - model_count
--       - avg_base_price_eur (durchschnittlicher Basispreis
--         über alle Modelle der Marke)
--     Hinweis: Du kannst für avg_base_price_eur eine
--     Aggregation auf v_model_details verwenden.

-- 22) Erstelle eine View v_suv_stock:
--     Basis: v_dealer_stock.
--     Enthalten sein sollen nur die Zeilen, bei denen segment = 'SUV' ist.

-- 23) Erstelle eine View v_electric_overview:
--     Basis: v_dealer_stock.
--     Enthalten sein sollen nur Modelle, deren segment = 'Electric'
--     ODER deren Marke 'Tesla' ist.
--     (Hinweis: logisch mit OR verknüpfen, keine Subqueries.)

-- 24) Schreibe eine SELECT-Abfrage auf v_expensive_brands,
--     die alle Marken ausgibt, sortiert nach avg_base_price_eur
--     absteigend, und nur die ersten 5 Zeilen anzeigt.
--     (Nutze ORDER BY und LIMIT.)

-- 25) Schreibe eine SELECT-Abfrage auf v_suv_stock,
--     die pro Händler die Gesamtanzahl an SUVs im Bestand ausgibt.
--     Spalten: dealer_name, total_suv_quantity.


-- ============================================
-- EXTRA: DDL-Aufgaben zu Usern & Rollen (PostgreSQL)
-- ============================================

-- Die folgenden Aufgaben beziehen sich auf PostgreSQL-Rollen.
-- HINWEIS:
--   - In PostgreSQL sind "USER" und "ROLE" technisch dasselbe.
--   - Zum Kontrollieren kannst du später u. a. folgende Tabellen/Views nutzen:
--       * pg_roles
--       * pg_auth_members
select * from pg_roles where rolname not like 'pg_%';
select * from pg_auth_members;
--   - Beispiele für Kontrollabfragen (nicht Teil der Aufgaben):
--       SELECT rolname, rolsuper, rolcreatedb, rolcreaterole
--       FROM pg_roles
--       WHERE rolname LIKE 'car_%' OR rolname LIKE 'user_%';
--
--       SELECT
--         r.rolname AS role_name,
--         m.rolname AS member_name
--       FROM pg_auth_members am
--       JOIN pg_roles r ON am.roleid = r.oid
--       JOIN pg_roles m ON am.member = m.oid
--       WHERE r.rolname LIKE 'car_%';


-- 26) Lege drei neue Rollen an:
--     - car_readonly
--     - car_sales
--     - car_admin
--     Alle Rollen sollen sich mit LOGIN einloggen dürfen.
create role car_readonly;

-- 27) Lege zwei neue Benutzer an:
--     - user_alice
--     - user_bob
--     Weise beiden ein beliebiges Passwort zu.
--     (Für Übungen reicht ein einfaches Passwort.)
create role user_alice login password '1234_qwer!';


-- 28) Ordne die Rollen wie folgt zu (GRANT):
--     - car_readonly wird user_alice und user_bob zugewiesen.
--     - car_sales wird nur user_alice zugewiesen.
--     - car_admin wird nur user_bob zugewiesen.
grant car_readonly to user_alice;

SELECT rolname
FROM pg_roles
WHERE pg_has_role('user_alice', oid, 'member');
-- 29) Kaskadiere die Rollen:
--     - car_sales soll alle Rechte von car_readonly erben.
--     - car_admin soll alle Rechte von car_sales erben.

-- 30) Kontrolle:
--     Formuliere SELECT-Abfragen auf pg_roles und pg_auth_members,
--     mit denen du überprüfen kannst:
--       - Dass alle Rollen (car_readonly, car_sales, car_admin)
--         existieren.
--       - Dass beide Benutzer (user_alice, user_bob) existieren.
--       - Welche Rollen welchen Benutzern zugeordnet sind.
--       - Welche Rollen anderen Rollen zugeordnet sind (Rollen-Hierarchie).

CREATE SCHEMA besoldung;
GRANT USAGE ON SCHEMA besoldung TO r_refue_lesen; -- Berechtigung zum Zugriff aufs Schema,
-- REVOKE ALL ON SCHEMA besoldung FROM PUBLIC; -- alle anderen ausschließen
-- GRANT ALL PRIVILEGES ON SCHEMA besoldung TO r_fuehrung_vollzugriff; -- bekommt USAGE
und CREATE Rechte aufs Schema
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA besoldung TO r_fuehrung_vollzugriff; --
bekommt Zugriff auf alle Tabellen
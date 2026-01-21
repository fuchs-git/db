-- ============================================================================
-- STREAMVERSE – Übungsaufgaben (30 Stück)
-- Datenbank: streamverse
-- Format: Jede Aufgabe mit einer kurzen, realistischen Lösungsschätzung.
-- Keine SQL-Syntax in den Lösungen!
-- ============================================================================

-- 1) Aktive Abos
--    Liste alle Nutzer und ihren Abo-Plan (z.B. "Johannes Becker – Premium").
-- Lösung: ca. 80 Datensätze.
SELECT user_account.name, subscription_plan.name
FROM user_account
         inner join subscription on user_account.user_id = subscription.user_id
         inner join subscription_plan on subscription.plan_id = subscription_plan.plan_id;


-- 2) Nutzer je Land
--    Wie viele Nutzer kommen aus DE, AT, CH und NL?
-- Lösung: 4 Datensätze, jeweils ca. 15–25 Nutzer.
select country, count(*)
from user_account
group by country;

-- 3) Monatlicher Gesamtumsatz
--    Wie viel Geld wird pro Monat anhand aller aktiven Abos verdient?
-- Lösung: ca. 3 Datensätze, Gesamt ~900–1100 €.

select status, sp.name, SUM(monthly_price)
from user_account
         inner join public.subscription s on user_account.user_id = s.user_id
         inner join public.subscription_plan sp on sp.plan_id = s.plan_id
where status = 'active'
group by status, sp.name;

-- 4) Titelübersicht
--    Zeige, wie viele Filme und wie viele Serien StreamVerse anbietet.
-- Lösung: 150 Filme, 50 Serien.
select type, name
from title;


-- 5) Meistgesehener Film
--    Finde den Film mit der höchsten Gesamtsehzeit.
-- Lösung: 1 Titel, ca. 80.000–100.000 Minuten.
select name, SUM(minutes_watched) as zeit
from watch_event
         inner join title on title.title_id = watch_event.title_id
group by name
order by zeit desc
limit 1;


-- 6) Top-Streamer
--    Finde die Nutzer mit der längsten gesamten Streamingzeit.
-- Lösung: ca. 80 Datensätze, Top-Wert ca. 50.000–70.000 Minuten.
select name, SUM(minutes_watched) as zeit
from user_account
         inner join watch_event on user_account.user_id = watch_event.user_id
group by name
order by zeit desc;

-- 7) Titelvielfalt pro Nutzer
--    Für jeden Nutzer: Wie viele verschiedene Titel wurden angesehen?
-- Lösung: ca. 80 Datensätze, typischer Bereich 10–80 Titel.

select name, count(distinct watch_event.title_id) id
from user_account
         inner join watch_event on user_account.user_id = watch_event.user_id
group by name;

SELECT ua.name,
       COUNT(DISTINCT we.title_id) AS titel_vielfalt
FROM user_account ua
         LEFT JOIN watch_event we
                   ON ua.user_id = we.user_id
GROUP BY ua.name
ORDER BY titel_vielfalt DESC;

select user_account.name, watch_event.user_id, watch_event.title_id
from watch_event
         inner join user_account on watch_event.user_id = user_account.user_id
order by watch_event.user_id;

-- 8) Bewertungsübersicht
--    Durchschnittliche Sternebewertung und Anzahl der Bewertungen pro Titel.
-- Lösung: ca. 200 Datensätze, Ø 1.5–4.5 Sterne, 0–20 Bewertungen.
select title.name, avg(stars) as durchnitt, count(stars)
from rating
         inner join title on rating.title_id = title.title_id
group by title.name, stars
order by durchnitt desc;


-- 9) Bestbewertete Titel
--    Finde die Titel mit mindestens 10 Bewertungen und Ø ≥ 4.5.
-- Lösung: ca. 5–15 Titel.
select title.name, count(stars) as bewertung
from rating
         inner join title on rating.title_id = title.title_id
group by title.name, stars
having count(stars) > 5;

-- 10) Sehdauer nach Genre
--     Gesamtsehzeit pro Genre (Action, Sci-Fi, Horror …).
-- Lösung: ca. 7–8 Datensätze, Top-Genre ~200.000–300.000 Minuten.
select genre.name, SUM(watch_event.minutes_watched)
from genre
         inner join title_genre on genre.genre_id = title_genre.genre_id
         inner join title on title_genre.title_id = title.title_id
         inner join watch_event on title.title_id = watch_event.title_id
group by genre.name;

-- 11) Durchschnittlicher Watch-Event
--     Durchschnittliche Minuten pro Watch-Event.
-- Lösung: ~3000 Events, Schnitt ca. 50–70 Minuten.

-- 12) Serien-Watch-Events
--     Alle Watch-Events von Serien inkl. Episodenname.
-- Lösung: ca. 1000–1500 Datensätze.

-- 13) Nutzer ohne Watch-Events
-- Lösung: ca. 0–5 Nutzer.

-- 14) Titel ohne Watch-Events
-- Lösung: ca. 0–10 Titel.

-- 15) Nutzung nach Gerät
--     Gesamtsehzeit pro Gerätetyp (TV, Mobile, Tablet, PC).
-- Lösung: 4 Datensätze, TV meist am höchsten (~800.000–900.000 Minuten).

-- 16) View v_user_watch_stats
--     Enthält Gesamtminuten + Anzahl gesehener Titel pro Nutzer.
-- Lösung: ~80 Zeilen in der View.

-- 17) Power-User (> 5000 Minuten)
--     Zeige alle Nutzer mit über 5000 Minuten Gesamtsehzeit.
-- Lösung: ca. 30–50 Nutzer.

-- 18) View v_title_ratings
--     Enthält Ø Sterne + Anzahl der Bewertungen pro Titel.
-- Lösung: ~200 Zeilen in der View.

-- 19) Sehr gut bewertete Titel
--     Titel mit Ø >= 4.5 und >= 10 Bewertungen.
-- Lösung: ca. 5–15 Titel.

-- 20) View v_genre_watchtime
--     Enthält die Gesamtsehzeit pro Genre.
-- Lösung: ca. 7–8 Zeilen.

-- 21) Beliebteste Genres sortiert
--     Sortiere die Genres nach Gesamtsehzeit absteigend.
-- Lösung: gleiche Zeilen wie Aufgabe 20, sortiert.

-- 22) Serienranking
--     Gesamtsehzeit pro Serie.
-- Lösung: ca. 50 Datensätze, Top-Serie ~100.000–130.000 Minuten.

-- 23) Binge-Watcher
--     Nutzer mit einem Ø Watch-Event von über 90 Minuten.
-- Lösung: ca. 5–15 Nutzer.

-- 24) Peak-Streaming-Tag
--     Finde den Tag mit der höchsten gesamten Streamingzeit.
-- Lösung: 1 Datum, ca. 20.000–25.000 Minuten.

-- 25) Erstes gesehenes Video pro Nutzer
--     (z. B. "Lena Fischer sah zuerst ‚Silent Echo (2000)‘").
-- Lösung: ca. 80 Datensätze.

-- 26) Nutzer–Genre-Matrix
--     Zeige pro Nutzer die Gesamtsehzeit pro Genre.
-- Lösung: ca. 300–500 Datensätze.

-- 27) Neues Rating anlegen
--     Nutzer bewertet einen Titel (z.B. 5 Sterne).
-- Lösung: 1 neuer Datensatz.

-- 28) Rating ändern
--     Aktualisiere eine bestehende Bewertung eines Nutzers.
-- Lösung: 1 Datensatz wird angepasst.

-- 29) View v_active_subscriptions
--     Übersicht über alle aktiven Abos.
-- Lösung: ca. 80 Datensätze.

-- 30) Premium-Nutzer aus Deutschland
--     Finde alle deutschen Nutzer mit Premium-Abo.
-- Lösung: ca. 5–15 Nutzer.

-- ============================================================================
-- Ende der Aufgaben
-- ============================================================================


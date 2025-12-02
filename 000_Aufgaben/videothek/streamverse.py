import psycopg
from datetime import date, timedelta


class Datenbank:
    def __init__(self, password: str, setup: bool = False):
        self.root_cfg = dict(
            user="postgres",
            password=password,
            dbname="postgres",
            host="localhost",
            port=5432,
            autocommit=True,
        )

        self.db_cfg = dict(
            user="postgres",
            password=password,
            dbname="streamverse",
            host="localhost",
            port=5432,
            autocommit=True,
        )

        if setup:
            self.create_db()
            self.create_schema()
            self.insert_data()
            self.create_aufgaben_sql()

    # =====================================================================
    # Hilfsfunktionen
    # =====================================================================
    @staticmethod
    def deterministic_date(idx: int, start: date, span: int) -> date:
        """Ein deterministisches Datum für reproduzierbare Daten."""
        return start + timedelta(days=(idx % span))

    # =====================================================================
    # DB erzeugen
    # =====================================================================
    def create_db(self) -> None:
        with psycopg.connect(**self.root_cfg) as conn:
            with conn.cursor() as cur:
                cur.execute("DROP DATABASE IF EXISTS streamverse")
                cur.execute("CREATE DATABASE streamverse")
        print("[OK] Database streamverse created.")

    # =====================================================================
    # SCHEMA
    # =====================================================================
    def create_schema(self) -> None:
        schema = """
        CREATE TABLE user_account (
            user_id      SERIAL PRIMARY KEY,
            name         TEXT NOT NULL,
            email        TEXT UNIQUE,
            country      TEXT,
            signup_date  DATE NOT NULL
        );

        CREATE TABLE subscription_plan (
            plan_id        SERIAL PRIMARY KEY,
            name           TEXT NOT NULL,
            monthly_price  NUMERIC(6,2) NOT NULL,
            resolution     TEXT,
            max_screens    INT
        );

        CREATE TABLE subscription (
            subscription_id SERIAL PRIMARY KEY,
            user_id         INT REFERENCES user_account(user_id),
            plan_id         INT REFERENCES subscription_plan(plan_id),
            start_date      DATE NOT NULL,
            status          TEXT NOT NULL
        );

        CREATE TABLE genre (
            genre_id  SERIAL PRIMARY KEY,
            name      TEXT NOT NULL
        );

        CREATE TABLE title (
            title_id     SERIAL PRIMARY KEY,
            name         TEXT NOT NULL,
            release_year INT,
            type         TEXT CHECK (type IN ('movie','series')),
            age_rating   TEXT
        );

        CREATE TABLE title_genre (
            title_id  INT REFERENCES title(title_id),
            genre_id  INT REFERENCES genre(genre_id),
            PRIMARY KEY (title_id, genre_id)
        );

        CREATE TABLE episode (
            episode_id   SERIAL PRIMARY KEY,
            title_id     INT REFERENCES title(title_id),
            season_nr    INT,
            episode_nr   INT,
            name         TEXT NOT NULL,
            duration_min INT NOT NULL
        );

        CREATE TABLE watch_event (
            event_id        SERIAL PRIMARY KEY,
            user_id         INT REFERENCES user_account(user_id),
            title_id        INT REFERENCES title(title_id),
            episode_id      INT REFERENCES episode(episode_id),
            watch_date      DATE NOT NULL,
            minutes_watched INT NOT NULL,
            device          TEXT
        );

        CREATE TABLE rating (
            rating_id   SERIAL PRIMARY KEY,
            user_id     INT REFERENCES user_account(user_id),
            title_id    INT REFERENCES title(title_id),
            stars       INT CHECK (stars BETWEEN 1 AND 5),
            rating_date DATE NOT NULL
        );
        """
        with psycopg.connect(**self.db_cfg) as conn:
            with conn.cursor() as cur:
                cur.execute(schema)
        print("[OK] Schema created.")

    # =====================================================================
    # DATEN
    # =====================================================================
    def insert_data(self) -> None:
        # 80 realistische Namen algorithmisch erzeugen (garantiert 80)
        first_names = [
            "Johannes", "Lena", "Tobias", "Mia", "Daniel",
            "Julia", "Niklas", "Sarah", "Benjamin", "Laura",
            "Patrick", "Hannah", "Simon", "Nina", "Fabian",
            "Clara", "Marvin", "Paula", "Jonas", "Franziska",
        ]
        last_names = [
            "Becker", "Fischer", "Schneider", "Hoffmann", "Weber",
            "Schulz", "Zimmermann", "Bauer", "Koch", "Schäfer",
            "Richter", "König", "Wolf", "Hartmann", "Krämer",
            "Stein", "Sommer", "Frank", "Schulze", "Arnold",
        ]
        user_names: list[str] = []
        for i in range(80):
            fn = first_names[i % len(first_names)]
            ln = last_names[(i // len(first_names)) % len(last_names)]
            user_names.append(f"{fn} {ln}")
        assert len(user_names) == 80  # Sicherheitscheck

        # 150 Filme generieren: Adjektiv + Nomen + Jahr
        adjectives = [
            "Silent", "Broken", "Crimson", "Neon", "Hidden",
            "Last", "Lost", "Midnight", "Frozen", "Black",
            "Silver", "Golden", "Final", "Urban", "Distant",
            "Bleak", "Rising", "Fading", "Hollow", "Burning",
            "Endless", "Forgotten", "Cold", "Fragile", "Shattered",
        ]
        nouns = [
            "Echo", "Horizon", "Dreams", "Empire", "Forest",
            "Circle", "Station", "Voices", "Memories", "Lines",
            "Waves", "Shadows", "Oath", "Sky", "Pulse",
            "Origin", "Strain", "Ashes", "Boundary", "Signal",
        ]

        films: list[str] = []
        for i in range(150):
            adj = adjectives[i % len(adjectives)]
            noun = nouns[(i // len(adjectives)) % len(nouns)]
            year = 2000 + (i % 22)
            films.append(f"{adj} {noun} ({year})")

        # 50 Serien
        series_base = [
            "Edge of Reality", "Nordic Nights", "Deep Horizon",
            "The Silent Code", "Winterfront", "Echoes of Berlin",
            "Mindbreaker Unit", "Europa Station", "Broken City Files",
            "Forgotten Signals",
        ]
        series: list[str] = []
        for i in range(50):
            base = series_base[i % len(series_base)]
            season = (i % 5) + 1
            series.append(f"{base} – Staffel {season}")

        titles: list[tuple[str, str]] = [(name, "movie") for name in films] + [
            (name, "series") for name in series
        ]
        assert len(titles) == 200

        genres = ["Action", "Drama", "Sci-Fi", "Comedy", "Thriller", "Fantasy", "Horror"]
        devices = ["TV", "Mobile", "Tablet", "PC"]
        age_ratings = ["0", "6", "12", "16", "18"]

        with psycopg.connect(**self.db_cfg) as conn:
            with conn.cursor() as cur:
                # --------------------------------------------------------
                # Abo-Pläne
                # --------------------------------------------------------
                plans = [
                    ("Basic", 7.99, "HD", 1),
                    ("Standard", 12.99, "Full HD", 2),
                    ("Premium", 17.99, "4K", 4),
                ]
                for p in plans:
                    cur.execute(
                        """
                        INSERT INTO subscription_plan (name,monthly_price,resolution,max_screens)
                        VALUES (%s,%s,%s,%s)
                        """,
                        p,
                    )

                # --------------------------------------------------------
                # Genres
                # --------------------------------------------------------
                for g in genres:
                    cur.execute("INSERT INTO genre (name) VALUES (%s)", (g,))

                # --------------------------------------------------------
                # Nutzer (80)
                # --------------------------------------------------------
                base_signup = date(2021, 1, 1)
                for i, uname in enumerate(user_names, start=1):
                    email = f"user{i}@streamverse.local"
                    country = ["DE", "AT", "CH", "NL"][i % 4]
                    signup = self.deterministic_date(i, base_signup, 365)
                    cur.execute(
                        """
                        INSERT INTO user_account (name,email,country,signup_date)
                        VALUES (%s,%s,%s,%s)
                        """,
                        (uname, email, country, signup),
                    )

                # --------------------------------------------------------
                # Subscriptions (1 pro Nutzer)
                # --------------------------------------------------------
                for user_id in range(1, 81):
                    plan_id = (user_id % 3) + 1
                    startd = self.deterministic_date(user_id, date(2021, 2, 1), 365)
                    cur.execute(
                        """
                        INSERT INTO subscription (user_id,plan_id,start_date,status)
                        VALUES (%s,%s,%s,'active')
                        """,
                        (user_id, plan_id, startd),
                    )

                # --------------------------------------------------------
                # Titel (200)
                # --------------------------------------------------------
                for i, (tname, ttype) in enumerate(titles, start=1):
                    year = 2000 + (i % 20)
                    ar = age_ratings[i % len(age_ratings)]
                    cur.execute(
                        """
                        INSERT INTO title (name,release_year,type,age_rating)
                        VALUES (%s,%s,%s,%s)
                        """,
                        (tname, year, ttype, ar),
                    )

                # --------------------------------------------------------
                # Genre-Zuordnung (mind. 1 Genre pro Titel)
                # --------------------------------------------------------
                for tid in range(1, 201):
                    g1 = (tid % len(genres)) + 1
                    cur.execute(
                        "INSERT INTO title_genre (title_id,genre_id) VALUES (%s,%s)",
                        (tid, g1),
                    )

                # --------------------------------------------------------
                # Episoden für Serien (Titel-ID 151–200)
                # --------------------------------------------------------
                for tid in range(151, 201):
                    for season in range(1, 4):
                        for ep in range(1, 6):
                            ep_name = f"S{season:02d}E{ep:02d}"
                            dur = 22 + (ep % 10)
                            cur.execute(
                                """
                                INSERT INTO episode (title_id,season_nr,episode_nr,name,duration_min)
                                VALUES (%s,%s,%s,%s,%s)
                                """,
                                (tid, season, ep, ep_name, dur),
                            )

                # --------------------------------------------------------
                # Watch Events (3000)
                # --------------------------------------------------------
                base_watch = date(2022, 1, 1)
                for e in range(1, 3001):
                    user_id = ((e - 1) % 80) + 1
                    title_id = ((e * 7) % 200) + 1
                    watch_date = self.deterministic_date(e, base_watch, 700)
                    minutes = 10 + (e % 90)
                    device = devices[e % len(devices)]

                    # Für Serien: Episode optional referenzieren
                    episode_id = None
                    if title_id >= 151:
                        # Reihenfolge der Episoden: 15 pro Serie, in Einfüge-Reihenfolge
                        series_index = title_id - 151  # 0..49
                        ep_offset = e % 15  # 0..14
                        episode_id = series_index * 15 + ep_offset + 1

                    cur.execute(
                        """
                        INSERT INTO watch_event (
                            user_id,title_id,episode_id,watch_date,minutes_watched,device
                        )
                        VALUES (%s,%s,%s,%s,%s,%s)
                        """,
                        (user_id, title_id, episode_id, watch_date, minutes, device),
                    )

                # --------------------------------------------------------
                # Ratings (1000)
                # --------------------------------------------------------
                base_rate = date(2022, 6, 1)
                for r in range(1, 1001):
                    user_id = ((r * 5) % 80) + 1
                    title_id = ((r * 11) % 200) + 1
                    stars = (r % 5) + 1
                    rating_date = self.deterministic_date(r, base_rate, 365)
                    cur.execute(
                        """
                        INSERT INTO rating (user_id,title_id,stars,rating_date)
                        VALUES (%s,%s,%s,%s)
                        """,
                        (user_id, title_id, stars, rating_date),
                    )

        print("[OK] All data inserted successfully.")

    # =====================================================================
    # Aufgaben-SQL erzeugen
    # =====================================================================
    def create_aufgaben_sql(self) -> None:
        text = """-- ============================================================================
-- STREAMVERSE – Übungsaufgaben (30 Stück)
-- Datenbank: streamverse
-- ============================================================================

-- 1) Aktive Abos
--    Liste alle Nutzer und ihren Abo-Plan (z.B. "Johannes Becker – Premium").
-- Lösung: ca. 80 Datensätze.

-- 2) Nutzer je Land
--    Wie viele Nutzer kommen aus DE, AT, CH und NL?
-- Lösung: 4 Datensätze, jeweils ca. 15–25 Nutzer.

-- 3) Monatlicher Gesamtumsatz
--    Wie viel Geld wird pro Monat anhand aller aktiven Abos verdient?
-- Lösung: ca. 3 Datensätze, Gesamt ~900–1100 €.

-- 4) Titelübersicht
--    Zeige, wie viele Filme und wie viele Serien StreamVerse anbietet.
-- Lösung: 150 Filme, 50 Serien.

-- 5) Meistgesehener Film
--    Finde den Film mit der höchsten Gesamtsehzeit.
-- Lösung: 1 Titel, ca. 80.000–100.000 Minuten.

-- 6) Top-Streamer
--    Finde die Nutzer mit der längsten gesamten Streamingzeit.
-- Lösung: ca. 80 Datensätze, Top-Wert ca. 50.000–70.000 Minuten.

-- 7) Titelvielfalt pro Nutzer
--    Für jeden Nutzer: Wie viele verschiedene Titel wurden angesehen?
-- Lösung: ca. 80 Datensätze, typischer Bereich 10–80 Titel.

-- 8) Bewertungsübersicht
--    Durchschnittliche Sternebewertung und Anzahl der Bewertungen pro Titel.
-- Lösung: ca. 200 Datensätze, Ø 1.5–4.5 Sterne, 0–20 Bewertungen.

-- 9) Bestbewertete Titel
--    Finde die Titel mit mindestens 10 Bewertungen und Ø ≥ 4.5.
-- Lösung: ca. 5–15 Titel.

-- 10) Sehdauer nach Genre
--     Gesamtsehzeit pro Genre (Action, Sci-Fi, Horror …).
-- Lösung: ca. 7–8 Datensätze, Top-Genre ~200.000–300.000 Minuten.

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
"""
        with open("aufgaben.sql", "w", encoding="utf-8") as f:
            f.write(text)
        print("[OK] Aufgaben-Datei 'aufgaben.sql' erstellt.")


if __name__ == "__main__":
    Datenbank(password="password", setup=True)

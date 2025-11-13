CREATE DATABASE db_bestellsystem TEMPLATE template0;

DROP TABLE IF EXISTS adresse,kunde,produkt,bestellung,umfasst CASCADE;
-- TRUNCATE TABLE adresse,kunde,produkt,bestellung,umfasst CASCADE;

CREATE TABLE adresse (
    adresse_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    strasse    TEXT NOT NULL,
    hausnummer TEXT DEFAULT '',
    plz        TEXT NOT NULL,
    ort        TEXT NOT NULL
);

CREATE TABLE kunde (
    kunde_id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                TEXT    NOT NULL,
    email               TEXT    NOT NULL UNIQUE,
    fk_rechnungsadresse INTEGER NOT NULL REFERENCES adresse (adresse_id)
);

CREATE TABLE produkt (
    produkt_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bezeichnung  TEXT           NOT NULL CHECK ( LENGTH(bezeichnung) <= 100 ),
    beschreibung TEXT           NOT NULL,
    preis        DECIMAL(10, 2) NOT NULL CHECK ( preis > 0 )
);

CREATE TABLE bestellung (
    bestellung_id    INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    fk_kunde_id      INTEGER NOT NULL REFERENCES kunde (kunde_id),
    fk_lieferadresse INTEGER NOT NULL REFERENCES adresse (adresse_id),
    bestelldatum     DATE    NOT NULL DEFAULT CURRENT_DATE,
    versanddatum     DATE CHECK ( bestelldatum <= versanddatum )
);

CREATE TABLE umfasst (
    fk_bestellung_id INTEGER REFERENCES bestellung (bestellung_id),
    fk_produkt_id    INTEGER REFERENCES produkt (produkt_id),
    anzahl           INTEGER CHECK ( anzahl > 0 ),
    PRIMARY KEY (fk_bestellung_id, fk_produkt_id)
);

INSERT INTO adresse(strasse, hausnummer, plz, ort)
VALUES ('Candlewood Drive', '96', 'NS B3E 1H5', 'Porters Lake'),
       ('Whisper Ridge', '112', 'NS B3E 1J6', 'Porters Lake'),
       ('Old Coach Road', '11', 'NS B3E 1M2', 'Porters Lake'),
       ('This Street', '2', 'NS B3E 1H4', 'Porters Lake'),
       ('This Street', '12', 'NS B3E 1H4', 'Porters Lake'),
       ('That Street', '52', 'NS B3E 1H3', 'Porters Lake'),
       ('That Street', '47', 'NS B3E 1H3', 'Porters Lake'),
       ('The Other Street', '31', 'NS B3E 1H4', 'Porters Lake'),
       ('Post Office Road', '118', 'NS B3E 1H7', 'Porters Lake'),
       ('Narrows Lane', '5', 'NS B3E 1K1', 'Porters Lake'),
       ('Karen Crescent', '35', 'NS B3E 1K3', 'Porters Lake'),
       ('Silver Cove Lane', '78', 'NS B3E 1J6', 'Porters Lake');

INSERT INTO kunde(name, email, fk_rechnungsadresse)
VALUES ('Sunset Marine Ltd.', 'sunset@marine.ca',
        (SELECT adresse_id FROM adresse WHERE strasse = 'Post Office Road' AND hausnummer = '118')),
       ('Buttercream Dream', 'butter@cream.ca',
        (SELECT adresse_id FROM adresse WHERE strasse = 'Candlewood Drive' AND hausnummer = '96')),
       ('Ketchup Chips Museum', 'ketchup-chips@museum.ca',
        (SELECT adresse_id FROM adresse WHERE strasse = 'That Street' AND hausnummer = '47')),
       ('This School', 'this@school.ca',
        (SELECT adresse_id FROM adresse WHERE strasse = 'This Street' AND hausnummer = '12')),
       ('Narrows 9 Dragons', 'sarah@lifemaps.cc',
        (SELECT adresse_id FROM adresse WHERE strasse = 'Narrows Lane' AND hausnummer = '5'));

INSERT INTO produkt(bezeichnung, beschreibung, preis)
VALUES ('BlueBlue Optimist', e'- So gut wie der neue Regatta-Optimist\n
- Gebaut von Blue Blue\n
- Nur während der Optimist WM 2021 in Italien gesegelt\n
- Erhältlich ab der zweiten Julihälfte\n
\n
Kompletter Rumpf mit\n
- Harken 57mm Ratschenblock\n
- Harken 40 mm Carboblock\n
- Drei Auftriebstaschen\n
- Konisches Hauptblatt\n
- Maler-Linie\n
- Mastschloss\n
- 2 x Bailer\n
- Praddle\n
\n
Ruder/DaggerBoard Set\n
- Optiparts Daggerboard\n
- Optiparts Ruder\n
- Optiparts Pinne und Joystick aus Aluminium\n
Optimax Mastset\n
- MK3-Mast\n
- MK4-Ausleger - 45mm\n
- MK3-Sprit - 27 mm\n

Extras\n
- Optiparts Trolley\n
- Gorilla Sailing Top Cover\n
- Ruder/DaggerBoard Combo-Tasche\n

Optionale Segel:\n
- Neu J-Sail €395, - inkl. Segelnummer\n
- New One Segel €450, - inkl. Segelnummer\n
- New Olimpic Sail €365, - inkl. Segelnummer\n
- Neues Opimax Racing Sail €330, - inkl. Segelnummer', 2750),
       ('Jolle Mariner 19', e'Zustand: neu, Antrieb: Außenborder, Steuerung: Pinne, Masthöhe: 7,30 m, Segelfläche: 15,80 m²\n
Ausstattung:
Reffvorrichtung\n
\n
Das ideale Schiff für Schulen, Clubs und Privatleute.\n
Bis zu 6 Pers.! Sehr kippstabil im Wasser, auch mit Performance Rig zu haben!\n
\n
Folgende Ausstattung ist im standardmäßigen Lieferumfang enthalten:\n
- Rumpf und Deck in Sandwichbauweise mit Antirutschstruktur in weiß\n
- Mast und Baum\n
- Genuaschot und Großschot, sowie Beschläge\n
- Ruder\n
- Schwenkkiel', 9490),
       ('Williams Turbojet 385', e'Planen & Persinnige\n
Abdeckplane\n
2016 Williams Turbojet 385 - perfekter Zustand, fast wie neu ! Nur 68 Maschinenstunden !', 16900),
       ('Seaflo Kajak inkl. Paddel, Angelboot, Kanu, Kayak, 1004 blau', e'Features Kajak: Verstellbare Fußstützen, Tragegriffe vorne und Hinten, Bequemer Sitz mit verstellbarer und gepolsterter Rückenlehne, Flaschenhalter, Spritzwasser geschützte Tagesluke, Gepäckspinne vorne, Gepäckspinne hinten, Ablassschraube, Vorbereitet für Angelrutenhalter (nicht im Lieferumfang)\n
Technische Daten: Länge: 305cm, Breite: 71cm, Gewicht: 18Kg, Zuladung: 125 Kg, Material: HDPE\n
Technische Daten Paddel: Länge: 220 cm, Gewicht: 953 Gramm, Schaft Durchmesser: 28 mm, Blattgröße: 52,3cm x 17cm', 469),
       ('Faber-Castell 110091 Farbstifte Polychromos 120er Metalletui und Bleistifte 9000 12er Metalletui', e'Info zu diesem Artikel\n
Vorteilspaket aus 120 Farbstiften und 12 Bleistiften\n
unübertroffene Lichtbeständigkeit und Farbbrillanz, wisch- und wasserfest\n
dicke Ölkreidemine mit weichem farbsattem Abstrich und hochwertigen Pigmenten\n
Bleistifte in 8 Härtegraden: 8B, 7B, 6B, 5B, 4B, 3B, 2B, B, F, HB, H und 2H\n
für sorgfältige und feine Detailzeichnungen, sowie grafische Arbeiten', 176),
       ('Sächsisches Uran und Stalins Kernwaffen Broschiert – 29. September',
        'Dem Autor ist, dank akribischer Recherche, ein umfangreiches populärwissenschaftliches Buch zum Thema Radioaktivität im Geflecht von Wissenschaft und Politik gelungen. Er beschreibt die Ahnungslosigkeit im Umgang mit radioaktiven Stoffen, als diese in ihrer Wirksamkeit noch nicht vollständig erforscht waren. Später dann, als Wissen vorhanden war, die Nachlässigkeit, mit der jahrelang Raubbau an der Natur und dem Menschen begangen wurde und nicht zuletzt die Atomkraft, die in Zeiten des kalten Krieges zur Abschreckung dienen sollte und vordem, den Einsatz der Atombombe in Japan und ihre schreckliche Auswirkung. Ihm ist damit ein umfassendes Werk gelungen, welches nicht nur äußerst interessant zu lesen ist sondern auch teilweise verloren gegangenes Wissen auffrischt und zudem vertieft. Dieses Buch könnte bedenkenlos im Lehrbereich eingesetzt werden, zeigt es doch nicht nur wichtige geschichtliche Ereignisse und ihre Daten auf auch der besonnene Umgang mit diesen Materialien, für eine unbeschwerte Zukunft unserer Kinder und Kindeskinder, wird dem Leser nachhaltig ans Herz gelegt.',
        16),
       ('Das Uran von Menzenschwand Gebundene Ausgabe – 30. Oktober 2011',
        'Eine einzigartige Dokumentation über ein Geheimprojekt! Dass gerade dieses so romantisch anmutende Dorf Schauplatz eines Jahrzehnte währenden Streits um Uran war, ist heutzutage nahezu unvorstellbar... und doch: hier wurden 100.000t Uranerz gefördert. Dies aber nur am Rande... den Hauptteil des Buches bilden die Mineralien, ihre Entstehung und vor allem die hervorragenden Farbfotos von Stephan Wolfsried, der zu den besten Mineralienfotografen Deutschlands zählt. Professor Gregor Markl ist sowohl durch seine zahlreichen Werke bekannt, als auch als besonders engagierter Mineraliensammler mit dem Spezialgebiet Schwarzwald.',
        53.95),
       ('Heckler und Koch Softair Maschinengewehr G36 C Federdruck - von Umarex', e'Kaliber 6mm, < 0,5 Joule\n
inkl. 40 Schuss Mazin\n
ab 14 Jahren', 59.99),
       ('Massa Ticino Carma Tropic Rollfondant, 1er Pack (1 x 7 kg)', e'Info zu diesem Artikel\n
gebrauchsfertiger weißer Fondant / White Icing im 7kg Kübel\nMTT ist leicht zu kneten, sehr dünn auszurollen, zu schneiden und zu formen / modellieren\nsehr elastisch – elastischer und flexibler als Marzipan und die meisten anderen Einschlagmassen\n
nicht zu süß, mit leichtem Vanillearoma - kein Essigaroma wie bei anderen Produkten\ndie ideale Zusammensetzung und der gute Geschmack garantieren großartige Ergebnisse',
        59.90),
       ('ARKMODEL 1:48 Deutschland U31 212A TYP AIP U-Boot Kit Zusammengebaute Plastikmodelle', e'Info zu diesem Artikel\n
Arkmodel 1:48 U31 (Typ 212A) Aip-U-Boot [C7615K] Schiffseinführung: Artikel: C7615K Maßstab: 1/48 ARTR Größe / Gewicht: 1165x145mm / 16500g (ARTR Box) Kit Größe / Gewicht: 990x310x180 / 13800g (Kit-Box)\n
212A Kit Einführung: Dies ist ein HOCHWERTIGES Modellbausatz. Entworfen durch detaillierte Zeichnung und Ressource. Anzug zum Aufbau eines RC-Modells oder eines statischen Anzeigemodells. Rumpf aus FRP / ABS. Deck & Aufbau aus ABS / Holz / Epoxydharz (CNC). Detailbeschlagsteile aus Gießharz oder Metall. Alle Metallteile wie Laufräder werden durch CNC-Präzisionsleimung hergestellt.\n
Kit enthält Farbaufkleber. Das Kit enthält großformatige Messing-Fotoätzteile. Das Kit enthält eine Schritt-für-Schritt-3D-Anleitung.\n
212A Kit enthalten: Dieses Kit (Rumpf) kommt mit fast allem, was benötigt wird, um ein RC-Laufmodell zu bauen. Kit beinhaltet einen Rumpf, Decks, Einspritzteile, CNC-Blätter, Abziehbilder, Messing-Fotoätz, Anweisungen und andere Teile für die WTC-Installation.\n
WTC (Water Tight Cylinder) ist eine abgedichtete Kabine, die alle Maschinen und elektronischen Geräte wie Motoren, Wasserpumpe, Magnetventil, Servo, ESC, ERS, RC, Batterie usw. aufnimmt. WTC liefert U-Boot die Fähigkeit zu laufen, tauchen, und schwebend. Sie müssen WTC separat kaufen. Bitte beachten Sie, dass WTC 2 Arten, Einzel-Tank und Doppel-Tanks hat.',
        449),
       ('Sprengstoffe, Treibmittel, Pyrotechnika Taschenbuch', e'Sprengstoffe, Treibmittel, Pyrotechnika ist ein Lexikon mit 686 alphabetisch geordneten Sacheinträgen. Es beschreibt die physikalisch-chemischen Eigenschaften, Leistung, Empfindlichkeit, GHS- sowie REACH-Einstufung von 415 gängigen chemischen Metallen, Nichtmetallen und Verbindungen, die als Explosivstoffe, Oxidatoren, Brennstoffe, Bindemittel und Additive zum Einsatz kommen sowie die thermochemischen Eigenschaften von 435 Reinstoffen die als Reaktionsprodukte auftreten können. Außerdem informiert das Lexikon über die Zusammensetzung, Leistung und Empfindlichkeit von knapp 300 Sprengstoff- und Treibmittelformulierungen sowie von ca. 150 pyrotechnischen Sätzen. Daneben werden zivile und militärische Anwendungen für Explosivstoffe, deren chemische und physikalische Grundlagen, Prüfverfahren, Institutionen sowie schließlich auch Personen beschrieben, die sich international um die Entwicklung und Untersuchung von Explosivstoffen verdient gemacht haben. 100 zum Teil farbige Abbildungen, 160 Tabellen, 228 Strukturformeln, über 1200 Literaturstellen zur Primärliteratur, 1700 Einträge im Sachverzeichnis sowie die englische Übersetzung aller Sacheinträge machen das Buch zu einem unverzichtbaren Standardwerk für alle Leser, die mit Sprengstoffen, Treibmitteln, pyrotechnischen Sätzen, Feuerwerkskörpern und Munition befasst sind.
Sprengstoffe, Treibmittel, Pyrotechnika ist zur fachlichen Einarbeitung beim Berufseinstieg, als auch zur Weiterbildung im täglichen Gebrauch geeignet.\n
Über den Autor\n
Dr. Ernst-Christian Koch, FRSC studierte und promovierte im Fach Chemie an der Technischen Universität Kaiserslautern (TUK). Er ist seit über zwanzig Jahren aktiv im Bereich der Forschung und Entwicklung von Explosivstoffen. Dr. Koch ist Inhaber der Lutradyn Energetic Materials Science & Technology Consulting in Kaiserslautern.\n
Aus den Rezensionen zur 1. Auflage\n
"(...) Das Wissen um Explosivstoffe kann wohl kaum besser komprimiert dargestellt...', 102.95),
       ('Palette Jumbo-Toilettenpapier, Klopapierrollen, 2 lagig Zellstoff ca. 18cmx150m', e'Info zu diesem Artikel\n
TOP PREISLEISTUNG:\nDas Zellstoff Toilettenpapier ist hochweiß und keine billige, graue Recyclingware. Die Toilettenpapier-Großpackung ist eine günstige Alternative zu hochpreiseigen Markenprodukten.
IHR SPARVORTEIL:\n Die Toilettenpapier Kleinrollen in der Großpackung müssen seltener nachbestellt werden als Supermarkt-Größen. Außerdem sparen Sie Versandkosten und Verpackungsmaterial mit der Palette.
BENUTZERFREUNDLICH UND SPARSAM:\n Im geschlossenen benutzerfreundlichen Spendersystem wird von dem WC-Papier nur so viel verbraucht, wie benötigt wird. Somit ist das WC-Papier absolut sparsam.
UMWELTFREUNDLICH:\n Wir setzen auf Zellstoff Toilettenpapier in der Großpackung. Dies schont die Ressourcen und es entsteht weniger Müll im Gesamtsystem. Somit können Sie bares Geld sparen und die Umwelt schützen.
PASST IN GÄNGIGE SPENDER:\n Lagen: 2-lagig, 150 Blatt pro Rolle, Material: Zellstoff - hochweiß, kein billiges dunkelgraues Papier - Schneller Versand VE: 44 x 12 Rollen',
        842.31);

INSERT INTO bestellung(fk_kunde_id, fk_lieferadresse, bestelldatum, versanddatum)
VALUES ((SELECT kunde_id FROM kunde WHERE name LIKE 'Sunset%'),
        (SELECT adresse_id FROM adresse WHERE strasse = 'Post Office Road' AND hausnummer = '118'), CURRENT_DATE - 5,
        CURRENT_DATE - 1),
       ((SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%'),
        (SELECT adresse_id FROM adresse WHERE strasse = 'This Street' AND hausnummer = '2'), CURRENT_DATE - 3, NULL),
       ((SELECT kunde_id FROM kunde WHERE name LIKE 'Buttercream%'),
        (SELECT adresse_id FROM adresse WHERE strasse = 'Karen Crescent' AND hausnummer = '35'), CURRENT_DATE,
        NULL);

INSERT INTO umfasst(fk_bestellung_id, fk_produkt_id, anzahl)
VALUES ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Sunset%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'BlueBlue%'), 3),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Sunset%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Jolle%'), 2),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Sprengstoffe, Treibmittel%'), 1),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'ARKMODEL%'), 5),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Heckler und%'), 5),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Williams Turbojet%'), 1),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Ketchup Chips%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Massa Ticino%'), 60),
       ((SELECT bestellung_id
         FROM bestellung
         WHERE fk_kunde_id = (SELECT kunde_id FROM kunde WHERE name LIKE 'Butter%')),
        (SELECT produkt_id FROM produkt WHERE bezeichnung LIKE 'Palette Jumbo%'), 6);


-- eine View mit kunde (id, name) und Rechnungsadresse ("hausnummer strasse \n ort plz") bauen
DROP VIEW IF EXISTS kunden;
CREATE VIEW kunden AS
SELECT kunde.kunde_id,
       kunde.name,
       CONCAT(adresse.hausnummer, ' ', adresse.strasse, e'\n', adresse.ort, ' ', adresse.plz) AS adresse
FROM kunde
         INNER JOIN adresse ON kunde.fk_rechnungsadresse = adresse.adresse_id;

-- eine View bauen, die die offenen Bestellungen enthält, mit bestelldatum, kundename, bestellung_id, absteigend sortiert  dem Alter der Bestellung
CREATE VIEW offene_bestellungen AS
SELECT DISTINCT bestellung_id,
                bestelldatum,
                kunde.name,
                CONCAT(adresse.hausnummer, ' ', adresse.strasse, e'\n', adresse.ort, ' ',
                       adresse.plz) AS lieferadressedresse

FROM bestellung
         INNER JOIN kunde ON bestellung.fk_kunde_id = kunde.kunde_id
         INNER JOIN adresse ON bestellung.fk_lieferadresse = adresse.adresse_id
WHERE versanddatum IS NULL
ORDER BY bestelldatum;



--- View anlegen für offene Bestellungen mit:
-- bestellung_id, bestelldatum, kundenname und Lieferadresse in einem Feld als "hausnummer strasse \n ort plz"



-- View "Bestellungen mit Einzelposten" mit bestellung_id, bestelldatum, kunde_id, name, produktbezeichnung gekürzt auf 40 Zeichen mit '...' dahinter,
-- Anzahl, preis (als Einzelpreis), Anzahl * preis als NUMERIC(50,2) als posten sortiert nach bestellung_id und produktbezeichnung

-- View für die Kopfdaten der Rechnung

--Erstellung einer Rechnung

-- View für INSERT

-- View für Insert mit Prädikat



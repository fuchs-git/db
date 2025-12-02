SELECT CURRENT_DATABASE();

CREATE TABLE tierart (
    tierart_id   INTEGER PRIMARY KEY,
    tierart_name TEXT
);

CREATE TABLE tier (
    tier_id       INTEGER PRIMARY KEY,
    tier_name     TEXT,
    fk_tierart_id INTEGER REFERENCES tierart (tierart_id)
);

INSERT INTO tierart(tierart_id, tierart_name)
VALUES (1, 'Frosch'),
       (2, 'Elch'),
       (3, 'Waschbär'),
       (4, 'Schnabeltier');

INSERT INTO tier(tier_id, tier_name, fk_tierart_id)
VALUES (1, 'Fritz', 1),
       (2, 'Erika', 2),
       (3, 'Erik', 2),
       (4, 'Willi', 3),
       (5, 'Schorsch', NULL);


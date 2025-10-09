import psycopg

db_conn: psycopg.Connection
try:
    with psycopg.connect(dbname="db_privileges",
                         user="john",
                         password="Oberstufe",
                         host="localhost",
                         port="5432",
                         autocommit=True,
                         ) as db_conn:
        pass

except psycopg.DatabaseError as e:
    print(e, type(e))



        # # Tabelle Erzeugen
        # with db_conn.cursor() as cursor:
        #     try:
        #         cursor.execute('DROP TABLE person;')
        #     except psycopg.errors.UndefinedTable:
        #         print('Lege Tabelle neu an')
        #     cursor.execute('''CREATE TABLE person (
        #         id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        #         name  TEXT    NOT NULL,
        #         alter INTEGER NOT NULL
        #     )''')
        #
        # with db_conn.cursor() as cursor:
        #     namen = 'Jan Johan Nico Neiko Pawel Pascal Vikor Wolfi'.split()
        #     for name in namen:
        #         cursor.execute('''INSERT INTO person (name, alter) VALUES (%s, %s) RETURNING id, name, alter''',(name, random.randint(25,65)))
        #         print(cursor.fetchone())
        #
        #     cursor.execute('''INSERT INTO person (name, alter) VALUES (%s, %s)''',('Marco\');Drop Table person;-- -', random.randint(25,65)))

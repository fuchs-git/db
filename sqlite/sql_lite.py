import sqlite3
import json
import os

# =========================
# KONFIGURATION
# =========================

DB_MODE = "json_db"
# mögliche Werte:
# "sqlite_file"
# "sqlite_memory"
# "json_db"

# =========================
# ABSTRAKTE SCHNITTSTELLE
# =========================

class Database:
    def add_task(self, text):
        raise NotImplementedError

    def get_tasks(self):
        raise NotImplementedError


# =========================
# SQLITE (DATEI)
# =========================

class SQLiteFileDB(Database):
    def __init__(self):
        self.conn = sqlite3.connect("tasks.db")
        self.cursor = self.conn.cursor()
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                text TEXT
            )
        """)
        self.conn.commit()

    def add_task(self, text):
        self.cursor.execute("INSERT INTO tasks (text) VALUES (?)", (text,))
        self.conn.commit()

    def get_tasks(self):
        self.cursor.execute("SELECT * FROM tasks")
        return self.cursor.fetchall()


# =========================
# SQLITE (IN-MEMORY)
# =========================

class SQLiteMemoryDB(Database):
    def __init__(self):
        self.conn = sqlite3.connect(":memory:")
        self.cursor = self.conn.cursor()
        self.cursor.execute("""
            CREATE TABLE tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                text TEXT
            )
        """)
        self.conn.commit()

    def add_task(self, text):
        self.cursor.execute("INSERT INTO tasks (text) VALUES (?)", (text,))
        self.conn.commit()

    def get_tasks(self):
        self.cursor.execute("SELECT * FROM tasks")
        return self.cursor.fetchall()


# =========================
# JSON-DATENBANK (TinyDB-ähnlich)
# =========================

class JSONDatabase(Database):
    def __init__(self):
        self.filename = "tasks.json"
        if not os.path.exists(self.filename):
            with open(self.filename, "w") as f:
                json.dump([], f)

    def add_task(self, text):
        with open(self.filename, "r") as f:
            data = json.load(f)

        data.append({"text": text})

        with open(self.filename, "w") as f:
            json.dump(data, f, indent=2)

    def get_tasks(self):
        with open(self.filename, "r") as f:
            data = json.load(f)
        return list(enumerate([d["text"] for d in data], start=1))


# =========================
# FACTORY
# =========================

def get_database():
    if DB_MODE == "sqlite_file":
        return SQLiteFileDB()
    elif DB_MODE == "sqlite_memory":
        return SQLiteMemoryDB()
    elif DB_MODE == "json_db":
        return JSONDatabase()
    else:
        raise ValueError("Unbekannter DB_MODE")


# =========================
# HAUPTPROGRAMM
# =========================

db = get_database()

print("Eingebettete Datenbank Demo")
print(f"Aktives DBMS: {DB_MODE}")

while True:
    print("\n1) Aufgabe hinzufügen")
    print("2) Aufgaben anzeigen")
    print("3) Beenden")

    choice = input("> ")

    if choice == "1":
        text = input("Aufgabe: ")
        db.add_task(text)
        print("Gespeichert.")

    elif choice == "2":
        tasks = db.get_tasks()
        print("\nAufgaben:")
        for t in tasks:
            print(t)

    elif choice == "3":
        break

    else:
        print("Ungültige Eingabe")

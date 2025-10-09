import psycopg

#connection = psycopg.connect(database="db_privileges", user="postgres", password="password", host="localhost", port=5432)
connection = psycopg.connect(database="db_privileges", user="john", password="Oberstufe", host="localhost", port=5432)

cursor = connection.cursor()
cursor.execute("SELECT current_user;")
# Fetch all rows from database
record = cursor.fetchall()

print("Data from Database:- ", record)

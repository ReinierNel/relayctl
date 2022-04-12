import sqlite3

connect = sqlite3.connect('relayctl.db')
cursor = connect.cursor()

cursor.execute("CREATE TABLE relays(id INTEGER PRIMARY KEY AUTOINCREMENT, gpio INT NOT NULL)")
cursor.execute("CREATE TABLE switches(id INTEGER PRIMARY KEY AUTOINCREMENT, relay_id INT NOT NULL, mode INT NOT NULL, action INT NOT NULL)")
cursor.execute("CREATE TABLE schedules(id INTEGER PRIMARY KEY AUTOINCREMENT, relay_id INT NOT NULL, action INT NOT NULL, start TEXT NOT NULL, end TEXT NOT NULL, mon int NOT NULL, tue int NOT NULL, wed INT NOT NULL, thu INT NOT NULL, fri INT NOT NULL, sat INT NOT NULL, sun INT NOT NULL)")

connect.commit()
connect.close()

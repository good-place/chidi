(import sqlite3 :as sql)
(import sql/utils :as su)

(defn perform [dbf]
  (su/open-db dbf)

  (sql/eval su/db `DROP TABLE IF EXISTS people`)
  (sql/eval su/db `CREATE TABLE people(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, gender TEXT);`)

  (sql/eval su/db "BEGIN TRANSACTION")
  (loop [person :in [{:name "John Doe" :phone "77788899" :gender "male"}
                     {:name "Jack Ripper" :phone "77766699" :gender "male"}
                     {:name "Jo No" :phone "22288899" :gender "female"}
                     {:name "No Yo" :phone "22266699" :gender "female"}
                     {:name "Jim Tim" :phone "77788833" :gender "other"}
                     {:name "Janet Johnson" :phone "77766633" :gender "femmale"}
                     {:name "Jose Best" :phone "44448899" :gender "other"}]]
    (sql/eval su/db `INSERT INTO people (name, phone, gender) VALUES(:name, :phone, :gender);` person))
  (sql/eval su/db "END TRANSACTION")

  (let [records (sql/eval su/db `SELECT * FROM people;`)]
    (print "There are " (length records) " records in DB:")
    (loop [record :in records] (pp record)))

  (su/close))


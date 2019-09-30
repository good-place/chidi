(import sqlite3 :as sql)

# FIXME with dyn
(var db nil)

(defn open-db "Opens DB" [db-file] (set db (sql/open db-file)))

(defn drop-table 
  "Drops table. Optional if exists flag"
  [t]
  (sql/eval db (string "DROP TABLE IF EXISTS " t " ;")))

(defn create-table 
  "Creates table with columns. Auto increment id"
  [t columns]
  (sql/eval db
            (string/join
              ["CREATE TABLE"  t "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
               (string/join (seq [[c ct] :pairs columns] (string c " " ct)) ", ")
               ");"]
              " ")))

(defn begin-transaction 
  "Begins transaction"
  []
  (sql/eval db "BEGIN TRANSACTION"))

(defn end-transaction 
  "Ends transaction"
  []
  (sql/eval db "END TRANSACTION"))

(defn- select [t &opt & stms]
  (string/join 
    (array/concat @["SELECT * FROM" t] ;stms ";") " "))

(defn get-records [t]
  "Get records from the t"
  (sql/eval db (select t)))

(defn get-record [t id]
  "Get records from the table by the id"
  (first (sql/eval db (select t "WHERE ID=:id") {:id id})))

(defn find-records [t bnd]
  "Get records from the table by the id"
  (sql/eval db (select t (if (empty? bnd) 
                           [] 
                           ["WHERE" ;(map |(string $ "=:" $) (keys bnd))])) bnd))

(defn insert 
  "Insert record from body to table"
  [t body]
  (sql/eval db (string/join ["INSERT INTO" t "(" (string/join (keys body) ", ") 
                             ") VALUES (" (string/join (map |(string ":" $) (keys body)) ",") ");"] " ")
            body)
  (sql/last-insert-rowid db))

(defn update 
  "Update record with id from body in table"
  [t id body]
  (sql/eval db (string/join ["UPDATE" t " SET " (string/join (map |(string $ "=:" $) (keys body)) ",")
                             "WHERE id=:id;"] " ")
            (merge body {:id id})))

(defn delete 
  "Delete record with id from table"
  [t id]
  (sql/eval db (string/join ["DELETE FROM" t "WHERE id=:id;"] " ") {:id id}))

(defn close []
  "Closes DB connection"
  (sql/eval db "PRAGMA optimize;")
  (sql/close db))


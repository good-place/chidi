(import sqlite3 :as sql)

(def db "Opens DB" (sql/open "people.db"))

(defn- select [t &opt & stms]
  (string/join 
    (array/concat @["SELECT * FROM" t] ;stms ";")
    " "))

(defn get-records [t]
  "Get records from the t"
  (sql/eval db (select t)))

(defn get-record [t id]
  "Get records from the table by the id"
  (first (sql/eval db (select t "WHERE ID=:id") {:id id})))

(defn find-records [t bnd]
  "Get records from the table by the id"
  (sql/eval db (select t (if (empty? bnd) [] ["WHERE" ;(map |(string $ "=:" $) (keys bnd))])) bnd))

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

(defn close []
  "Closes DB connection"
  (sql/close db))


(defn content [service-name]
  (string
``(import sqlite3 :as sql)
(import chidi/sql/utils :as su)

(defn perform [dbf]
  (su/open-db dbf)
  (su/drop-table :`` service-name ``)
  (su/create-table :`` service-name `` {:name :TEXT}) # @fixme with real table columns
  (su/begin-transaction)
  # @fixme add your code to insert something, or delete whole transaction
  (su/end-transaction)
  (su/close))``))

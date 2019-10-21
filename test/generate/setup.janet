(import tester :prefix "")
(import chidi/generate/setup)

(deftest "generating"
  (test "content" 
        (= (chidi/generate/setup/content "test")
           ``(import sqlite3 :as sql)
(import chidi/sql/utils :as su)

(defn perform [dbf]
  (su/open dbf)
  (su/drop-table :test)
  (su/create-table :test {:name :TEXT}) # @fixme with real table columns
  (su/begin-transaction)
  # @fixme add your code to insert something, or delete whole transaction
  (su/end-transaction)
  (su/close))``)))



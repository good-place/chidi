(import sqlite3 :as sql)
(import chidi/sql/utils :as su)

(def- trees
  [{:specie "Platane" :size 9}
   {:specie "Oak" :size 8}
   {:specie "Linden" :size 3}
   {:specie "Beech" :size 9}])

(defn perform [dbf]
  (su/open-db dbf)
  (su/drop-table :trees)
  (su/create-table :trees {:size :NUMBER :specie :TEXT})
  (su/begin-transaction)
  (loop [tree :in trees] (su/insert :trees tree))
  (su/end-transaction)
  (su/close))


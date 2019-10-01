(import sqlite3 :as sql)
(import chidi/sql/utils :as su)

(def- people 
  [{:name "John Doe" :phone "77788899" :gender "male" :tree 4}
   {:name "Jack Ripper" :phone "77766699" :gender "male" :tree 4}
   {:name "Jo No" :phone "22288899" :gender "female" :tree 3}
   {:name "No Yo" :phone "22266699" :gender "female" :tree 2}
   {:name "Jim Tim" :phone "77788833" :gender "other" :tree 1}
   {:name "Janet Johnson" :phone "77766633" :gender "femmale" :tree 2}
   {:name "Jose Best" :phone "44448899" :gender "other" :tree 2}])

(defn perform [dbf]
  (su/open-db dbf)
  (su/drop-table :people)
  (su/create-table :people {:name :TEXT :phone :TEXT :gender :TEXT :tree :ID})
  (su/begin-transaction)
  (loop [person :in people] (su/insert :people person))
  (su/end-transaction)
  (su/close))


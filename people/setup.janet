(import sqlite3 :as sql)
(import sql/utils :as su)

(def- people 
  [{:name "John Doe" :phone "77788899" :gender "male"}
                   {:name "Jack Ripper" :phone "77766699" :gender "male"}
                   {:name "Jo No" :phone "22288899" :gender "female"}
                   {:name "No Yo" :phone "22266699" :gender "female"}
                   {:name "Jim Tim" :phone "77788833" :gender "other"}
                   {:name "Janet Johnson" :phone "77766633" :gender "femmale"}
                   {:name "Jose Best" :phone "44448899" :gender "other"}])

(defn perform [dbf]
  (su/open-db dbf)
  (su/drop-table :people)
  (su/create-table :people {:name :TEXT :phone :TEXT :gender :TEXT})
  (su/begin-transaction)
  (loop [person :in people] (su/insert :people person))
  (su/end-transaction)
  (su/close))


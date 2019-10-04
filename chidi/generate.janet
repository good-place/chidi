(defn service 
  "Generates service stub"
  [sn]

  (def sf 
    (string
``(import chidi/service :as service)
(import chidi/http/body :prefix "")
(import chidi/http/query-params :prefix "")

(service/defservice :`` sn `` {:allowed-keys []}) # @fixme add allowed keys

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"`` sn ``" (-> many body query-params)
   "`` sn ``" (-> one body)})``))
  (os/mkdir (string "./app/" sn)) # @fixme with path
  (with [f (file/open (string "./app/" sn "/service.janet") :w)]
     (file/write f sf)))

(defn setup 
  "Generates service setup"
  [sn]
  (def st
    (string
``(import sqlite3 :as sql)
(import chidi/sql/utils :as su)
(defn perform [dbf]
  (su/open-db dbf)
  (su/drop-table `` sn ``)
  (su/create-table `` sn `` {}) # @fixme add table columns
  (su/begin-transaction)
  # @fixme add your code to insert something, or delete whole transaction
  (su/end-transaction)
  (su/close))``))
  (with [f (file/open (string "./app/" sn "/setup.janet") :w)]
       (file/write f st)))

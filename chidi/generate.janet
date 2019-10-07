(defn app 
  "Generates app directory structure"
  [name]
  (print "Generating new app -> " name " <-")

  (def pf
    (string
``(declare-project
  :name "`` name ``"
  :description "Really great API" # @fixme with some real desc here please
  :dependencies ["https://github.com/pepe/chidi.git"
                 "https://github.com/joy-framework/tester"])``))

  (def ai
``(import circlet)
(import chidi/http/router :as router)
(import chidi/http/json-type :as json-type)
(import chidi/sql/utils :as su)
# @fixme add services and setups imports

(def- routes (merge )) # @fixme add services' routes

(defn setup [db-file]
  (print "=== Recreating db ===")
  # @fixme add setups
  (print "--- Done ---"))

(def server 
  (-> routes
      router/make 
      json-type/only 
      circlet/logger))``)

  (os/mkdir name)
  (os/mkdir (string name "/app"))
  (with [f (file/open (string name "/project.janet") :w)]
     (file/write f pf))
  (with [f (file/open (string name "/app/init.janet") :w)]
     (file/write f ai))
  (print "App " name " generated")
  (print "To start work with it cd " name " and run chd --help"))

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

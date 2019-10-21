# @no-test
(def content
``(import circlet)
(import chidi/http/router :as router)
(import chidi/http/json-type :as json-type)
(import chidi/sql/utils :as su)
(import app/common/service :as common)

(def- routes common/routes)

(defn setup [db-file]
  (print "=== Recreating db ===")
  # @fixme add setups
  (error "No setup defined")
  (print "--- Done ---"))

(def server 
  (-> routes
      router/make 
      json-type/only 
      circlet/logger))``)


(import circlet)
(import chidi/http/router :as router)
(import chidi/http/json-type :as json-type)
(import chidi/sql/utils :as su)
(import app/common/service :as common)
(import app/people/service :as people)
(import app/trees/service :as trees)
(import app/people/setup)
(import app/trees/setup)

(def- routes (merge common/routes people/routes trees/routes))

(defn setup [db-file]
  (print "=== Recreating db ===")
  (app/people/setup/perform db-file)
  (app/trees/setup/perform db-file)
  (print "--- Done ---"))

(def server 
  (-> routes
      router/make 
      json-type/only 
      circlet/logger))

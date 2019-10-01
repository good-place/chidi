(import circlet)
(import chidi/http/router :as router)
(import chidi/http/json-type :as json-type)
(import chidi/sql/utils :as su)
(import app/common/service :as common)
(import app/people/service :as people)

(def- routes (merge common/routes people/routes))

(def server 
  (-> routes
      router/make 
      json-type/only 
      circlet/logger))

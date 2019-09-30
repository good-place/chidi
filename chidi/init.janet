(import circlet)

(import chidi/http/router :as router)
(import chidi/http/json-type :as json-type)
(import chidi/sql/utils :as su)

(import app)

(defn server
  "Runs http server"
  [&opt port db-file]
  (default port 8130)
  (default db-file "chidi.db")
  (su/open-db db-file)

  (print "> Hi. I am Chidi, your soulmate.")
  (-> app/routes
      router/make 
      json-type/only 
      circlet/logger 
      (circlet/server port))
  (su/close))

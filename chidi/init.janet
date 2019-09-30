(import circlet)

(import ./http/router :as router)
(import ./http/json-type :as json-type)
(import ./sql/utils :as su)

(import ../app/routes :as routes)

(defn server
  "Runs http server"
  [&opt port db-file]
  (default port 8130)
  (default db-file "chidi.db")
  (su/open-db db-file)

  (print "> Hi. I am Chidi, your soulmate.")
  (-> routes/all
      router/make 
      json-type/only 
      circlet/logger 
      (circlet/server port))
  (su/close))

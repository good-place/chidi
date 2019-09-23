(import circlet)

(import routes :prefix "")
(import http/router :prefix "")
(import http/json-type :as json-type)
(import sql/utils :as su)


(defn main 
  "Main entry point for the chidi"
  [&opt port db-file]
  (default port 8130)
  (default db-file "chidi.db")
  (su/open-db db-file)

  (print "> Hi. I am Chidi, your soulmate.")
  (-> routes 
      router 
      json-type/only 
      circlet/logger 
      (circlet/server port))
  (su/close))

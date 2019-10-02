(import circlet)
(import chidi/sql/utils :as su)


(import app)

(defn server
  "Runs http server"
  [&opt port db-file]
  (default port 8130)
  (default db-file "chidi.db")
  (su/open-db db-file)

  (print "> Hi. I am Chidi, your soulmate.")
  (-> app/server
      (circlet/server port))
  (su/close))

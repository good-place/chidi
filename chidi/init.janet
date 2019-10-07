(import circlet)
(import chidi/sql/utils :as su)

(if (os/stat "./app/init.janet")
  (do 
    (def- appenv (dofile "./app/init.janet"))
    (def- setup ((appenv 'setup) :value))
    (def- server ((appenv 'server) :value))

    (defglobal 'app-setup 
      (fn app-setup [db-file]
        (setup db-file)))

    (defglobal 'app-server
      (fn app-server [port db-file]
        (default port 8130)
        (default db-file "chidi.db")
        (su/open-db db-file)

        (print "> Hi. I am Chidi, your soulmate.")
        (-> server
            (circlet/server port))
        (su/close))))
  (let [err (fn [&] (error "There is no app module"))]
    (defglobal 'app-setup err)
    (defglobal 'app-server err)))

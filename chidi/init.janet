(import circlet)
(import chidi/sql/utils :as su)

(if (os/stat "./app/init.janet")
  (let [appenv (dofile "./app/init.janet")
        setup (get-in appenv ['setup :value])
        server (get-in appenv ['server :value])]
    (defglobal 'app-setup 
      (fn app-setup [db-file] 
        (unless setup (error "You need to implement setup function in your app"))
        (setup db-file)))
    (defglobal 'app-server
      (fn app-server [port db-file]
        (unless server (error "You need to implement server function in your app"))
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

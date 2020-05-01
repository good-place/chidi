(import circlet)
(import mansion/store :as store)

(if (os/stat "./app/init.janet")
  (let [appenv (dofile "./app/init.janet")
        server (get-in appenv ['server :value])]
    (defglobal 'app-server
      (fn app-server [port]
        (unless server (error "You need to implement server function in your app"))
        (default port 8130)
        (print "> Hi. I am Chidi, your soulmate.")
          (-> server (circlet/server port)))))
  (let [err (fn [&] (error "There is no app module"))]
    (defglobal 'app-setup err)
    (defglobal 'app-server err)))

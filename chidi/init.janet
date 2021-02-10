(import halo2)

(if (os/stat "./app/init.janet")
  (do
    (def appenv (dofile "./app/init.janet"))
    (def server (get-in appenv ['server :value]))
    (defglobal 'app-server
      (fn app-server [port]
        (if (not server)
          (error "You need to implement server function in your app"))
        (default port 8130)
        (print "> Hi. I am Chidi, your soulmate.")
        (-> (server) (halo2/server port)))))
  (defglobal 'app-server (fn [&] (error "There is no app module"))))
(if (os/stat "./app/reception.janet")
  (let [rcpenv (dofile "./app/reception.janet")
        run (get-in rcpenv ['run :value])]
    (defglobal 'run-reception
      (fn run-reception []
        (if run (run) (print "I cannot run reception")))))
  (defglobal 'run-reception (fn [&] (print "There is no reception module"))))

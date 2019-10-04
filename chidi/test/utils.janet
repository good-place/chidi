(import chidi/http/fetch :as fetch)

(var port 8140)
(with [f (file/open ".test-port" :r)] 
   (set port (->  f (file/read :all) scan-number)))

(defn on-server [&opt path] 
  (string "http://localhost:" port "/" (or path "")))

(defn ensure-running-server []
  (pp (on-server))
  (when (empty? (fetch/get (on-server))) 
   (error "It looks like your test server is not running. Run it with `./chd test-server`")))



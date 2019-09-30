(import chidi/http/fetch :as fetch)

(def- server "http://localhost:8140/")

(defn on-server [&opt path] 
  (if path 
    (string server path)
    server))

(defn ensure-running-server []
  (when (empty? (fetch/get (on-server))) 
   (error "It looks like your text server is not running. Run it with `./test-chidi`")))



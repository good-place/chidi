(def- server "http://localhost:8140/")

(defn on-server [&opt path] 
  (if path 
    (string server path)
    server))



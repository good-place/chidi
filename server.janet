(import circlet)

(import routes :prefix "")
(import http/router :prefix "")
(import http/json-type :as json-type)

(defn main 
  "Main entry point for the chidi"
  [&]
  (-> routes 
     router 
     json-type/only 
     circlet/logger 
     (circlet/server 8130)))

(import circlet)

(import routes :prefix "")
(import http/router :prefix "")
(import http/json-type :as json-type)
(import sql/utils :as su)


(defn main 
  "Main entry point for the chidi"
  [&]
  (print "> Hi. I am Chidi, your soulmate.")
  (-> routes 
     router 
     json-type/only 
     circlet/logger 
     (circlet/server 8130))
  (su/close))

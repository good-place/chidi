(import circlet)
(import trolley)

(defn make
  "Creates a router middleware"
  [routes]
  (def r (trolley/router routes))
  (fn [req]
    (let [[action params] (r (req :uri))]
      (if action 
        ((circlet/middleware action) (put req :params params))
        ((circlet/middleware (routes :not-found)) req)))))


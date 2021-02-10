(import trolley)

(defn make
  "Creates a router middleware"
  [routes]
  (def r (trolley/router routes))
  (fn [req]
    (let [[action params] (r (req :uri))]
      (if action
        (action (put req :params params))
        ((routes :not-found) req)))))

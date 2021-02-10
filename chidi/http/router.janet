(import trolley :prefix "")

(defn- coerce [action]
  (if (function? action) action
    (fn [r] action)))

(defn make
  "Creates a router middleware"
  [routes]
  (def r (router routes))
  (fn [req]
    (def [action params] (r (req :uri)))
    (if action
      ((coerce action)
        (put req :params params))
      ((coerce (routes :not-found)) req))))

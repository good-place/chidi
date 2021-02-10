# Not needed?

(defn get-method
  "Returns request method as keyword"
  [req]
  (keyword (string/ascii-lower (req :method))))

(import json)
(import chidi/utils :as u)

(defn parse
  "Parse body into Janet struct under :body key"
  [nextmw]
  (fn [req]
    (let [b (req :body)]
      (unless (empty? b)
        (->> b
             json/decode
             freeze
             (put req :body))))
    (nextmw req)))

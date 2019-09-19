(import http/response :as r)

(defn only 
  "Middleware for ensuring only json content type"
  [nextmw]
  (fn [req] 
    (let [accept ((req :headers) "Accept")]
      (if-not (some |(= accept $) [r/json-content-type r/any-content-type])
        (r/not-supported {:message (string/join [accept "is not supported, please use '" r/json-content-type "' or '" r/any-content-type])})
        (nextmw req)))))

(import chidi/utils :as utils)
(import chidi/http/utils :as http/utils)
(import chidi/http/response :as http/response)

(def- query-string-grammar
  (peg/compile 
       {:eql "=" :sep "&" :content '(some (if-not (+ :eql :sep) 1))
        :main '(some (+ (* ':content :eql ':content :sep)
                        (* ':content :eql ':content -1)))}))

(defn- parse-query-string 
  "Parses query string into table. Keywordize keys and decode values"
  [query-string]
  (-?>> query-string
        (peg/match query-string-grammar)
        (apply table)
        (utils/map-keys keyword)
        (utils/map-vals http/utils/decode)))

(defn parse
  "Parses query string into janet struct under :query-params key. 
   Keys are keywordized"
  [nextmw]
  (fn [req]
    (let [query-string (req :query-string)]
      (unless (empty? query-string)
        (-?>> query-string
              parse-query-string
              (put req :query-params))
        (if (nil? (req :query-params)) 
          (http/response/bad-request {:message "Query params have invalid format"})
          (nextmw req))))))



(import utils :as u)
(import http/utils :as hu)

(def- query-string-grammar
  (peg/compile 
       {:eql "=" :sep "&" :content '(some (if-not (+ :eql :sep) 1))
        :main '(some (* (* ':content :eql ':content) (any :sep)))}))

(defn- parse-query-string 
  "Parses query string into table. Keywordize keys and decode values"
  [query-string]
  (-?>> query-string
        (peg/match query-string-grammar)
        (apply table)
        (u/map-keys keyword)
        (u/map-vals hu/decode)))

(defn query-params
  "Parses query string into janet struct under :query-params key. 
   Keys are keywordized"
  [nextmw]
  (fn [req]
    (let [query-string (req :query-string)]
      (unless (empty? query-string)
        (-?>> query-string
              parse-query-string
              (put req :query-params)))
     (nextmw req))))



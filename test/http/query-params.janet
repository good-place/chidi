(import spork/test :prefix "")
(import ../../chidi/http/query-params)

(assert
  (not (nil? (query-params/parse identity)))
  "creates query-params middleware")
(assert
  (= (type (query-params/parse identity)) :function)
  "creates function")
(assert
  (deep= ((query-params/parse identity) @{:query-string "id=1&name=pepe"})
         @{:query-params {"id" "1" "name" "pepe"} :query-string "id=1&name=pepe"})
  "parses query string into table")
(assert
  (deep= ((query-params/parse identity) @{:query-string "id1namepepe"})
         {:headers @{"Content-Type" "application/json"} :status 400 :body @"{\"message\":\"Query params have invalid format\"}"})
  "does not parse wrong params")

(import tester :prefix "")
(import chidi/http/query-params)


(deftest "query-params middleware"
  (test "creates query-params middleware" 
        (not (nil? (chidi/http/query-params/parse identity))))
  (test "creates function" 
        (= (type (chidi/http/query-params/parse identity)) :function))
  (test "parses query string into table"
        (deep= ((chidi/http/query-params/parse identity) @{:query-string "id=1&name=pepe"}) 
              @{:query-params {:id "1" :name "pepe"} :query-string "id=1&name=pepe"}))
  (test "does not parse wrong params"
       (deep= ((chidi/http/query-params/parse identity) @{:query-string "id=1name=pepe"})
              {:headers @{"Content-Type" "application/json"} :status 400 :body @"{\"message\":\"Query params have invalid format\"}"})))




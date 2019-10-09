(import tester :prefix "")
(import chidi/http/query-params)


(deftest "json-type middleware"
  (test "creates json-type middleware" 
        (not (nil? (chidi/http/query-params/parse identity))))
  (test "creates function" 
        (= (type (chidi/http/query-params/parse identity)) :function))
  (test "parses query string into table"
        (deep= ((chidi/http/query-params/parse identity) @{:query-string "id=1&name=pepe"}) 
              @{:query-params {:id "1" :name "pepe"} :query-string "id=1&name=pepe"})))




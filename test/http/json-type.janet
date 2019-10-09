(import tester :prefix "")
(import chidi/http/json-type)


(deftest "json-type middleware"
  (test "creates json-type middleware" 
        (not (nil? (chidi/http/json-type/only identity))))
  (test "creates function" 
        (= (type (chidi/http/json-type/only identity)) :function))
  (test "does nothing on json content type"
        (deep= ((chidi/http/json-type/only identity) @{:headers {"Accept" "application/json"}}) 
              @{:headers {"Accept" "application/json"}}))
  (test "does nothing on all content type"
        (deep= ((chidi/http/json-type/only identity) @{:headers {"Accept" "*/*"}}) 
              @{:headers {"Accept" "*/*"}}))
  (test "responses not supported on wrong content type"
        (deep= ((chidi/http/json-type/only identity) @{:headers {"Accept" "text/html"}}) 
              {:headers @{"Content-Type" "application/json"} :status 415 :body @"{\"message\":\"text/htmlis not supported, please use 'application/json' or '*/*\"}"})))



(import tester :prefix "")
(import chidi/http/body)

(deftest "body middleware"
  (test "creates body middleware" 
        (not (nil? (chidi/http/body/parse identity))))
  (test "creates function" 
        (= (type (chidi/http/body/parse identity)) :function))
  (test "decodes body"
        (deep= ((chidi/http/body/parse identity) @{:body "{\"a\": 1}"}) 
              @{:body {:a 1}})))


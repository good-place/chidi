(import tester :prefix "")
(import chidi/http/body)

(deftest "body middleware"
  (test "creates body middleware" 
        (not (nil? (chidi/http/body/middleware identity))))
  (test "creates function" 
        (= (type (chidi/http/body/middleware identity)) :function))
  (test "decodes body"
        (deep= ((chidi/http/body/middleware identity) @{:body "{\"a\": 1}"}) 
              @{:body {:a 1}})))


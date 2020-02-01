(import tester :prefix "")
(import ../../chidi/http/body)

(deftest "body middleware"
  (test "creates body middleware"
        (not (nil? (body/parse identity))))
  (test "creates function"
        (= (type (body/parse identity)) :function))
  (test "decodes body"
        (deep= ((body/parse identity) @{:body "{\"a\": 1}"})
              @{:body {:a 1}})))


(import tester :prefix "")
(import ../../chidi/http/utils)

(deftest "get-method"
  (test "gets http method as keyword"
        (= (utils/get-method {:method "POST"}) :post)))

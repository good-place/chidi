(import tester :prefix "")
(import ../../chidi/http/router)

(deftest "router middleware"
  (test "creates body middleware"
        (not (nil? (router/make {"/" :home :not-found :not-found}))))
  (test "creates function"
        (= (type (router/make {"/" :home :not-found :not-found})) :function))
  (test "routes to home"
        (= ((router/make {"/" :home :not-found :not-found}) @{:uri "/"}) :home))
  (test "routes to not-found"
        (= ((router/make {"/" :home :not-found :not-found}) @{:uri "/not-found"}) :not-found)))


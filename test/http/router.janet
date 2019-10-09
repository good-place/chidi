(import tester :prefix "")
(import chidi/http/router)

(deftest "router middleware"
  (test "creates body middleware" 
        (not (nil? (chidi/http/router/make {"/" :home :not-found :not-found}))))
  (test "creates function" 
        (= (type (chidi/http/router/make {"/" :home :not-found :not-found})) :function))
  (test "routes to home"
        (= ((chidi/http/router/make {"/" :home :not-found :not-found}) @{:uri "/"}) :home))
  (test "routes to not-found"
        (= ((chidi/http/router/make {"/" :home :not-found :not-found}) @{:uri "/not-found"}) :not-found)))


(import spork/test :prefix "")
(import ../../chidi/http/router)


(assert
  (not (nil? (router/make {"/" :home :not-found :not-found})))
  "creates router middleware")
(assert
  (= (type (router/make {"/" :home :not-found :not-found})) :function)
  "creates function")
(assert
  (= ((router/make {"/" :home :not-found :not-found}) @{:uri "/"}) :home)
  "routes to home")
(assert
  (= ((router/make {"/" :home :not-found :not-found}) @{:uri "/not-found"}) :not-found)
  "routes to not-found")

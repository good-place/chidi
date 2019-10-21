(import tester :prefix "")
(import chidi/generate/db-service)

(deftest "generating"
  (test "content" 
        (= (chidi/generate/db-service/content "test")
           ``(import chidi/service :as service)
(import chidi/http/body :as body)
(import chidi/http/query-params :as query-params)

(service/defservice :test {:allowed-keys []}) # @fixme add allowed keys

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"/test" (-> many body/parse query-params/parse)
   "/test/:id" (-> one body/parse)})``)))

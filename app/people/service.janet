(import chidi/service :as service)
(import chidi/http/body :prefix "")
(import chidi/http/query-params :prefix "")

(service/defservice :people {:allowed-keys [:phone :tree :name]})

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"/people" (-> many body query-params)
   "/people/:id" (-> one body)})


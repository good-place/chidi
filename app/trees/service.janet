(import chidi/service :as service)
(import chidi/http/body :prefix "")
(import chidi/http/query-params :prefix "")

(service/defservice :trees {:allowed-keys [:size :specie]})

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"/trees" (-> many body query-params)
   "/trees/:id" (-> one body)})


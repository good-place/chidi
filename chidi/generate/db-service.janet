# @todo fixme with mendoza
(defn content [name]
  (string
``(import chidi/service :as service)
(import chidi/http/body :prefix "")
(import chidi/http/query-params :prefix "")

(service/defservice :`` name `` {:allowed-keys []}) # @fixme add allowed keys

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"/`` name ``" (-> many body query-params)
   "/`` name ``/:id" (-> one body)})``))

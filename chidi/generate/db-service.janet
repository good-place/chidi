# @todo fixme with mendoza
(defn content [name]
  (string
``(import chidi/service :as service)
(import chidi/http/body :as body)
(import chidi/http/query-params :as query-params)

(service/defservice :`` name `` {:allowed-keys []}) # @fixme add allowed keys

(service/many [:get :post])

(service/one [:get :patch :delete])

(def routes
  {"/`` name ``" (-> many body/parse query-params/parse)
   "/`` name ``/:id" (-> one body/parse)})``))


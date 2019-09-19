(import http/query-params :prefix "")
(import http/methods :as hm)
(import common/responses :as cr)
(import people/responses :as people)

(def routes
  "Defines routes"
  {"/" cr/home-success
   "/people" (-> people/many (hm/guards :get :post) query-params)
   "/people/:id" people/one
   :not-found cr/not-found})



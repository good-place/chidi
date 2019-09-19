(import http/query-params :prefix "")
(import http/methods :as hm)
(import http/body :prefix "")
(import common/responses :as cr)
(import people/responses :as people)

(def routes
  "Defines routes"
  {"/" cr/home-success
   "/people" (-> people/many (hm/guards :get :post) body query-params)
   "/people/:id" (-> people/one (hm/guards :get :patch) body)
   :not-found cr/not-found})



(import common/responses :as cr)
(import people/service :as people)

(def routes
  "Defines routes"
  (merge 
    {"/" cr/home-success
    :not-found cr/not-found}
    people/routes))



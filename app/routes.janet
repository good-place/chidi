(import ./common/service :as common)
(import ./people/service :as people)

(def all
  "Defines routes"
  (merge 
    {"/" common/home-success
    :not-found common/not-found}
    people/routes))



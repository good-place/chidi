(import app/common/service :as common)
(import app/people/service :as people)

(def routes
  "Defines routes"
  (merge 
    {"/" common/home-success
     :not-found common/not-found}
    people/routes))



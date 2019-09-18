(import common/responses :as cr)

(def routes
  "Defines routes"
  {"/" cr/home-success
   :not-found cr/not-found})



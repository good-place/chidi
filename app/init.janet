(import app/common/service :as common)
(import app/people/service :as people)

(def routes (merge common/routes people/routes))

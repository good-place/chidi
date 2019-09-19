(import http/response :as r)

(def not-found 
  "Page not found response"
  (r/not-found  {:message "Not Found."}))

(def home-success
  "Home page. Can be used as Ping page"
  (r/success {:message "I am Chidi. Your soulmate."}))

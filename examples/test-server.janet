(import /chidi/http/server :prefix "")

(start
  (fn [r]
    (if (> 0.25 (math/random)) (error "Very bad!"))
    (success "Hello World!"))
  "localhost" "6667")

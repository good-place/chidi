(import /chidi/http/server :prefix "")

(start
  (fn [r]
    (if (> 0.25 (math/random)) (error "Very bad!"))
    (success "Hello World!"))
  "localhost" "6667"
  (fn supervisor [chan stream]
    (match (ev/take chan)
      [:error e]
      (do
        (print "How Bad? " (fiber/last-value e))
        (:write stream (internal-server-error "Sorry, I could not decide."))))))

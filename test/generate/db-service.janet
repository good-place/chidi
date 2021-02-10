(import spork/temple :prefix "")
(import spork/test :prefix "")

(add-loader)
(import ../../chidi/generate/db-service)

(start-suite 7)

(assert
  (= (capture-stdout (db-service/render :name "test"))
     "render"))

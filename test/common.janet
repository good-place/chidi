(import tester :prefix "")
(import http/fetch :as fetch)

(import test/utils :prefix "")

(deftest "Home page"
  (test "Greetings message" 
        (= (fetch/get (on-server)) 
           "{\"message\":\"Hi. I am Chidi, your soulmate.\"}")))

(deftest "Not found"
  (test "Not fount message" 
        (= (fetch/get (on-server "not-found"))
           "{\"message\":\"Not Found.\"}")))

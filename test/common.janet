# @todo test server must be running
(import tester :prefix "")
(import chidi/http/fetch :as fetch)
(import chidi/test/utils :prefix "")

(ensure-running-server)

(deftest "Home page"
  (test "Greetings message" 
        (= (fetch/get (on-server)) 
           "{\"message\":\"Hi. I am Chidi, your soulmate.\"}")))

(deftest "Not found"
  (test "Not fount message" 
        (= (fetch/get (on-server "not-found"))
           "{\"message\":\"Not Found.\"}")))

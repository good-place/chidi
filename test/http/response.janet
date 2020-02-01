(import tester :prefix "")
(import ../../chidi/http/response)

(deftest "not-found"
  (test "returns not found response"
        (deep= (response/not-found {:not "found"})
           {:status 404 :headers @{"Content-Type" "application/json"} :body @"{\"not\":\"found\"}"})))

(deftest "bad-request"
  (test "returns bad request response"
        (deep= (response/bad-request {:bad "request"})
           {:status 400 :headers @{"Content-Type" "application/json"} :body @"{\"bad\":\"request\"}"})))

(deftest "not-authorized"
  (test "returns not authorized response"
        (deep= (response/not-authorized {:not "authorized"})
           {:status 401 :headers @{"Content-Type" "application/json"} :body @"{\"not\":\"authorized\"}"})))

(deftest "not-supported"
  (test "returns not supported response"
        (deep= (response/not-supported {:not "supported"})
           {:status 415 :headers @{"Content-Type" "application/json"} :body @"{\"not\":\"supported\"}"})))

(deftest "method-not-allowed"
  (test "returns method not allowed response"
        (deep= (response/method-not-allowed {:not "allowed"})
           {:status 405 :headers @{"Content-Type" "application/json"} :body @"{\"not\":\"allowed\"}"})))

(deftest "not-implemented"
  (test "returns not implemented response"
        (deep= (response/not-implemented {:not "implemented"})
           {:status 501 :headers @{"Content-Type" "application/json"} :body @"{\"not\":\"implemented\"}"})))

(deftest "success"
  (test "returns success response"
        (deep= (response/success {:is "success"})
           {:status 200 :headers @{"Content-Type" "application/json"} :body @"{\"is\":\"success\"}"})))

(deftest "created"
  (test "returns created response"
        (deep= (response/created {:is "created"})
           {:status 201 :headers @{"Content-Type" "application/json"} :body @"{\"is\":\"created\"}"})))



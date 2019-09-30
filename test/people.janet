(import tester :prefix "")
(import json)
(import ../chidi/http/fetch :as fetch)

(import ../chidi/people/setup :as setup)
(import ./utils :prefix "")

(def db-file "chidi.test.db")

(setup/perform db-file)


(deftest "All people response"
  (def response (fetch/get (on-server "people")))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid JSON" (indexed? decoded))
  (test "First is map" (dictionary? (first decoded)))
  (test "Has right name" (= ((first decoded) "name") "John Doe")))

(deftest "One person response"
  (def response (fetch/get (on-server "people/1")))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (test "Has right name" (= (decoded "name") "John Doe")))

(deftest "Create one person"
  (def response (fetch/post (on-server "people") 
                            (json/encode {:name "Nu One" :phone "66666666" :gender "all"})))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (test "Has right name" (= (decoded "name") "Nu One"))
  (def all-people (json/decode (fetch/get (on-server "people"))))
  (test "There should be 8 people" (= (length all-people) 8)))

(deftest "Update one person"
  (def response (fetch/patch (on-server "people/2") 
                            (json/encode {:name "Nu One" :phone "66666666" :gender "all"})))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (def message (decoded "message"))
  (test "Has message" (string? message))
  (test "Has message person was updated" (string/find "was successfuly updated" message)))

(deftest "Delete one person"
  (def response (fetch/delete (on-server "people/7")))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid JSON" (dictionary? decoded))
  (def message (decoded "message"))
  (test "Has message" (string? message))
  (test "Has message person was updated" (string/find "was successfuly deleted" message))
  (def all-people (json/decode (fetch/get (on-server "people"))))
  (test "There should be 7 people" (= (length all-people) 7)))

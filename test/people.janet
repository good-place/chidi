(import tester :prefix "")
(import json)
(import http/fetch :as fetch)

(import server)
(import people/setup)

(def db-file "people.test.db")

(people/setup/perform db-file)

(def s (fiber/new (server/main 8140 db-file)))


(deftest "All people response"
  (def response (fetch/get "http://127.0.0.1:8130/people"))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid JSON" (indexed? decoded))
  (test "First is map" (dictionary? (first decoded)))
  (test "Has right name" (= ((first decoded) "name") "John Doe")))

(deftest "One person response"
  (def response (fetch/get "http://127.0.0.1:8130/people/1"))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (test "Has right name" (= (decoded "name") "John Doe")))

(deftest "Create one person"
  (def response (fetch/post "http://127.0.0.1:8130/people" 
                            (json/encode {:name "Nu One" :phone "66666666" :gender "all"})))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (test "Has right name" (= (decoded "name") "Nu One"))
  (def all-people (json/decode (fetch/get "http://127.0.0.1:8130/people")))
  (test "There should be 8 people" (= (length all-people) 8)))

(deftest "Update one person"
  (def response (fetch/patch "http://127.0.0.1:8130/people/2" 
                            (json/encode {:name "Nu One" :phone "66666666" :gender "all"})))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid json" (dictionary? decoded))
  (def message (decoded "message"))
  (test "Has message" (string? message))
  (test "Has message person was updated" (string/find "was successfuly updated" message)))

(deftest "Delete one person"
  (def response (fetch/delete "http://127.0.0.1:8130/people/7"))
  (test "Non empty response" (not (empty? response)))
  (def decoded (json/decode response))
  (test "Valid JSON" (dictionary? decoded))
  (def message (decoded "message"))
  (test "Has message" (string? message))
  (test "Has message person was updated" (string/find "was successfuly deleted" message))
  (def all-people (json/decode (fetch/get "http://127.0.0.1:8130/people")))
  (test "There should be 7 people" (= (length all-people) 7)))

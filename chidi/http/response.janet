(import json)

(def any-content-type "*/*")

(def json-content-type "application/json")

(defn response 
  "Creates response struct"
  [code body &opt headers]
  (default headers @{})
  (let [headers (merge headers {"Content-Type" json-content-type})]
    {:status code
     :headers headers
     :body (json/encode body)}))

(defn not-found
  "Returns not found response"
  [body &opt headers]
  (response 404 body headers))

(defn bad-request
  "Returns not found response"
  [body &opt headers]
  (response 400 body headers))

(defn not-authorized
  "Returns not autorized response"
  [body &opt headers]
  (response 401 body headers))

(defn not-supported 
  "Returns not supported media type response"
  [body &opt headers]
  (response 415 body headers))

(defn method-not-allowed
  "Returns not allowed method type response"
  [body &opt headers]
  (response 405 body headers))

(defn not-implemented
  "Returns not implemented method type response"
  [body &opt headers]
  (response 501 body headers))

(defn success [body &opt headers]
  "Return success response "
  (response 200 body headers))

(defn created [body &opt headers]
  "Return created response "
  (response 201 body headers))



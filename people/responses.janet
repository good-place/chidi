(import utils :as u)
(import http/response :as hr)
(import http/utils :as hu)
(import sql/utils :as su)

(defn- many-get [qp]
  (let [records (if qp 
                      (su/find-records "people" (u/select-keys qp [:name :phone :gender])) 
                      (su/get-records "people"))]
        (hr/success records)))

(defn many
  "Renders many people"
  [req]
  (let [method (hu/get-method req)]
    (case method
      :get (many-get (req :query-params))
      :post (hr/not-implemented {:message (string/join ["Sorry" method "method is not implemented yet."] " ")}))))

(defn one
  "Renders one person"
  [req]
  (if-let [id (scan-number ((req :params) :id))]
    (let [record (su/get-record "people" id)]
      (if record
        (hr/success record {"Content-Type" "application/json"})
        (hr/not-found req)))
    (hr/bad-request "ID has bad type, it should be number.")))

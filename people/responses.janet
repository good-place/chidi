(import utils :as u)
(import http/response :as hr)
(import http/utils :as hu)
(import sql/utils :as su)

(defn- allowed-keys [d]
  (u/select-keys d [:name :phone :gender]))

(defn- many-get [qp]
  (let [records (if qp 
                      (su/find-records "people" (allowed-keys qp)) 
                      (su/get-records "people"))]
        (hr/success records)))

(defn- many-post [body]
  (let [id (su/insert "people" (allowed-keys body))
        p (su/get-record "people" id)]
   (hr/created p {"Location" (string "/people/" id)})))

(defn many
  "Renders many people"
  [req]
  (let [method (hu/get-method req)]
    (case method
      :get (many-get (req :query-params))
      :post (many-post (req :body)))))

(defn- one-get [id]
  (let [record (su/get-record "people" id)]
      (if record
        (hr/success record)
        (hr/not-found {:message (string "Person with id " id " has not been found")}))))

(defn one-patch
  [id body]
  (su/update :people id body)
  (hr/success {:message (string "Person id " id " was successfuly updated")}))

(defn one
  "Renders one person"
  [req]
  (if-let [id (scan-number ((req :params) :id))]
    (let [method (hu/get-method req)]
      (case method
        :get (one-get id)
        :patch (one-patch id (allowed-keys (req :body)))))
    (hr/bad-request "ID has bad type, it should be number.")))

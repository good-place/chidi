(import chidi/utils :as u)
(import chidi/http/response :as hr)
(import chidi/http/utils :as hu)
(import chidi/http/body :prefix "")
(import chidi/http/query-params :prefix "")
(import chidi/http/methods :as hm)
(import chidi/sql/utils :as su)

(def sqt "SQL table this service uses" :people)

(defn- allowed-keys [d]
  (u/select-keys d [:name :phone :gender]))

(defn- many-get [qp]
  (let [records (if qp 
                      (su/find-records sqt (allowed-keys qp)) 
                      (su/get-records sqt))]
        (hr/success records)))

(defn- many-post [body]
  (let [id (su/insert sqt (allowed-keys body))
        p (su/get-record sqt id)]
   (hr/created p {"Location" (string "/people/" id)})))

(defn many
  "Renders many people"
  [req]
  (let [method (hu/get-method req)]
    (case method
      :get (many-get (req :query-params))
      :post (many-post (req :body)))))

(defn- one-get [id]
  (let [record (su/get-record sqt id)]
      (if record
        (hr/success record)
        (hr/not-found {:message (string "Person with id " id " has not been found")}))))

(defn- one-patch
  [id body]
  (su/update sqt id body)
  (hr/success {:message (string "Person id " id " was successfuly updated")}))

(defn- one-delete [id]
  (su/delete sqt id)
  (hr/success {:message (string "Person id " id " was successfuly deleted")}))

(defn one
  "Renders one person"
  [req]
  (if-let [id (scan-number ((req :params) :id))]
    (let [method (hu/get-method req)]
      (case method
        :get (one-get id)
        :patch (one-patch id (allowed-keys (req :body)))
        :delete (one-delete id)))
    (hr/bad-request "ID has bad type, it should be number.")))

(def routes
  {"/people" (-> many (hm/guards :get :post) body query-params)
   "/people/:id" (-> one (hm/guards :get :patch :delete) body)})


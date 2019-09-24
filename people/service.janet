(import utils)
(import http/response :as hr)
(import http/util)
(import http/body :prefix "")
(import http/query-params :prefix "")
(import http/methods :as hm)
(import sql/utils)
(import service)

(service/defservice :people {:allowed-keys [:name]})

(service/many [:get :post])

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
  # {"/people" (-> many (hm/guards :get :post) body query-params)
   # "/people/:id" (-> one (hm/guards :get :patch :delete) body)}
 {} )


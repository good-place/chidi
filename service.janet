(import utils)

# Proposed macro api
# (defservice 
# name of the service if map key is the name, value is singular name
#   {:people "person"}  
# optional, when not set name is used
#   {:table :people 
# optional keys allowed for modificaiton actions
#    :allowed-keys [:name :phone :gender]}
# optional allowed methods
#   {:many [:get :post] 
#    :one [:get :patch :delete]})

(defmacro defservice 
  "Defines new service" # TODO document
  [name &opt storage methods] 
  ~(tuple
     (def sqt ,(or (storage :table) name))
     ,(if-let [ak (storage :allowed-keys)] 
        ~(defn allowed-keys [d] (utils/select-keys d ,(storage :allowed-keys)))
        '(defn allowed-keys [&] identity))
      '(defn- one-get [id]
        (let [record (su/get-record sqt id)]
            (if record
              (hr/success record)
              (hr/not-found {:message (string "Person with id " id " has not been found")}))))
      '(defn- one-patch
        [id body]
        (su/update sqt id body)
        (hr/success {:message (string "Person id " id " was successfuly updated")}))
      '(defn- one-delete [id]
        (su/delete sqt id)
        (hr/success {:message (string "Person id " id " was successfuly deleted")}))
      '(defn one [req]
        (if-let [id (scan-number ((req :params) :id))]
          (let [method (hu/get-method req)]
            (case method
              :get (one-get id)
              :patch (one-patch id (allowed-keys (req :body)))
              :delete (one-delete id)))
          (hr/bad-request "ID has bad type, it should be number.")))))


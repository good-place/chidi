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
(import chidi/utils :as utils)
(import chidi/sql/utils :as sql/utils)
(import chidi/http/response :as http/response)
(import chidi/http/utils :as http/utils)

(defmacro defservice
  "Defines new service" # @todo document
  [name &opt storage] 
  (default storage {})
  ~(tuple
     (def name ,name)
     (def sqt ,(or (storage :table) name))
     ,(if-let [ak (storage :allowed-keys)] 
        ~(defn allowed-keys [d] (,utils/select-keys d ,(storage :allowed-keys)))
        '(defn allowed-keys [&] identity))))

(defmacro many 
  "Add handler for req on many resources"
  [methods] 
  ~(defn many [req]
     (let [{:method method :query-params qp :body body} req]
       (case method
        "GET" ,(if (some |(= $ :get) methods) 
                ~(let [records (if qp
                                 (,sql/utils/find-records sqt (allowed-keys qp)) 
                                 (,sql/utils/get-records sqt))]
                   (,http/response/success records))
                ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
        "POST" ,(if (some |(= $ :post) methods)
                 ~(let [id (,sql/utils/insert sqt (allowed-keys body))
                        p (,sql/utils/get-record sqt id)]
                    (,http/response/created p {"Location" (string "/" name "/" id)}))
                 ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}) )))))

(defmacro one 
  "Add handler for req on one resouce"
  [methods]
  ~(defn one [req]
     (let [{:method method :query-params qp :body body :params {:id id}} req]
       (case method
        "GET" ,(if (some |(= $ :get) methods) 
                ~(let [record (,sql/utils/get-record sqt id)]
                   (if record 
                     (,http/response/success record)
                     (,http/response/not-found {:message (string "Person with id " id " has not been found")})))
                ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
        "PATCH" ,(if (some |(= $ :patch) methods)
                 ~(do 
                    (,sql/utils/update sqt id body)
                    (,http/response/success {:message (string "Person id " id " was successfuly updated")}))
                 ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))
        "DELETE" ,(if (some |(= $ :delete) methods)
                   ~(do 
                      (,sql/utils/delete sqt id)
                      (,http/response/success {:message (string "Person id " id " was successfuly deleted")}))
                   ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))))))

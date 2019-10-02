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
  [name &opt storage] 
  ~(tuple
     (def name ,name)
     (def sqt ,(or (storage :table) name))
     ,(if-let [ak (storage :allowed-keys)] 
        ~(defn allowed-keys [d] (utils/select-keys d ,(storage :allowed-keys)))
        '(defn allowed-keys [&] identity))))

(defmacro many 
  "Add handler for req on many"
  [methods] 
  ~(defn many [req]
            ,(pp (seq [method :in methods]
                 (case method 
                   :get 
                   '(defn- many-get [qp]
                      (let [records (if qp
                                      (sql/utils/find-records sqt (allowed-keys qp)) 
                                      (sql/utils/get-records sqt))]
                        (http/utils/success records)))
                   :post
                   '(defn- many-post [body]
                      (let [id (sql/utils/insert sqt (allowed-keys body))
                            p (sql/utils/get-record sqt id)]
                        (http/utils/created p {"Location" (string "/" name "/" id)}))))))

            ;,(freeze (keep identity
                    (seq [method :in methods]
                         (case method 
                           :get 
                           '(defn- many-get [qp]
                              (let [records (if qp
                                              (sql/utils/find-records sqt (allowed-keys qp)) 
                                              (sql/utils/get-records sqt))]
                                (http/response/success records)))
                           :post
                           '(defn- many-post [body]
                              (let [id (sql/utils/insert sqt (allowed-keys body))
                                    p (sql/utils/get-record sqt id)]
                                (http/response/created p {"Location" (string "/" name "/" id)})))))))  
         (let [method (http/utils/get-method req)]
             (case method
               :get (many-get (req :query-params))
               :post (many-post (req :body))))))


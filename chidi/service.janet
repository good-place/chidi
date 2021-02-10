# @todo test
(import chidi/http/response :as http/response)

(defmacro defservice
  "Defines new service" # @todo document
  [name]
  ~(tuple
     (def name ,name)
     (defn visitor []
       (:visit (reception) "pp"))))

(defmacro- has-method [methods]
  ~(defn has-method? [method] (some |(= $ method) ,methods)))

(defmacro many
  "Add handler for req on many resources"
  [methods]
  (has-method methods)
  ~(defn many [req]
     (tracev (visitor))
     (let [{:method method :query-params qp :body body} req]
       (case method
         "GET" ,(if (has-method? :get)
                  ~(let [records (if qp
                                   (:retrieve (visitor) (string name) qp @{:id? true})
                                   (:retrieve (visitor) (string name) :all @{:id? true}))]
                     (,http/response/success records))
                  ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
         "POST" ,(if (has-method? :post)
                   ~(let [id (:save (visitor) (string name) body)
                          p (:load (visitor) (string name) id)]
                      (,http/response/created p {"Location" (string "/" name "/" id)}))
                   ~(,http/response/method-not-allowed {:message "Method POST is not allowed"}))))))

(defmacro one
  "Add handler for req on one resouce"
  [methods]
  (has-method methods)
  ~(defn one [req]
     (let [{:method method :query-params qp :body body :params {:id id}} req]
       (case method
         "GET" ,(if (has-method? :get)
                  ~(let [record (:load (visitor) (string name) id)]
                     (if record
                       (,http/response/success record)
                       (,http/response/not-found {:message (string name " with id " id " has not been found")})))
                  ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
         "PATCH" ,(if (has-method? :patch)
                    ~(do
                       (:save (visitor) (string name) id body)
                       (,http/response/success {:message (string name " id " id " was successfuly updated")}))
                    ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))
         "DELETE" ,(if (has-method? :delete)
                     ~(do
                        (:save (visitor) (string name) [id nil])
                        (,http/response/success {:message (string name " id " id " was successfuly deleted")}))
                     ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))))))

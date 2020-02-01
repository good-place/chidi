# @todo test
(import chidi/utils :as utils)
(import chidi/sql/utils :as sql/utils)
(import chidi/http/response :as http/response)

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

(defmacro- has-method [methods]
  ~(defn has-method? [method] (some |(= $ method) ,methods)))

(defmacro many
  "Add handler for req on many resources"
  [methods]
  (has-method methods)
  ~(defn many [req]
     (let [{:method method :query-params qp :body body} req]
       (case method
        "GET" ,(if (has-method? :get)
                ~(let [records (if qp
                                 (,sql/utils/find-records sqt (allowed-keys qp))
                                 (,sql/utils/get-records sqt))]
                   (,http/response/success records))
                ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
        "POST" ,(if (has-method? :post)
                 ~(let [id (,sql/utils/insert sqt (allowed-keys body))
                        p (,sql/utils/get-record sqt id)]
                    (,http/response/created p {"Location" (string "/" name "/" id)}))
                 ~(,http/response/method-not-allowed {:message "Method POST is not allowed"}) )))))

(defmacro one
  "Add handler for req on one resouce"
  [methods]
  (has-method methods)
  ~(defn one [req]
     (let [{:method method :query-params qp :body body :params {:id id}} req]
       (case method
        "GET" ,(if (has-method? :get)
                ~(let [record (,sql/utils/get-record sqt id)]
                   (if record
                     (,http/response/success record)
                     (,http/response/not-found {:message (string "Person with id " id " has not been found")})))
                ~(,http/response/method-not-allowed {:message "Method GET is not allowed"}))
        "PATCH" ,(if (has-method? :patch)
                 ~(do
                    (,sql/utils/update sqt id body)
                    (,http/response/success {:message (string "Person id " id " was successfuly updated")}))
                 ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))
        "DELETE" ,(if (has-method? :delete)
                   ~(do
                      (,sql/utils/delete sqt id)
                      (,http/response/success {:message (string "Person id " id " was successfuly deleted")}))
                   ~(,http/response/method-not-allowed {:message "Method PATCH is not allowed"}))))))

(import curl)

(defn get
  "Simple url fetch. Returns string with the content of the resource."
 [url] 
  (let [c (curl/easy/init)
        res (buffer)]
    (:setopt c
            :url url
            :write-function |(buffer/push-string res $)
            :http-header @["Content-Type=application/json"]
            :no-progress? true)
    (:perform c)
    (string res)))

(defn post 
  "Posts body to url"
  [url body]
  (let [c (curl/easy/init)
        res (buffer)]
    (:setopt c
            :url url
            :write-function |(buffer/push-string res $)
            :http-header @["Content-Type=application/json"]
            :post? true
            :post-field-size (length body)
            :post-fields (string body)
            :no-progress? true)
    (:perform c)
    (string res)))

(defn patch
  "Patch with body on url"
  [url body]
  (let [c (curl/easy/init)
        res (buffer)]
    (:setopt c
            :url url
            :write-function |(buffer/push-string res $)
            :http-header @["Content-Type=application/json"]
            :custom-request "PATCH"
            :post-field-size (length body)
            :post-fields (string body)
            :no-progress? true)
    (:perform c)
    (string res)))

(defn delete
  "Delete on url"
 [url] 
  (let [c (curl/easy/init)
        res (buffer)]
    (:setopt c
            :url url
            :write-function |(buffer/push-string res $)
            :http-header @["Content-Type=application/json"]
            :custom-request "DELETE"
            :no-progress? true)
    (:perform c)
    (string res)))


(import curl)

(defn from
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


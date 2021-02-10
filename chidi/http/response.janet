(def status-messages
  ```
  Struct with numeric keys of status codes
  with values of string messages
  ```
  {100 "Continue" 101 "Switching Protocols"
   200 "OK" 201 "Created" 202 "Accepted" 203 "Non-Authoritative Information"
   204 "No Content" 205 "Reset Content" 206 "Partial Content"
   300 "Multiple Choices" 301 "Moved Permanently" 302 "Found" 303 "See Other"
   304 "Not Modified" 305 "Use Proxy" 307 "Temporary Redirect"
   400 "Bad Request" 401 "Unauthorized" 402 "Payment Required"
   403 "Forbidden" 404 "Not Found" 405 "Method Not Allowed"
   406 "Not Acceptable" 407 "Proxy Authentication Required"
   408 "Request Time-out" 409 "Conflict" 410 "Gone" 411 "Length Required"
   412 "Precondition Failed" 413 "Request Entity Too Large"
   414 "Request-URI Too Large" 415 "Unsupported Media Type"
   416 "Requested range not satisfiable" 417 "Expectation Failed"
   500 "Internal Server Error" 501 "Not Implemented"
   502 "Bad Gateway" 503 "Service Unavailable"
   504 "Gateway Time-out" 505 "HTTP Version not supported"})

(def- mime-types
  {".txt" "text/plain"
   ".css" "text/css"
   ".js" "application/javascript"
   ".json" "application/json"
   ".xml" "text/xml"
   ".svg" "image/svg+xml"
   ".jpg" "image/jpeg"
   ".jpeg" "image/jpeg"
   ".gif" "image/gif"
   ".png" "image/png"
   ".wasm" "application/wasm"})

(defn http
  `Turns a response dictionary into an http response string`
  [{:status status :body body :headers headers}]
  (default status 200)
  (default body "")
  (default headers {})
  (def fh @"")
  (xprinf fh "HTTP/1.1 %d %s\r\n"
          status (get status-messages status "Unknown Status Code"))
  (loop [[n c] :pairs
         (merge {"Content-Length" (string (length body))
                 "Content-Type" (mime-types ".txt")}
                headers)]
    (xprinf fh "%s: %s\r\n"
            (string n) (if (indexed? c) (string/join c ",") (string c))))
  (unless (empty? body)
    (xprin fh "\r\n")
    (xprin fh (string body)))
  (freeze fh))

(defn response
  "Creates response struct"
  [code body &opt headers]
  (default headers @{})
  (http
    {:status code
     :headers headers
     :body body}))

(defn not-found
  "Returns not found response"
  [&opt body headers]
  (default body (status-messages 404))
  (response 404 body headers))

(defn bad-request
  "Returns not found response"
  [&opt body headers]
  (default body (status-messages 400))
  (response 400 body headers))

(defn not-authorized
  "Returns not autorized response"
  [&opt body headers]
  (default body (status-messages 401))
  (response 401 body headers))

(defn not-supported
  "Returns not supported media type response"
  [&opt body headers]
  (default body (status-messages 415))
  (response 415 body headers))

(defn method-not-allowed
  "Returns not allowed method type response"
  [&opt body headers]
  (default body (status-messages 405))
  (response 405 body headers))

(defn internal-server-error
  "Returns internal server error response"
  [&opt body headers]
  (default body (status-messages 500))
  (response 500 body headers))

(defn not-implemented
  "Returns not implemented method type response"
  [&opt body headers]
  (default body (status-messages 501))
  (response 501 body headers))

(defn success [&opt body headers]
  "Return success response"
  (default body (status-messages 200))
  (response 200 body headers))

(defn created [&opt body headers]
  "Return created response"
  (default body (status-messages 201))
  (response 201 body headers))

(defn internal-error-supervisor [chan stream]
  ```
  Standart internal error function.
  ```
  (match (ev/take chan)
    [:error e]
    (do
      (print (fiber/last-value e))
      (:write stream (internal-server-error)))))

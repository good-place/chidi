(def status-messages
  ```
  Tuple which contains numeric keys with status codes
  with values with string messages
  ```
  {100 "Continue"
   101 "Switching Protocols"
   200 "OK"
   201 "Created"
   202 "Accepted"
   203 "Non-Authoritative Information"
   204 "No Content"
   205 "Reset Content"
   206 "Partial Content"
   300 "Multiple Choices"
   301 "Moved Permanently"
   302 "Found"
   303 "See Other"
   304 "Not Modified"
   305 "Use Proxy"
   307 "Temporary Redirect"
   400 "Bad Request"
   401 "Unauthorized"
   402 "Payment Required"
   403 "Forbidden"
   404 "Not Found"
   405 "Method Not Allowed"
   406 "Not Acceptable"
   407 "Proxy Authentication Required"
   408 "Request Time-out"
   409 "Conflict"
   410 "Gone"
   411 "Length Required"
   412 "Precondition Failed"
   413 "Request Entity Too Large"
   414 "Request-URI Too Large"
   415 "Unsupported Media Type"
   416 "Requested range not satisfiable"
   417 "Expectation Failed"
   500 "Internal Server Error"
   501 "Not Implemented"
   502 "Bad Gateway"
   503 "Service Unavailable"
   504 "Gateway Time-out"
   505 "HTTP Version not supported"})

(def mime-types
  ```
  Tuple which contains extension keys with values of mime types
  ```
  {".txt" "text/plain"
   ".css" "text/css"
   ".js" "application/javascript"
   ".json" "application/json"
   ".xml" "text/xml"
   ".html" "text/html"
   ".svg" "image/svg+xml"
   ".jpg" "image/jpeg"
   ".jpeg" "image/jpeg"
   ".gif" "image/gif"
   ".png" "image/png"
   ".wasm" "application/wasm"})

(def MAX_SIZE 8_192) # 8k max body size
(def CRLF_2 "\r\n\r\n")

(defn- capr [[m u v]]
  {:method m
   :uri u
   :http-version v})

(defn- caph [[n c]] {n c})

(defn- colhs [hs] (merge ;hs))

(def request-grammar
  (peg/compile
    ~{:sp " "
      :crlf "\r\n"
      :http "HTTP/"
      :request (/ (* '(to :sp) :sp '(to :sp) :sp :http '(to :crlf) :crlf) ,capr)
      :headers (/ (* '(to ":") ": " '(to :crlf) :crlf) ,caph)
      :headers (/ (* (some :header) :crlf) ,colhs)
      :main (sequence :request :headers)}))

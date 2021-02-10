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

(def max-size 8192) # 8k max request size

(defn- caprl [m u v]
  {:method m
   :uri u
   :http-version v})
(defn- caph [n c] {n c})
(defn- colhs [& hs] {:headers (freeze (merge ;hs))})
(defn- capb [b] {:body b})
(defn- colr [& xs] (freeze (merge ;xs)))
(def request-grammar
  (peg/compile
    ~{:sp " "
      :crlf "\r\n"
      :http "HTTP/"
      :to-sp (* '(to :sp) :sp)
      :to-crlf (* '(to :crlf) :crlf)
      :request (/ (* :to-sp :to-sp :http :to-crlf) ,caprl)
      :header (/ (* '(to ":") ": " :to-crlf) ,caph)
      :headers (/ (* (some :header) :crlf) ,colhs)
      :body (/ '(any (if-not -1 1)) ,capb)
      :main (/ (* :request :headers :body) ,colr)}))

(defn parse-request [r]
  `Parses the http request into request struct`
  ((peg/match request-grammar r) 0))

(defn http-response
  `Turns a response dictionary into an http response string`
  [{:status status :body body :headers headers}]
  (default status 200)
  (default body "")
  (default headers {})
  (defn- freeze-headers []
    (def fh @"")
    (def hs (merge {"Content-Length" (string (length body))
                    "Content-Type" "text/plain"}
                   headers))
    (loop [[n c] :pairs hs]
      (buffer/push
        fh (string/format "%s: %s\r\n" (string n)
                          (if (indexed? c) (string/join c ",") (string c)))))
    (freeze fh))
  (def status-message (get status-messages status "Unknown Status Code"))
  (def headers (freeze-headers))
  (string/format "HTTP/1.1 %d %s\r\n%s\r\n%s"
                 status status-message headers (string body)))

(defn on-connection
  ```
  A handler for the connection.
  It has one argument with the user function, that will handle connections.
  Returns function for handling incomming stream.
  ```
  [handler]
  (fn [stream]
    (def buf @"")
    (def request (:read stream max-size buf))
    (def req (parse-request request))
    (->> req
         handler
         http-response
         (:write stream))))


(def supervisor (ev/chan))

(defn start [handler &opt host port]
  (default host "localhost")
  (default port "8888")

  (printf "Chidi takes care of %s:%s" host port)
  (def server (net/listen host port))
  (def handler (on-connection handler))
  (forever
    (def stream (:accept server))
    (defer (:close stream)
      (ev/go (fiber/new (fn [] (handler stream)) :t) nil supervisor)

      (match (ev/take supervisor)
        [:error e]
        (do
          (print (fiber/last-value e))
          (:write stream (http-response {:status 500
                                         :body "Internal server error"})))))))

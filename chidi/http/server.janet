(import /chidi/http/response :prefix "" :export true)

(defn- caprl [m u q v]
  {:method m
   :uri u
   :query-string q
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
      :request (/ (* :to-sp '(to (+ "?" :sp))
                     (any "?") :to-sp :http :to-crlf) ,caprl)
      :header (/ (* '(to ":") ": " :to-crlf) ,caph)
      :headers (/ (* (some :header) :crlf) ,colhs)
      :body (/ '(any (if-not -1 1)) ,capb)
      :main (/ (* :request :headers :body) ,colr)}))

(defn parse-request [r]
  `Parses the http request into request struct`
  ((peg/match request-grammar r) 0))

(defn ensure-length [r]
  (assert (= (length (r :body))
             (scan-number (get-in r [:headers "Content-Length"] 0)))
          "Content-Length differs from actual length of body"))

(defn on-connection
  ```
  A handler for the connection.
  It has one argument with the user function, that will handle connections.
  Returns function for handling incomming stream.
  ```
  [handler]
  (fn [stream]
    (->> (net/read stream 4096) # 4 KB is enough for everyone
         parse-request
         tracev
         ensure-length
         handler
         (:write stream))))

(defn start [handler &opt host port supervisor]
  ```
  Main function user want to use.
  It takes handler function, which will be called with every new connection.
  It argument will be request dictionary. Function must return
  http-response string.

  It also takes three optional arguments:
  - host on which server starts. Default localhost
  - port on which server starts. Default 8888
  - supervisor function which will supervise the supervisor-channel,
    after each connection. Default internal-error-supervisor from response
  ```
  (default host "localhost")
  (default port "8888")
  (default supervisor internal-error-supervisor)
  (def chan (ev/chan))

  (printf "Chidi takes care of %s:%s" host port)
  (def server (net/listen host port))
  (def handler (on-connection handler))
  (forever
    (with [stream (:accept server)]
      (ev/go (fiber/new (fn [] (handler stream)) :t) nil chan)
      (supervisor chan stream))))

# @todo test
(import chidi/http/fetch :as fetch)

(var test-host "http://localhost")

(with [f (file/open ".test-port" :r)]
   (set test-host (file/read f :all)))

(defn on-server [&opt path]
  (string "http://localhost:" port "/" (or path "")))

(defn ensure-running-server []
  (when (empty? (fetch/get (on-server)))
   (error "It looks like your test server is not running. Run it with `./chd test-server`")))



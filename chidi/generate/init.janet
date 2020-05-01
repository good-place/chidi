(import path)
(import temple)
(import mansion/store :as store)

(temple/add-loader)

(import chidi/generate/db-service :as db-service)
(import chidi/generate/common-service :as common-service)
(import chidi/generate/project :as project)
(import chidi/generate/app-init :as app-init)

(defmacro with-file-out [file & body]
  (with-syms [f]
    ~(with [,f (file/open ,file :w)]
       (with-dyns [:out ,f] ,;body))))

(defn service
  "Generates service stub"
  [service-name &opt {:to-index to-index :app-path app-path}]
  (default to-index [])
  (default app-path ".")
  (print "Generating new service -> " service-name " <-")
  (os/mkdir (path/join app-path "app" service-name))
  (with-file-out (path/join app-path "app" service-name "service.janet")
    (if (= service-name "common")
      (common-service/render)
      (with [s (store/create service-name @{:to-index to-index})]
        (db-service/render :name service-name)))))

(defn app
  "Generates app directory structure"
  [name]
  (print "Generating new app -> " name " <-")
  (os/mkdir name)
  (os/mkdir (path/join name "app"))
  (with-file-out (path/join name "project.janet")
    (project/render :name name))
  (with-file-out (path/join name "app" "init.janet")
    (app-init/render))
  (service "common" {:app-path name})
  (print "App " name " generated")
  (printf "To start work with it cd %s and run chd --help" name))


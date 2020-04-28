(import path)
(import temple)

(temple/add-loader)

(import chidi/generate/setup :as setup)
(import chidi/generate/db-service :as db-service)
(import chidi/generate/common-service :as common-service)
(import chidi/generate/project :as project)
(import chidi/generate/app-init :as app-init)

(defmacro with-file-out [file & body]
  (with-syms [f]
    ~(with [,f (file/open ,file :w)]
       (with-dyns [:out ,f] ,;body))))

(defn setup
  "Generates service setup"
  [service-name]
  (print "Generating new setup for -> " service-name " <-")
  (with-file-out (path/join "app" service-name "setup.janet")
    (setup/render :name service-name)))

(defn service
  "Generates service stub"
  [service-name &opt app-path]
  (default  app-path ".")
  (print "Generating new service -> " service-name " <-")
  (os/mkdir (path/join app-path "app" service-name))
  (with-file-out (path/join app-path "app" service-name "service.janet")
    (if (= service-name "common")
          (common-service/render)
          (db-service/render :name service-name))))

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
  (service "common" name)
  (print "App " name " generated")
  (printf "To start work with it cd %s and run chd --help" name))


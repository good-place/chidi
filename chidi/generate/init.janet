(import path)
(import temple)

(temple/add-loader)
(import chidi/generate/setup :as setup)
(import chidi/generate/db-service :as db-service)
(import chidi/generate/common-service :as common-service)
(import chidi/generate/project :as project)
(import chidi/generate/app-init :as app-init)


(defn setup
  "Generates service setup"
  [service-name]
  (print "Generating new setup for -> " service-name " <-")
  (with [f (file/open (path/join "app" service-name "setup.janet") :w)]
    (setdyn :out f)
    (setup/render :name service-name)))

(defn service
  "Generates service stub"
  [service-name &opt app-path]
  (default  app-path ".")
  (print "Generating new service -> " service-name " <-")
  (os/mkdir (path/join app-path "app" service-name))
  (with [f (file/open (path/join app-path "app" service-name "service.janet") :w)]
    (with-dyns [:out f]
      (if (= service-name "common")
          (common-service/render)
          (db-service/render :name service-name)))))

(defn app
  "Generates app directory structure"
  [name]
  (print "Generating new app -> " name " <-")
  (os/mkdir name)
  (os/mkdir (path/join name "app"))
  (with [f (file/open (path/join name "project.janet") :w)]
    (with-dyns [:out f] (project/render :name name)))
  (with [f (file/open (path/join name "app" "init.janet") :w)]
    (with-dyns [:out f] (app-init/render)))
  (service "common" name)
  (print "App " name " generated")
  (print "To start work with it cd " name " and run chd --help"))


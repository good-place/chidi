(import path)

(import chidi/generate/common-service :as common-service)
(import chidi/generate/db-service :as db-service)
(import chidi/generate/app-init :as app-init)
(import chidi/generate/setup :as setup)
(import chidi/generate/project :as project)

(defn service 
  "Generates service stub"
  [service-name &opt app]
  (default  app ".")
  (os/mkdir (path/join app "app" service-name))
  (with [f (file/open (path/join app "app" service-name "service.janet") :w)]
    (file/write f 
                (if (= service-name "common") 
                    common-service/content 
                    (db-service/content service-name)))))

(defn app 
  "Generates app directory structure"
  [name]
  (print "Generating new app -> " name " <-")
  (os/mkdir name)
  (os/mkdir (path/join name "app"))
  (with [f (file/open (path/join name "project.janet") :w)]
     (file/write f (project/content name)))
  (with [f (file/open (path/join name "app" "init.janet") :w)]
     (file/write f app-init/content))
  (service "common" name)
  (print "App " name " generated")
  (print "To start work with it cd " name " and run chd --help"))

(defn setup 
  "Generates service setup"
  [service-name]
  (with [f (file/open (path/join "app" service-name "setup.janet") :w)]
       (file/write f (setup/content service-name))))

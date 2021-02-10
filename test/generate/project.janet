(import spork/temple :prefix "")
(import spork/test :prefix "")

(add-loader)
(import ../../chidi/generate/project)

(start-suite 8)

(assert (= (project/render :name "test") "render"))

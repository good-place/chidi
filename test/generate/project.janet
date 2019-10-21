(import tester :prefix "")
(import chidi/generate/project)

(deftest "generating"
  (test "content" 
        (= (chidi/generate/project/content "test")
           ``(declare-project
  :name "test"
  :description "Really great API" # @fixme with some real desc here please
  :dependencies ["https://github.com/pepe/chidi.git"])``)))


(import tester :prefix "")
(import temple)

(temple/add-loader)
(import ../../chidi/generate/project)

(deftest "generating"
  (test "render" (let [b @[]] (with-dyns [:out b] (project/render :name "test") b))))

